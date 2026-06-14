/**
 * Main Application Module
 * Handles UI rendering, API communication, and event handling
 */

import {
  getViolations,
  sendAlert,
  healthCheck,
  formatTimestamp,
  type Violation,
} from './api';

// DOM Elements
let violationsList: HTMLElement | null;
let refreshBtn: HTMLElement | null;
let searchInput: HTMLInputElement | null;
let filterStatus: HTMLSelectElement | null;
let violationCount: HTMLElement | null;
let footerStatus: HTMLElement | null;

// State
let allViolations: Violation[] = [];
let filteredViolations: Violation[] = [];

/**
 * Initialize the application
 */
async function init(): Promise<void> {
  console.log('Initializing Parking Detection Dashboard...');

  // Cache DOM elements
  violationsList = document.getElementById('violationsList');
  refreshBtn = document.getElementById('refreshBtn');
  searchInput = document.getElementById('searchInput') as HTMLInputElement;
  filterStatus = document.getElementById('filterStatus') as HTMLSelectElement;
  violationCount = document.getElementById('violationCount');
  footerStatus = document.getElementById('footerStatus');

  if (!violationsList) {
    console.error('Required DOM elements not found');
    return;
  }

  // Attach event listeners
  attachEventListeners();

  // Check backend connectivity
  await checkBackendConnectivity();

  // Load initial data
  await loadViolations();

  console.log('Dashboard initialized successfully');
}

/**
 * Attach event listeners to DOM elements
 */
function attachEventListeners(): void {
  if (refreshBtn) {
    refreshBtn.addEventListener('click', () => {
      console.log('Refresh button clicked');
      loadViolations();
    });
  }

  if (searchInput) {
    searchInput.addEventListener('input', () => {
      console.log('Search input changed');
      filterAndRenderViolations();
    });
  }

  if (filterStatus) {
    filterStatus.addEventListener('change', () => {
      console.log('Filter status changed');
      filterAndRenderViolations();
    });
  }
}

/**
 * Check backend connectivity
 */
async function checkBackendConnectivity(): Promise<void> {
  try {
    const isHealthy = await healthCheck();
    if (isHealthy && footerStatus) {
      footerStatus.textContent = '✓ Connected to server';
      footerStatus.classList.add('connected');
    } else {
      if (footerStatus) {
        footerStatus.textContent = '✗ Server connection failed';
      }
    }
  } catch (error) {
    console.error('Backend connectivity check failed:', error);
    if (footerStatus) {
      footerStatus.textContent = '✗ Server connection failed';
    }
  }
}

/**
 * Load violations from API
 */
async function loadViolations(): Promise<void> {
  if (!violationsList) return;

  try {
    // Show loading state
    violationsList.innerHTML = `
      <div class="loading-state">
        <div class="spinner"></div>
        <p>Loading violations...</p>
      </div>
    `;

    // Fetch violations from API
    allViolations = await getViolations();
    console.log(`Loaded ${allViolations.length} violations`);

    // Update violation count
    if (violationCount) {
      violationCount.textContent = allViolations.length.toString();
    }

    // Filter and render
    filterAndRenderViolations();
  } catch (error) {
    console.error('Failed to load violations:', error);
    renderError('Failed to load violations. Please try again.');
  }
}

/**
 * Filter violations based on search and status
 */
function filterAndRenderViolations(): void {
  const searchTerm = (searchInput?.value || '').toLowerCase();
  const statusFilter = filterStatus?.value || '';

  filteredViolations = allViolations.filter((violation) => {
    const matchesSearch =
      violation.plate_number.toLowerCase().includes(searchTerm) ||
      violation.location.toLowerCase().includes(searchTerm) ||
      (violation.details?.toLowerCase() || '').includes(searchTerm);

    const matchesStatus = !statusFilter || violation.status === statusFilter;

    return matchesSearch && matchesStatus;
  });

  console.log(
    `Filtered to ${filteredViolations.length} violations from ${allViolations.length}`
  );
  renderViolations();
}

/**
 * Render violations list to the DOM
 */
function renderViolations(): void {
  if (!violationsList) return;

  if (filteredViolations.length === 0) {
    violationsList.innerHTML = `
      <div class="empty-state">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M12 16v-4m0-4h.01"></path>
        </svg>
        <p>No violations found</p>
        <small>Check back later for new detections</small>
      </div>
    `;
    return;
  }

  violationsList.innerHTML = filteredViolations
    .map((violation) => createViolationCard(violation))
    .join('');

  // Attach event listeners to alert buttons
  attachAlertButtonListeners();
}

/**
 * Create HTML for a single violation card
 */
function createViolationCard(violation: Violation): string {
  const severityClass = `status-${violation.severity === 'high' ? 'alerted' : violation.severity === 'medium' ? 'pending' : 'resolved'}`;
  const formattedTime = formatTimestamp(violation.timestamp);

  return `
    <div class="violation-card" data-violation-id="${violation.id}">
      <div class="violation-info">
        <div class="violation-header">
          <h3 class="violation-title">
            🚗 Plate: <strong>${escapeHtml(violation.plate_number)}</strong>
          </h3>
          <span class="status-badge ${`status-${violation.status}`}">
            ${violation.status.charAt(0).toUpperCase() + violation.status.slice(1)}
          </span>
        </div>
        
        <div class="violation-meta">
          <div class="meta-item">
            <span class="meta-label">Location</span>
            <span class="meta-value">${escapeHtml(violation.location)}</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">Time</span>
            <span class="meta-value">${formattedTime}</span>
          </div>
          <div class="meta-item">
            <span class="meta-label">Severity</span>
            <span class="meta-value">${violation.severity.toUpperCase()}</span>
          </div>
          ${violation.details ? `
          <div class="meta-item">
            <span class="meta-label">Details</span>
            <span class="meta-value">${escapeHtml(violation.details)}</span>
          </div>
          ` : ''}
        </div>
      </div>

      <div class="violation-actions">
        <button class="btn-base btn-danger alert-btn" data-violation-id="${violation.id}">
          ⚠️ Alert Now
        </button>
        <button class="btn-base btn-secondary resolve-btn" data-violation-id="${violation.id}">
          ✓ Mark Resolved
        </button>
      </div>
    </div>
  `;
}

/**
 * Attach event listeners to alert buttons
 */
function attachAlertButtonListeners(): void {
  const alertButtons = document.querySelectorAll('.alert-btn');
  const resolveButtons = document.querySelectorAll('.resolve-btn');

  alertButtons.forEach((btn) => {
    btn.addEventListener('click', async (e) => {
      const violationId = (e.target as HTMLElement).dataset.violationId;
      if (violationId) {
        await handleAlertClick(violationId);
      }
    });
  });

  resolveButtons.forEach((btn) => {
    btn.addEventListener('click', async (e) => {
      const violationId = (e.target as HTMLElement).dataset.violationId;
      if (violationId) {
        handleResolveClick(violationId);
      }
    });
  });
}

/**
 * Handle alert button click - sends Telegram notification
 */
async function handleAlertClick(violationId: string): Promise<void> {
  const violation = allViolations.find((v) => v.id === violationId);
  if (!violation) {
    console.error('Violation not found:', violationId);
    return;
  }

  try {
    // Disable button during request
    const btn = document.querySelector(
      `.alert-btn[data-violation-id="${violationId}"]`
    ) as HTMLButtonElement;
    if (btn) {
      btn.disabled = true;
      btn.textContent = '⏳ Sending...';
    }

    // Prepare custom message for Telegram
    const message = `🚨 PARKING VIOLATION ALERT\n\n` +
      `📍 Location: ${violation.location}\n` +
      `🚗 License Plate: ${violation.plate_number}\n` +
      `⏰ Time: ${formatTimestamp(violation.timestamp)}\n` +
      `⚠️ Severity: ${violation.severity.toUpperCase()}\n` +
      `${violation.details ? `📝 Details: ${violation.details}\n` : ''}` +
      `\n✅ Alert sent from Dashboard`;

    // Send alert to backend
    const response = await sendAlert(violationId, message);
    console.log('Alert sent successfully:', response);

    if (btn) {
      btn.textContent = '✅ Alert Sent';
      btn.style.background = '#22c55e';

      // Reset button after 2 seconds
      setTimeout(() => {
        btn.disabled = false;
        btn.textContent = '⚠️ Alert Now';
        btn.style.background = '';
      }, 2000);
    }

    // Update violation status
    violation.status = 'alerted';
    filterAndRenderViolations();

    // Show success notification in footer
    if (footerStatus) {
      const originalText = footerStatus.textContent;
      footerStatus.textContent = `✓ Alert sent for plate ${violation.plate_number}`;
      setTimeout(() => {
        footerStatus!.textContent = originalText;
      }, 3000);
    }
  } catch (error) {
    console.error('Failed to send alert:', error);

    // Reset button
    const btn = document.querySelector(
      `.alert-btn[data-violation-id="${violationId}"]`
    ) as HTMLButtonElement;
    if (btn) {
      btn.disabled = false;
      btn.textContent = '❌ Failed';
      setTimeout(() => {
        btn.textContent = '⚠️ Alert Now';
      }, 2000);
    }

    renderError(`Failed to send alert for plate ${violation.plate_number}`);
  }
}

/**
 * Handle resolve button click - marks violation as resolved
 */
function handleResolveClick(violationId: string): void {
  const violation = allViolations.find((v) => v.id === violationId);
  if (!violation) {
    console.error('Violation not found:', violationId);
    return;
  }

  // Update violation status
  violation.status = 'resolved';
  console.log('Violation marked as resolved:', violationId);

  // Re-render
  filterAndRenderViolations();

  // Show success notification
  if (footerStatus) {
    const originalText = footerStatus.textContent;
    footerStatus.textContent = `✓ Violation marked as resolved`;
    setTimeout(() => {
      footerStatus!.textContent = originalText;
    }, 3000);
  }
}

/**
 * Render error message
 */
function renderError(message: string): void {
  if (!violationsList) return;

  violationsList.innerHTML = `
    <div class="empty-state">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"></circle>
        <path d="M12 8v4m0 4h.01"></path>
      </svg>
      <p>${escapeHtml(message)}</p>
      <button class="btn-base btn-primary" onclick="location.reload()">
        Retry
      </button>
    </div>
  `;
}

/**
 * Escape HTML special characters
 */
function escapeHtml(text: string): string {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

/**
 * Auto-refresh violations every 30 seconds
 */
function setupAutoRefresh(): void {
  setInterval(() => {
    console.log('Auto-refreshing violations...');
    loadViolations();
  }, 30000); // 30 seconds
}

/**
 * Initialize application on DOM ready
 */
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}

// Setup auto-refresh
setupAutoRefresh();

// Log application start
console.log('Parking Detection Dashboard - Ready');
