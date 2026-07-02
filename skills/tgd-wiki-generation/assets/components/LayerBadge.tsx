/**
 * LayerBadge — Small tag for module/layer/type indication.
 *
 * Ships verbatim from the tgd-wiki-generation skill.
 * DO NOT EDIT under $TGD_DIR/src/ — overwritten on every /tgd-map run.
 */
import React from 'react';

export interface LayerBadgeProps {
  label: string;
  accent?: 'ui' | 'api' | 'domain' | 'persistence' | 'infra' | 'default';
}

export default function LayerBadge({ label, accent = 'default' }: LayerBadgeProps): JSX.Element {
  return <span className={`tgd-layer-badge tgd-layer-badge--${accent}`}>{label}</span>;
}
