/**
 * KPIGrid — Stats block for the overview page.
 *
 * Ships verbatim from the tgd-wiki-generation skill.
 * DO NOT EDIT under $TGD_DIR/src/ — overwritten on every /tgd-map run.
 */
import React from 'react';

export interface KPI {
  label: string;
  value: number | string;
  hint?: string;
}

export interface KPIGridProps {
  items: KPI[];
}

export default function KPIGrid({ items }: KPIGridProps): JSX.Element {
  return (
    <div className="tgd-kpi-grid">
      {items.map((kpi, i) => (
        <div key={i} className="tgd-kpi-grid__item">
          <div className="tgd-kpi-grid__value">{kpi.value}</div>
          <div className="tgd-kpi-grid__label">{kpi.label}</div>
          {kpi.hint && <div className="tgd-kpi-grid__hint">{kpi.hint}</div>}
        </div>
      ))}
    </div>
  );
}
