/**
 * Hero — Landing hero block for the wiki index page.
 *
 * Ships verbatim from the tgd-wiki-generation skill.
 * DO NOT EDIT under $TGD_DIR/src/ — overwritten on every /tgd-map run.
 */
import React from 'react';
import Link from '@docusaurus/Link';

export interface HeroProps {
  title: string;
  subtitle?: string;
  primary?: { label: string; to: string };
  secondary?: { label: string; to: string };
}

export default function Hero({ title, subtitle, primary, secondary }: HeroProps): JSX.Element {
  return (
    <div className="tgd-hero">
      <h1 className="tgd-hero__title">{title}</h1>
      {subtitle && <p className="tgd-hero__subtitle">{subtitle}</p>}
      <div className="tgd-hero__actions">
        {primary && (
          <Link className="tgd-hero__button tgd-hero__button--primary" to={primary.to}>
            {primary.label}
          </Link>
        )}
        {secondary && (
          <Link className="tgd-hero__button tgd-hero__button--secondary" to={secondary.to}>
            {secondary.label}
          </Link>
        )}
      </div>
    </div>
  );
}
