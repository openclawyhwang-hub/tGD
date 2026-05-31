import type { Plugin } from "@opencode-ai/plugin"
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "fs"
import { join } from "path"
import { createHash } from "crypto"

/**
 * SddCache — HTTP cache for source-driven-development WebFetch.
 * OpenCode equivalent of Claude Code's sdd-cache-pre/post.sh hooks.
 *
 * Caches WebFetch responses keyed by URL with HTTP ETag/Last-Modified
 * validators. Serves from cache only when origin confirms 304 Not Modified.
 */
export const SddCache: Plugin = async ({ directory }) => {
  const cacheDir = join(directory, ".opencode", ".sdd-cache")

  const hashUrl = (url: string) =>
    createHash("sha256").update(url).digest("hex").slice(0, 32)

  interface CacheEntry {
    url: string
    etag: string
    last_modified: string
    content: string
    fetched_at: number
  }

  function getCachePath(url: string): string {
    return join(cacheDir, `${hashUrl(url)}.json`)
  }

  function readCache(url: string): CacheEntry | null {
    const path = getCachePath(url)
    if (!existsSync(path)) return null
    try {
      return JSON.parse(readFileSync(path, "utf-8"))
    } catch {
      return null
    }
  }

  function writeCache(entry: CacheEntry): void {
    if (!existsSync(cacheDir)) mkdirSync(cacheDir, { recursive: true })
    writeFileSync(getCachePath(entry.url), JSON.stringify(entry, null, 2), "utf-8")
  }

  async function checkValidators(url: string, etag: string, lastMod: string): Promise<boolean> {
    const headers: Record<string, string> = {}
    if (etag) headers["If-None-Match"] = etag
    if (lastMod) headers["If-Modified-Since"] = lastMod

    try {
      const resp = await fetch(url, { method: "HEAD", headers })
      return resp.status === 304
    } catch {
      return false
    }
  }

  return {
    "tool.execute.before": async (input, output) => {
      const tool = input.tool?.toLowerCase() ?? ""
      if (tool !== "webfetch") return

      const url = output.args?.url
      if (!url) return

      const cached = readCache(url)
      if (!cached) return

      // Revalidate with origin
      const isFresh = await checkValidators(url, cached.etag, cached.last_modified)
      if (!isFresh) return

      // Serve from cache by returning the cached content
      // (OpenCode will use this as the tool result)
      return cached.content
    },
    "tool.execute.after": async (input, output) => {
      const tool = input.tool?.toLowerCase() ?? ""
      if (tool !== "webfetch") return

      const url = output.args?.url
      const content = output.result?.content ?? output.result?.text ?? output.result
      if (!url || !content) return

      // Capture validators from origin via HEAD
      let etag = ""
      let lastMod = ""
      try {
        const headResp = await fetch(url, { method: "HEAD" })
        etag = headResp.headers.get("etag") ?? ""
        lastMod = headResp.headers.get("last-modified") ?? ""
      } catch {
        // Ignore HEAD failures
      }

      if (!etag && !lastMod) return // Can't revalidate, don't cache

      writeCache({
        url,
        etag,
        last_modified: lastMod,
        content: typeof content === "string" ? content : JSON.stringify(content),
        fetched_at: Math.floor(Date.now() / 1000),
      })
    },
  }
}
