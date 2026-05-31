import type { Plugin } from "@opencode-ai/plugin"
import { readFileSync, writeFileSync, existsSync, mkdirSync, unlinkSync } from "fs"
import { join, dirname } from "path"
import { createHash } from "crypto"

/**
 * SimplifyIgnore — protects marked code blocks from /tgd-simplify.
 * OpenCode equivalent of Claude Code's simplify-ignore.sh hook.
 *
 * Mark blocks in source code with:
 *   // simplify-ignore-start: reason
 *   ... protected code ...
 *   // simplify-ignore-end
 *
 * On Read: replaces blocks with BLOCK_<hash> placeholders.
 * On Edit/Write: expands placeholders back, then re-filters.
 * On session.idle: restores all files from backup.
 */
export const SimplifyIgnore: Plugin = async ({ directory }) => {
  const cacheDir = join(directory, ".opencode", ".simplify-ignore-cache")
  const backups = new Map<string, string>() // fileId -> backup path
  const blocks = new Map<string, Map<string, string>>() // fileId -> hash -> content

  const fileId = (path: string) =>
    createHash("sha1").update(path).digest("hex").slice(0, 16)

  const blockHash = (content: string) =>
    createHash("sha1").update(content).digest("hex").slice(0, 8)

  function filterFile(filePath: string): boolean {
    const content = readFileSync(filePath, "utf-8")
    if (!content.includes("simplify-ignore-start")) return false

    const fid = fileId(filePath)
    const fileBlocks = new Map<string, string>()
    const lines = content.split("\n")
    const filtered: string[] = []
    let inBlock = false
    let buf = ""
    let count = 0

    for (const line of lines) {
      if (!inBlock) {
        if (line.includes("simplify-ignore-start")) {
          inBlock = true
          buf = line
          // Check single-line block
          if (line.includes("simplify-ignore-end")) {
            inBlock = false
            const h = blockHash(buf)
            fileBlocks.set(h, buf)
            filtered.push(`BLOCK_${h}`)
            count++
            buf = ""
          }
          continue
        }
        filtered.push(line)
      } else {
        buf += "\n" + line
        if (line.includes("simplify-ignore-end")) {
          inBlock = false
          const h = blockHash(buf)
          fileBlocks.set(h, buf)
          filtered.push(`BLOCK_${h}`)
          count++
          buf = ""
        }
      }
    }

    if (count === 0) return false

    // Backup original
    if (!existsSync(cacheDir)) mkdirSync(cacheDir, { recursive: true })
    const bakPath = join(cacheDir, `${fid}.bak`)
    writeFileSync(bakPath, content, "utf-8")
    backups.set(fid, filePath)
    blocks.set(fid, fileBlocks)

    // Write filtered version
    writeFileSync(filePath, filtered.join("\n"), "utf-8")
    return true
  }

  function expandAndRefilter(filePath: string): void {
    const fid = fileId(filePath)
    const fileBlocks = blocks.get(fid)
    if (!fileBlocks) return

    let content = readFileSync(filePath, "utf-8")

    // Expand all BLOCK_<hash> placeholders
    for (const [h, original] of fileBlocks) {
      content = content.replaceAll(`BLOCK_${h}`, original)
    }

    // Save expanded as new backup
    const bakPath = join(cacheDir, `${fid}.bak`)
    writeFileSync(bakPath, content, "utf-8")

    // Re-filter
    const lines = content.split("\n")
    const filtered: string[] = []
    let inBlock = false
    let buf = ""

    for (const line of lines) {
      if (!inBlock) {
        if (line.includes("simplify-ignore-start")) {
          inBlock = true
          buf = line
          if (line.includes("simplify-ignore-end")) {
            inBlock = false
            const h = blockHash(buf)
            fileBlocks.set(h, buf)
            filtered.push(`BLOCK_${h}`)
            buf = ""
          }
          continue
        }
        filtered.push(line)
      } else {
        buf += "\n" + line
        if (line.includes("simplify-ignore-end")) {
          inBlock = false
          const h = blockHash(buf)
          fileBlocks.set(h, buf)
          filtered.push(`BLOCK_${h}`)
          buf = ""
        }
      }
    }

    writeFileSync(filePath, filtered.join("\n"), "utf-8")
    blocks.set(fid, fileBlocks)
  }

  function restoreAll(): void {
    for (const [fid, filePath] of backups) {
      const bakPath = join(cacheDir, `${fid}.bak`)
      if (existsSync(bakPath)) {
        try {
          const original = readFileSync(bakPath, "utf-8")
          writeFileSync(filePath, original, "utf-8")
          unlinkSync(bakPath)
        } catch {
          // File may have been deleted
        }
      }
    }
    backups.clear()
    blocks.clear()
  }

  return {
    "tool.execute.before": async (input, output) => {
      const tool = input.tool?.toLowerCase() ?? ""
      if (tool === "read") {
        const filePath = output.args?.filePath
        if (filePath && existsSync(filePath)) {
          try {
            filterFile(filePath)
          } catch {
            // Graceful degradation
          }
        }
      }
    },
    "tool.execute.after": async (input, output) => {
      const tool = input.tool?.toLowerCase() ?? ""
      if (tool === "edit" || tool === "write") {
        const filePath = output.args?.filePath
        if (filePath && existsSync(filePath)) {
          try {
            expandAndRefilter(filePath)
          } catch {
            // Graceful degradation
          }
        }
      }
    },
    event: async ({ event }) => {
      if (event.type === "session.idle" || event.type === "session.deleted") {
        restoreAll()
      }
    },
  }
}
