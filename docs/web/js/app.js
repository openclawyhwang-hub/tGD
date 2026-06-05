import { PHASES } from './phases.js';

// ── State ──
const state = {
  statuses: PHASES.map(() => 'pending'), // pending | active | done | error
};

// ── DOM ──
const $ = (sel) => document.querySelector(sel);
const $$ = (sel) => document.querySelectorAll(sel);

// ── Theme ──
function initTheme() {
  const saved = localStorage.getItem('tgd-theme') || 'light';
  document.body.dataset.theme = saved;
  updateThemeBtn();
}

function toggleTheme() {
  const next = document.body.dataset.theme === 'dark' ? 'light' : 'dark';
  document.body.dataset.theme = next;
  localStorage.setItem('tgd-theme', next);
  updateThemeBtn();
}

function updateThemeBtn() {
  const btn = $('#themeToggle');
  btn.textContent = document.body.dataset.theme === 'dark' ? '☀️' : '🌙';
}

// ── Pipeline ──
function renderPipeline() {
  const el = $('#pipelineViz');
  el.innerHTML = '';

  PHASES.forEach((p, i) => {
    const status = state.statuses[i];

    const node = document.createElement('div');
    node.className = 'pipe-node';
    node.dataset.status = status;
    node.onclick = () => scrollToPhase(i);
    node.innerHTML = `
      <div class="pipe-circle">${p.icon}</div>
      <div class="pipe-label">${p.name}</div>
    `;
    el.appendChild(node);

    if (i < PHASES.length - 1) {
      const arrow = document.createElement('div');
      arrow.className = 'pipe-arrow' + (status === 'done' ? ' done' : '');
      el.appendChild(arrow);
    }
  });
}

// ── Phases ──
function renderPhases() {
  const list = $('#phasesList');
  list.innerHTML = '';

  PHASES.forEach((p, i) => {
    const status = state.statuses[i];

    const card = document.createElement('div');
    card.className = 'phase-card';
    card.id = `phase-${p.id}`;
    card.dataset.status = status;

    const skillTags = p.skills.map(s => `
      <span class="skill-tag ${s.required ? '' : 'conditional'}">
        <span class="skill-dot"></span>
        ${s.name}
        ${s.note ? `<span class="skill-note">(${s.note})</span>` : ''}
      </span>
    `).join('');

    const platformTags = p.platforms.map(pl =>
      `<span class="platform-tag ${pl}">${pl}</span>`
    ).join('');

    const outputItems = p.outputs.map(o =>
      `<li><code>${o}</code></li>`
    ).join('');

    card.innerHTML = `
      <div class="phase-head" data-idx="${i}">
        <div class="phase-icon">${p.icon}</div>
        <div class="phase-info">
          <div class="phase-name">${p.name}</div>
          <div class="phase-desc">${p.desc}</div>
        </div>
        <div class="phase-meta">
          <span class="badge ${status}">${status}</span>
        </div>
        <div class="chevron">▼</div>
      </div>
      <div class="phase-body">
        <div class="phase-section">
          <div class="phase-section-label">Command</div>
          <div class="cmd-block">
            <span class="cmd-text">${p.command}</span>
            <button class="copy-btn" data-cmd="${p.command}">Copy</button>
          </div>
        </div>
        <div class="phase-section">
          <div class="phase-section-label">Skills Pipeline</div>
          <div class="skill-tags">${skillTags}</div>
        </div>
        <div class="phase-section">
          <div class="phase-section-label">Platforms</div>
          <div class="platform-tags">${platformTags}</div>
        </div>
        <div class="phase-section">
          <div class="phase-section-label">Outputs</div>
          <ul class="output-list">${outputItems}</ul>
        </div>
        <div class="phase-section">
          <div class="phase-section-label">Verification Gate</div>
          <div class="verify-box">${p.verify}</div>
        </div>
        <div class="phase-actions">
          <button class="btn-sm" data-action="done" data-idx="${i}">✓ Done</button>
          <button class="btn-sm" data-action="active" data-idx="${i}">▶ Active</button>
          <button class="btn-sm" data-action="reset" data-idx="${i}">↺ Reset</button>
        </div>
      </div>
    `;

    list.appendChild(card);
  });

  // Event delegation
  list.addEventListener('click', handlePhaseClick);
}

function handlePhaseClick(e) {
  const head = e.target.closest('.phase-head');
  if (head) {
    const card = head.closest('.phase-card');
    card.classList.toggle('open');
    return;
  }

  const copyBtn = e.target.closest('.copy-btn');
  if (copyBtn) {
    navigator.clipboard.writeText(copyBtn.dataset.cmd).then(() => {
      copyBtn.textContent = '✓';
      setTimeout(() => copyBtn.textContent = 'Copy', 1500);
    });
    return;
  }

  const actionBtn = e.target.closest('[data-action]');
  if (actionBtn) {
    const idx = parseInt(actionBtn.dataset.idx);
    const action = actionBtn.dataset.action;
    if (action === 'done') setStatus(idx, 'done');
    else if (action === 'active') setStatus(idx, 'active');
    else if (action === 'reset') setStatus(idx, 'pending');
    return;
  }
}

function setStatus(idx, status) {
  state.statuses[idx] = status;
  saveState();
  renderPipeline();
  renderPhases();
  updateStats();
  // Re-open the card
  const card = document.getElementById(`phase-${PHASES[idx].id}`);
  if (card) card.classList.add('open');
}

function scrollToPhase(idx) {
  const card = document.getElementById(`phase-${PHASES[idx].id}`);
  if (card) {
    card.classList.add('open');
    card.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
}

// ── Stats ──
function updateStats() {
  const done = state.statuses.filter(s => s === 'done').length;
  const active = state.statuses.filter(s => s === 'active').length;
  const pending = state.statuses.filter(s => s === 'pending').length;
  $('#statDone').textContent = done;
  $('#statActive').textContent = active;
  $('#statPending').textContent = pending;
}

// ── Persistence ──
function saveState() {
  localStorage.setItem('tgd-statuses', JSON.stringify(state.statuses));
}

function loadState() {
  try {
    const saved = JSON.parse(localStorage.getItem('tgd-statuses'));
    if (Array.isArray(saved) && saved.length === PHASES.length) {
      state.statuses = saved;
    }
  } catch {}
}

// ── Scan ──
function initScan() {
  $('#scanBtn').addEventListener('click', () => {
    const path = $('#projectPath').value.trim();
    if (!path) {
      alert('Enter a project path with a tGD/ directory');
      return;
    }
    // TODO: Connect to backend API
    alert(`Scanning: ${path}\n\nBackend API not connected yet.\nUse the manual buttons to set phase status.`);
  });
}

// ── Keyboard ──
document.addEventListener('keydown', (e) => {
  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
  if (e.key === 't' || e.key === 'T') {
    e.preventDefault();
    toggleTheme();
  }
});

// ── Init ──
function init() {
  initTheme();
  loadState();
  renderPipeline();
  renderPhases();
  updateStats();
  initScan();
}

init();
