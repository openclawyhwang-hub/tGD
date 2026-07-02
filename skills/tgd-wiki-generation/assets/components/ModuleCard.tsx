/**
 * ModuleCard — Grid card for a single module/layer.
 *
 * Ships verbatim from the tgd-wiki-generation skill.
 * DO NOT EDIT under $TGD_DIR/src/ — overwritten on every /tgd-map run.
 * To customize, patch skills/tgd-wiki-generation/assets/components/.
 */
import React from 'react';
import Link from '@docusaurus/Link';

export interface ModuleCardProps {
  title: string;
  slug: string;
  summary: string;
  fileCount?: number;
  symbolCount?: number;
  icon?: string;
  accent?: 'ui' | 'api' | 'domain' | 'persistence' | 'infra' | 'default';
}

const ACCENT_COLORS: Record<string, string> = {
  ui: 'var(--tgd-accent-ui)',
  api: 'var(--tgd-accent-api)',
  domain: 'var(--tgd-accent-domain)',
  persistence: 'var(--tgd-accent-persistence)',
  infra: 'var(--tgd-accent-infra)',
  default: 'var(--tgd-accent-default)',
};

export default function ModuleCard({
  title,
  slug,
  summary,
  fileCount,
  symbolCount,
  icon,
  accent = 'default',
}: ModuleCardProps): JSX.Element {
  const accentColor = ACCENT_COLORS[accent] ?? ACCENT_COLORS.default;
  return (
    <Link to={slug.startsWith('/') ? slug : `/${slug}`} className="tgd-module-card">
      <div className="tgd-module-card__accent" style={{ backgroundColor: accentColor }} />
      <div className="tgd-module-card__body">
        <div className="tgd-module-card__header">
          {icon && <span className="tgd-module-card__icon">{icon}</span>}
          <h3 className="tgd-module-card__title">{title}</h3>
        </div>
        <p className="tgd-module-card__summary">{summary}</p>
        <div className="tgd-module-card__stats">
          {typeof fileCount === 'number' && (
            <span className="tgd-module-card__stat">
              <strong>{fileCount}</strong> file{fileCount === 1 ? '' : 's'}
            </span>
          )}
          {typeof symbolCount === 'number' && symbolCount > 0 && (
            <span className="tgd-module-card__stat">
              <strong>{symbolCount}</strong> symbol{symbolCount === 1 ? '' : 's'}
            </span>
          )}
        </div>
      </div>
    </Link>
  );
}
