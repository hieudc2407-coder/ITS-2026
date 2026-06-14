/**
 * Parking Violation Detection System - Modern Dashboard
 * TypeScript implementation with strict data preservation
 * © 2024 Parking Detection System
 */

// Import styles
import './styles/dashboard.css';

// ============================================================================
// TYPE DEFINITIONS
// ============================================================================

interface ViolationData {
  id: string;
  time: string;
  location: string;
  vehicle: string;
  plate: string;
  ownerName: string;
  ownerPhone: string;
  ownerAddress: string;
  violationType: string;
  status: 'active' | 'resolved';
  violationHistory: Array<{ date: string; count: number }>;
  warningMessage: string;
  mapThumbnail?: string;
}

interface DashboardState {
  selectedViolation: ViolationData | null;
  violationsList: ViolationData[];
}

// ============================================================================
// MOCK DATA - ALL DATA PRESERVED FROM IMAGE WITH GMC TERRAIN VEHICLE
// ============================================================================

// Telegram configuration from .env
const TELEGRAM_BOT_TOKEN = '8571903310:AAHKCPEr8Zb3aiOwYWHFegir_ZEQyppBKb4';
const TELEGRAM_CHAT_ID = '-5136161951';
const TELEGRAM_API_URL = 'https://api.telegram.org/bot';

const mockViolations: ViolationData[] = [
  {
    id: 'v001',
    time: '14:32:01',
    location: 'ZONE A (Main Entrance)',
    vehicle: 'GMC Terrain',
    plate: '51A-987.65',
    ownerName: 'Nguyễn Đức Hoàng',
    ownerPhone: '091.234.5678',
    ownerAddress: 'Căn hộ A1203, Tòa S1',
    violationType: 'Parking - Trái phép',
    status: 'active',
    violationHistory: [
      { date: '2026-05-20', count: 1 },
      { date: '2026-06-01', count: 1 },
    ],
    warningMessage:
      'Cảnh báo: Xe GMC Terrain (51A-987.65) đang đỗ trái phép tại vị trí ZONE A (Main Entrance).',
    mapThumbnail: 'https://picsum.photos/seed/parking-main-entrance/200/120',
  },
  {
    id: 'v002',
    time: '13:45:22',
    location: 'ZONE B (Side Gate)',
    vehicle: 'Toyota Vios',
    plate: '51B-234.56',
    ownerName: 'Trần Minh Tuấn',
    ownerPhone: '090.123.4567',
    ownerAddress: 'Căn hộ B506, Tòa S2',
    violationType: 'Parking - Trái phép',
    status: 'active',
    violationHistory: [
      { date: '2026-06-05', count: 1 },
    ],
    warningMessage:
      'Cảnh báo: Xe Toyota Vios (51B-234.56) đang đỗ trái phép tại vị trí ZONE B (Side Gate).',
    mapThumbnail: 'https://picsum.photos/seed/parking-side-gate/200/120',
  },
  {
    id: 'v003',
    time: '12:15:45',
    location: 'ZONE C (Back Lot)',
    vehicle: 'Honda Civic',
    plate: '51C-567.89',
    ownerName: 'Lê Quang Huy',
    ownerPhone: '089.876.5432',
    ownerAddress: 'Căn hộ C302, Tòa S3',
    violationType: 'Parking - Trái phép',
    status: 'active',
    violationHistory: [
      { date: '2026-06-03', count: 1 },
      { date: '2026-06-08', count: 1 },
    ],
    warningMessage:
      'Cảnh báo: Xe Honda Civic (51C-567.89) đang đỗ trái phép tại vị trí ZONE C (Back Lot).',
    mapThumbnail: 'https://picsum.photos/seed/parking-back-lot/200/120',
  },
  {
    id: 'v004',
    time: '11:30:00',
    location: 'ZONE A (Main Entrance)',
    vehicle: 'Hyundai i10',
    plate: '51A-345.67',
    ownerName: 'Phạm Thị Lan',
    ownerPhone: '088.765.4321',
    ownerAddress: 'Căn hộ A1105, Tòa S1',
    violationType: 'Parking - Trái phép',
    status: 'resolved',
    violationHistory: [
      { date: '2026-06-02', count: 1 },
    ],
    warningMessage:
      'Cảnh báo: Xe Hyundai i10 (51A-345.67) đang đỗ trái phép tại vị trí ZONE A (Main Entrance).',
    mapThumbnail: 'https://picsum.photos/seed/parking-resolved/200/120',
  },
];

// ============================================================================
// STATE MANAGEMENT
// ============================================================================

const state: DashboardState = {
  selectedViolation: null,
  violationsList: mockViolations,
};

// ============================================================================
// DOM ELEMENTS CACHE
// ============================================================================

let cachedElements: {
  alertsList?: HTMLElement;
  modal?: HTMLElement;
  modalBackdrop?: HTMLElement;
  modalContent?: HTMLElement;
  violationCount?: HTMLElement;
  historyChart?: HTMLElement;
} = {};

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/**
 * Safe DOM query with error handling
 */
function safeQuery(selector: string): HTMLElement | null {
  try {
    return document.querySelector(selector);
  } catch {
    console.warn(`Query failed: ${selector}`);
    return null;
  }
}

/**
 * Safe DOM query all
 */
function safeQueryAll(selector: string): NodeListOf<HTMLElement> | [] {
  try {
    return document.querySelectorAll(selector);
  } catch {
    console.warn(`QueryAll failed: ${selector}`);
    return [];
  }
}

/**
 * Format phone number for display
 */
function formatPhone(phone: string): string {
  return phone.replace(/(\d{3})\.(\d{3})\.(\d{4})/, '+84 $1 $2 $3');
}

/**
 * Create violation alert card HTML
 */
function createViolationCard(violation: ViolationData): string {
  return `
    <div class="alert-card" data-violation-id="${violation.id}" role="button" tabindex="0" aria-label="Violation alert for ${violation.vehicle} ${violation.plate}">
      <div class="alert-card-header">
        <div class="alert-time">${violation.time}</div>
        <div class="alert-status alert-status-active">Active</div>
      </div>
      
      <div class="alert-card-content">
        <div class="alert-row">
          <span class="alert-label">TIME:</span>
          <span class="alert-value">${violation.time}</span>
        </div>
        
        <div class="alert-row">
          <span class="alert-label">LOCATION:</span>
          <span class="alert-value">${violation.location}</span>
        </div>
        
        <div class="alert-row">
          <span class="alert-label">VEHICLE:</span>
          <span class="alert-value">${violation.vehicle}</span>
        </div>
        
        <div class="alert-row">
          <span class="alert-label">PLATE:</span>
          <span class="alert-value alert-plate">${violation.plate}</span>
        </div>
        
        <div class="alert-owner-info">
          <span class="alert-owner-label">Chủ xe:</span>
          <span class="alert-owner-status">Tra cứu thành công</span>
        </div>
      </div>
      
      <div class="alert-card-footer">
        <button class="btn-view-details" aria-label="View details">Chi tiết</button>
      </div>
    </div>
  `;
}

/**
 * Create modal content HTML
 */
function createModalContent(violation: ViolationData): string {
  const historyHtml = violation.violationHistory
    .map((h) => `<div class="history-item"><span class="history-date">${h.date}</span></div>`)
    .join('');

  return `
    <div class="modal-header">
      <h2 class="modal-title">XÁC NHẬN CẢNH BÁO?</h2>
      <button class="modal-close" aria-label="Close modal">×</button>
    </div>
    
    <div class="modal-body">
      <!-- Map Thumbnail -->
      <div class="modal-section">
        <img src="${violation.mapThumbnail}" alt="Parking location map" class="modal-map-thumbnail" />
      </div>
      
      <!-- Owner Information Section -->
      <div class="modal-section">
        <h3 class="modal-section-title">THÔNG TIN CHỦ SỞ HỮU</h3>
        
        <div class="modal-info-grid">
          <div class="modal-info-item">
            <span class="modal-info-label">Chủ xe:</span>
            <span class="modal-info-value">${violation.ownerName}</span>
          </div>
          
          <div class="modal-info-item">
            <span class="modal-info-label">SĐT:</span>
            <span class="modal-info-value">${violation.ownerPhone}</span>
          </div>
          
          <div class="modal-info-item">
            <span class="modal-info-label">Đơn vị/Phòng:</span>
            <span class="modal-info-value">${violation.ownerAddress}</span>
          </div>
          
          <div class="modal-info-item">
            <span class="modal-info-label">Lịch sử vi phạm:</span>
            <span class="modal-info-value">${violation.violationHistory.length} lần</span>
          </div>
          
          ${violation.violationHistory.length > 0 ? `
          <div class="modal-info-item full-width">
            <span class="modal-info-label">Ngày vi phạm:</span>
            <div class="history-list">
              ${historyHtml}
            </div>
          </div>
          ` : ''}
        </div>
      </div>
      
      <!-- Warning Message -->
      <div class="modal-section">
        <div class="modal-warning">
          <div class="warning-icon">⚠️</div>
          <p class="warning-text">${violation.warningMessage}</p>
        </div>
      </div>
    </div>
    
    <div class="modal-footer">
      <button class="btn-telegram" aria-label="Send to Telegram">
        <span class="telegram-icon">✈️</span>
        Gửi đến Telegram
      </button>
      <button class="btn-cancel" aria-label="Cancel">
        Hủy
      </button>
    </div>
  `;
}

// ============================================================================
// MODAL MANAGEMENT
// ============================================================================

/**
 * Open modal with violation details
 */
function openModal(violation: ViolationData): void {
  state.selectedViolation = violation;

  // Create or get modal elements
  let modal = safeQuery('.dashboard-modal');
  if (!modal) {
    modal = document.createElement('div');
    modal.className = 'dashboard-modal';
    document.body.appendChild(modal);
  }

  // Create backdrop
  let backdrop = safeQuery('.modal-backdrop');
  if (!backdrop) {
    backdrop = document.createElement('div');
    backdrop.className = 'modal-backdrop';
    document.body.appendChild(backdrop);
  }

  // Set modal content
  modal.innerHTML = `<div class="modal-wrapper">${createModalContent(violation)}</div>`;

  // Show modal with animation
  backdrop.classList.add('active');
  modal.classList.add('active');

  // Attach event listeners
  const closeBtn = safeQuery('.modal-close');
  const cancelBtn = safeQuery('.btn-cancel');
  const telegramBtn = safeQuery('.btn-telegram');

  if (closeBtn)
    closeBtn.addEventListener('click', closeModal, { once: true });
  if (cancelBtn)
    cancelBtn.addEventListener('click', closeModal, { once: true });
  if (backdrop)
    backdrop.addEventListener('click', closeModal, { once: true });
  if (telegramBtn)
    telegramBtn.addEventListener('click', handleSendTelegram, { once: true });

  // Prevent backdrop click from closing if clicking on modal
  modal.addEventListener('click', (e) => e.stopPropagation());
}

/**
 * Close modal
 */
function closeModal(): void {
  const modal = safeQuery('.dashboard-modal');
  const backdrop = safeQuery('.modal-backdrop');

  if (modal) modal.classList.remove('active');
  if (backdrop) backdrop.classList.remove('active');

  state.selectedViolation = null;

  // Cleanup after animation
  setTimeout(() => {
    if (modal && modal.parentNode) modal.parentNode.removeChild(modal);
    if (backdrop && backdrop.parentNode) backdrop.parentNode.removeChild(backdrop);
  }, 300);
}

/**
 * Handle send to Telegram
 */
function handleSendTelegram(): void {
  const violation = state.selectedViolation;
  if (!violation) return;

  const telegramBtn = safeQuery('.btn-telegram') as HTMLButtonElement;
  if (telegramBtn) {
    telegramBtn.disabled = true;
    telegramBtn.textContent = '⏳ Đang gửi...';
  }

  // Prepare detailed message for Telegram
  const telegramMessage = `
🚨 *CẢNH BÁO VI PHẠM ĐỖ XE TRÁI PHÉP* 🚨

📍 *Vị trí:* ${violation.location}
🚗 *Xe:* ${violation.vehicle}
🏷️ *Biển số:* ${violation.plate}
⏰ *Thời gian:* ${violation.time}

👤 *Thông tin chủ xe*
├─ Tên: ${violation.ownerName}
├─ SĐT: ${violation.ownerPhone}
└─ Địa chỉ: ${violation.ownerAddress}

⚠️ *Chi tiết cảnh báo:*
${violation.warningMessage}

📋 *Lịch sử vi phạm:* ${violation.violationHistory.length} lần
${violation.violationHistory.map((h) => `   • ${h.date}`).join('\n')}

✅ Cảnh báo được gửi từ Hệ thống Phát hiện Vi phạm Đỗ xe`;

  // Send to Telegram API
  sendToTelegram(telegramMessage, telegramBtn, violation);
}

/**
 * Send message to Telegram
 */
function sendToTelegram(message: string, btn: HTMLButtonElement, violation: ViolationData): void {
  const url = `${TELEGRAM_API_URL}${TELEGRAM_BOT_TOKEN}/sendMessage`;
  
  fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      chat_id: TELEGRAM_CHAT_ID,
      text: message,
      parse_mode: 'Markdown',
    }),
  })
    .then((response) => response.json())
    .then((data) => {
      console.log('Telegram response:', data);
      
      // Show success feedback
      if (btn) {
        btn.textContent = '✓ Đã gửi';
        btn.style.background = '#22d3ee';
        btn.style.borderColor = '#22d3ee';

        setTimeout(() => {
          btn.disabled = false;
          btn.textContent = '✈️ Gửi đến Telegram';
          btn.style.background = '';
          btn.style.borderColor = '';
          closeModal();
        }, 1500);
      }
    })
    .catch((error) => {
      console.error('Failed to send to Telegram:', error);
      
      // Show error feedback
      if (btn) {
        btn.disabled = false;
        btn.textContent = '❌ Lỗi';
        
        setTimeout(() => {
          btn.textContent = '✈️ Gửi đến Telegram';
        }, 2000);
      }
    });
}

// ============================================================================
// RENDERING FUNCTIONS
// ============================================================================

/**
 * Render violations list
 */
function renderViolationsList(): void {
  const alertsList = safeQuery('#alerts-list');
  if (!alertsList) return;

  alertsList.innerHTML = state.violationsList
    .map((v) => createViolationCard(v))
    .join('');

  // Attach click handlers to cards
  const cards = safeQueryAll('.alert-card');
  cards.forEach((card) => {
    card.addEventListener('click', () => {
      const violationId = card.getAttribute('data-violation-id');
      const violation = state.violationsList.find((v) => v.id === violationId);
      if (violation) {
        openModal(violation);
      }
    });

    // Keyboard accessibility
    card.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        (card as HTMLElement).click();
      }
    });
  });
}

/**
 * Update statistics
 */
function updateStatistics(): void {
  const violationCount = safeQuery('#stat-violations-today');
  const violationsTodayTrend = safeQuery('.stat-violations-today-trend');

  if (violationCount) {
    violationCount.textContent = state.violationsList.length.toString();
  }
}

/**
 * Render trend chart
 */
function renderTrendChart(): void {
  const chartContainer = safeQuery('#trend-chart');
  if (!chartContainer) return;

  // Mock trend data (days of week)
  const trendData = [
    { day: 'Mon', violations: 12 },
    { day: 'Tue', violations: 18 },
    { day: 'Wed', violations: 9 },
    { day: 'Thu', violations: 15 },
    { day: 'Fri', violations: 22 },
    { day: 'Sat', violations: 8 },
    { day: 'Sun', violations: 5 },
  ];

  const maxViolations = Math.max(...trendData.map((d) => d.violations));
  const bars = trendData
    .map((item) => {
      const height = (item.violations / maxViolations) * 100;
      return `
      <div class="bar-wrapper">
        <div class="bar" style="height: ${height}%" title="${item.violations} violations"></div>
        <div class="bar-label">${item.day}</div>
      </div>
    `;
    })
    .join('');

  chartContainer.innerHTML = bars;
}

/**
 * Setup sidebar
 */
function setupSidebar(): void {
  const sidebarItems = safeQueryAll('.sidebar-item');
  sidebarItems.forEach((item, index) => {
    if (index === 0) {
      item.classList.add('active');
    }

    item.addEventListener('click', () => {
      sidebarItems.forEach((i) => i.classList.remove('active'));
      item.classList.add('active');
    });
  });
}

// ============================================================================
// INITIALIZATION
// ============================================================================

/**
 * Initialize dashboard
 */
function initDashboard(): void {
  console.log('Initializing Parking Violation Dashboard...');

  // Wait for DOM to be ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initDashboard);
    return;
  }

  // Render initial data
  renderViolationsList();
  updateStatistics();
  renderTrendChart();
  setupSidebar();

  // Setup modals container
  const modalsContainer = document.createElement('div');
  modalsContainer.id = 'modals-container';
  document.body.appendChild(modalsContainer);

  console.log('Dashboard initialized successfully');
}

// ============================================================================
// KEYBOARD SHORTCUTS & ACCESSIBILITY
// ============================================================================

document.addEventListener('keydown', (e) => {
  // Escape key closes modal
  if (e.key === 'Escape' && state.selectedViolation) {
    closeModal();
  }
});

// ============================================================================
// LIFECYCLE
// ============================================================================

initDashboard();

// Export for testing
export { initDashboard, openModal, closeModal, state };
