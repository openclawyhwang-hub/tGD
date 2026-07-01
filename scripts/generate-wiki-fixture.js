// generate-wiki-fixture.js
// Generates a minimal valid UA knowledge-graph.json so CI can run
// the full tGD Wiki pipeline (generate-wiki.py → generate-docusaurus-config.py
// → build-site.sh → verify-wiki.py) on a deterministic fixture.
//
// Usage: node scripts/generate-wiki-fixture.js <TGD_DIR>

import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const tgdDir = process.argv[2];
if (!tgdDir) {
  console.error('Usage: node generate-wiki-fixture.js <TGD_DIR>');
  process.exit(2);
}

const scanDir = join(tgdDir, '.scans', 'ci-fixture', '.understand-anything');
mkdirSync(scanDir, { recursive: true });

const graph = {
  version: '1.0.0',
  project: {
    name: 'ci-fixture',
    description: 'Synthetic project for CI layout-contract verification',
    languages: ['typescript', 'python'],
    frameworks: ['React', 'FastAPI'],
  },
  nodes: [
    { id: 'file:src/app.tsx', type: 'file', name: 'app.tsx', filePath: 'src/app.tsx', summary: 'UI root component', tags: ['entry', 'ui'] },
    { id: 'file:src/pages/home.tsx', type: 'file', name: 'home.tsx', filePath: 'src/pages/home.tsx', summary: 'Home page', tags: ['ui', 'page'] },
    { id: 'file:backend/main.py', type: 'file', name: 'main.py', filePath: 'backend/main.py', summary: 'API entry point', tags: ['api', 'entry'] },
    { id: 'file:backend/routes/api.py', type: 'file', name: 'api.py', filePath: 'backend/routes/api.py', summary: 'API routes', tags: ['api'] },
    { id: 'file:backend/services/data.py', type: 'file', name: 'data.py', filePath: 'backend/services/data.py', summary: 'Data service', tags: ['api', 'service'] },
    { id: 'file:backend/models/db.py', type: 'file', name: 'db.py', filePath: 'backend/models/db.py', summary: 'ORM base', tags: ['api', 'model'] },
    { id: 'config:package.json', type: 'config', name: 'package.json', filePath: 'package.json', summary: 'Manifest', tags: ['config'] },
    { id: 'document:README.md', type: 'document', name: 'README.md', filePath: 'README.md', summary: 'Docs', tags: ['docs'] },
  ],
  edges: [
    { source: 'file:src/app.tsx', target: 'file:src/pages/home.tsx', type: 'imports' },
    { source: 'file:backend/main.py', target: 'file:backend/routes/api.py', type: 'imports' },
    { source: 'file:backend/routes/api.py', target: 'file:backend/services/data.py', type: 'imports' },
    { source: 'file:backend/services/data.py', target: 'file:backend/models/db.py', type: 'imports' },
    { source: 'config:package.json', target: 'file:src/app.tsx', type: 'configures' },
  ],
  layers: [
    {
      id: 'layer:ui',
      name: 'UI',
      description: 'User-facing React application',
      nodeIds: ['file:src/app.tsx', 'file:src/pages/home.tsx', 'config:package.json'],
    },
    {
      id: 'layer:api',
      name: 'API',
      description: 'FastAPI routes and services',
      nodeIds: ['file:backend/main.py', 'file:backend/routes/api.py', 'file:backend/services/data.py'],
    },
    {
      id: 'layer:persistence',
      name: 'Persistence',
      description: 'ORM models and database',
      nodeIds: ['file:backend/models/db.py'],
    },
  ],
  tour: [
    { order: 1, title: 'Project layout', description: 'Two-layer app: React UI + FastAPI backend', nodeIds: ['document:README.md'] },
    { order: 2, title: 'UI', description: 'App boots, routes to home', nodeIds: ['file:src/app.tsx', 'file:src/pages/home.tsx'] },
  ],
};

writeFileSync(join(scanDir, 'knowledge-graph.json'), JSON.stringify(graph, null, 2));
console.log(`✅ Fixture written to ${scanDir}`);
