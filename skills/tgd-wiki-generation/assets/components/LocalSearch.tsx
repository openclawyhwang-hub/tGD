/**
 * LocalSearch — offline client-side search for generated tGD Wiki pages.
 *
 * Ships from the tgd-wiki-generation skill. The index is generated into
 * $TGD_DIR/wiki/src/data/searchIndex.ts on every /tgd-map run.
 */
import React, {useMemo, useState} from 'react';
import Link from '@docusaurus/Link';
import searchIndex from '@site/src/data/searchIndex';

export interface SearchItem {
  title: string;
  type: 'repo' | 'module' | 'flow' | 'symbol' | 'source' | 'page';
  repo?: string;
  path: string;
  summary?: string;
  keywords?: string[];
}

const TYPE_LABELS: Record<SearchItem['type'], string> = {
  repo: 'Repo',
  module: 'Module',
  flow: 'Flow',
  symbol: 'Symbol',
  source: 'Source',
  page: 'Page',
};

function score(item: SearchItem, q: string): number {
  const query = q.toLowerCase().trim();
  if (!query) return 0;
  const title = item.title.toLowerCase();
  const repo = (item.repo || '').toLowerCase();
  const summary = (item.summary || '').toLowerCase();
  const keywords = (item.keywords || []).join(' ').toLowerCase();

  let s = 0;
  if (title === query) s += 100;
  if (title.startsWith(query)) s += 60;
  if (title.includes(query)) s += 35;
  if (repo.includes(query)) s += 20;
  if (keywords.includes(query)) s += 18;
  if (summary.includes(query)) s += 10;

  // Multi-token bonus: all tokens found somewhere.
  const haystack = `${title} ${repo} ${summary} ${keywords}`;
  const tokens = query.split(/\s+/).filter(Boolean);
  if (tokens.length > 1 && tokens.every((t) => haystack.includes(t))) {
    s += 25;
  }
  return s;
}

export default function LocalSearch(): JSX.Element {
  const [query, setQuery] = useState('');
  const [type, setType] = useState<'all' | SearchItem['type']>('all');

  const results = useMemo(() => {
    const q = query.trim();
    const items = searchIndex as SearchItem[];
    return items
      .map((item) => ({item, score: score(item, q)}))
      .filter(({item, score}) => (q ? score > 0 : true) && (type === 'all' || item.type === type))
      .sort((a, b) => b.score - a.score || a.item.title.localeCompare(b.item.title))
      .slice(0, 80)
      .map(({item}) => item);
  }, [query, type]);

  const total = (searchIndex as SearchItem[]).length;

  return (
    <div className="tgd-local-search">
      <div className="tgd-local-search__controls">
        <input
          className="tgd-local-search__input"
          value={query}
          onChange={(event) => setQuery(event.target.value)}
          placeholder="Search repos, modules, symbols, source files…"
          autoFocus
        />
        <select
          className="tgd-local-search__select"
          value={type}
          onChange={(event) => setType(event.target.value as 'all' | SearchItem['type'])}
        >
          <option value="all">All</option>
          <option value="repo">Repos</option>
          <option value="module">Modules</option>
          <option value="symbol">Symbols</option>
          <option value="source">Source files</option>
          <option value="flow">Flows</option>
          <option value="page">Pages</option>
        </select>
      </div>

      <div className="tgd-local-search__meta">
        Showing <strong>{results.length}</strong> of <strong>{total}</strong> indexed items
      </div>

      <div className="tgd-search-results">
        {results.map((item) => (
          <Link key={`${item.type}:${item.path}:${item.title}`} to={item.path} className="tgd-search-result">
            <div className="tgd-search-result__header">
              <span className={`tgd-search-result__type tgd-search-result__type--${item.type}`}>
                {TYPE_LABELS[item.type]}
              </span>
              {item.repo && <span className="tgd-search-result__repo">{item.repo}</span>}
            </div>
            <div className="tgd-search-result__title">{item.title}</div>
            {item.summary && <div className="tgd-search-result__summary">{item.summary}</div>}
            <div className="tgd-search-result__path">{item.path}</div>
          </Link>
        ))}
      </div>

      {results.length === 0 && (
        <div className="tgd-local-search__empty">No matches. Try a repo name, module name, symbol, or file path.</div>
      )}
    </div>
  );
}
