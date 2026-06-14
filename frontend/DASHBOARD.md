# Parking Violation Detection Dashboard - Modern Design Edition

> A premium, sophisticated dark-mode dashboard for real-time parking violation monitoring with modern design principles applied throughout.

## 🎨 Design Philosophy

This dashboard has been rebuilt using contemporary design patterns:

- **Modern Dark Theme** - Deep carbon backgrounds (`#1A1D21`) with subtle elevation surfaces
- **Vibrant Accents** - Red (`#EF4444`) for critical alerts, Cyan (`#22D3EE`) for success states
- **Glassmorphism** - Frosted glass effects with backdrop blur for visual hierarchy
- **Refined Typography** - Clean sans-serif hierarchy with proper contrast ratios
- **Responsive Grid Layout** - Professional multi-column composition with thoughtful spacing
- **Smooth Animations** - Restrained transitions and micro-interactions for premium feel
- **Data Preservation** - All original Vietnamese text and specific data retained exactly

## 📊 Dashboard Layout

### Left Sidebar
- Modern icon-based navigation with 5 primary sections
- Active state highlighting with red accent and glow effect
- Smooth transitions between navigation states

### Header
- Brand title with gradient text effect
- Live monitoring status indicator with animated pulse
- Clean, minimal design with professional typography

### Main Content Area

#### Live CCTV Feed Section (Left/Center)
- High-resolution camera feed placeholder (1280x720)
- Red violation overlay box with smooth entrance animation
- Real-time detection information:
  - Vehicle type and license plate
  - Owner name
  - Location zone
- Control buttons (Zoom, Record)
- Feed statistics strip showing current metrics

#### Violation Alerts Panel (Right)
- Scrollable list of active parking violations
- Each alert card includes:
  - Time of detection
  - Location (ZONE A, Gate 1, etc.)
  - Vehicle details (Toyota Fortuner, 51H-987.65)
  - Owner info with "Tra cứu thành công" (Search successful) status in cyan
  - "Chi tiết" (Details) button triggering modal
- Hover effects with red accent glow
- Badge showing alert count

### Statistics Footer
- Four KPI cards in responsive grid:
  - Violations Today
  - Violations This Week
  - Active Cameras
- 7-day trend chart with gradient bars:
  - Mon-Sun with varying heights
  - Gradient red coloring
  - Hover states with shadow effects

## 🔔 Modal Interaction

Clicking any alert card opens a modern confirmation modal:

### Modal Features
- Frosted glass backdrop with blur effect
- Smooth slide-in animation
- Sticky header and footer sections

### Modal Content

**Header**: "XÁC NHẬN CẢNH BÁO?" (Confirm Warning?)

**Map Thumbnail**: Clickable location preview

**Owner Information Section**:
```
Chủ xe: Nguyễn Đức Hoàng
SĐT: 091.234.5678
Đơn vị/Phòng: Căn hộ A1203, Tòa S1
Lịch sử vi phạm: 2 lần
Ngày vi phạm:
  - 2026-05-20
  - 2026-06-01
```

**Warning Section**:
- ⚠️ Icon with warning message
- Full violation details in readable layout
- Highlighted critical information

**Action Buttons**:
- "Gửi đến Telegram" (red, primary) - sends alert via Telegram API
- "Hủy" (gray, secondary) - closes modal
- Visual feedback on click (button state change, success confirmation)

## 🎯 Key Features

### Data Preservation ✓
All specific data from the reference image is retained:
- Names: Nguyễn Đức Hoàng
- Phone: 091.234.5678
- Address: Căn hộ A1203, Tòa S1
- Vehicle: Toyota Fortuner
- Plate: 51H-987.65
- Location: ZONE A (Gate 1)
- Violation times: 1 min, 3 min, 5 min, 7 min, 9 min
- All violation history dates

### Interactive Elements
- Alert card hover states with color shifts and scale transforms
- Modal backdrop with blur and semi-transparency
- Smooth animations for modal enter/exit
- Button state transitions (hover, active, disabled)
- Icon button animations in header and sidebar

### Accessibility
- Semantic HTML structure with proper ARIA labels
- Keyboard navigation support (Tab, Enter, Escape)
- Color contrast ratios meet WCAG AA standards
- Focus indicators for keyboard users
- Screen reader friendly content organization

### Performance
- Hardware-accelerated animations using `transform` and `opacity`
- CSS Grid for efficient layout calculations
- No unnecessary re-renders or animations
- Optimized CSS with minimal specificity
- Lazy-loaded images with proper aspect ratios

## 🛠️ Technical Implementation

### File Structure
```
frontend/
├── dashboard.html          # Main page template
├── src/
│   ├── dashboard.ts        # Core TypeScript logic
│   └── styles/
│       └── dashboard.css   # Comprehensive styling
├── vite.config.ts          # Build configuration
├── tsconfig.json           # TypeScript config
└── package.json            # Dependencies
```

### Technologies Used
- **TypeScript**: Full type safety and intelligent IDE support
- **Vanilla CSS**: Modern features (Grid, Flexbox, CSS variables)
- **HTML5**: Semantic structure with accessibility best practices
- **Vite**: Lightning-fast development and production builds

### CSS Architecture
- **CSS Variables**: Defined design tokens for colors, spacing, typography
- **Mobile-First**: Responsive design with breakpoints at 768px and 480px
- **Component-Scoped**: Styles organized by visual components
- **Animation Hooks**: Keyframe animations for smooth transitions

## 🚀 Getting Started

### Prerequisites
```bash
Node.js 16+ 
npm or yarn
```

### Installation & Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Opens http://localhost:5173/dashboard.html automatically
```

### Production Build

```bash
# Build optimized bundle
npm run build

# Preview production build
npm run preview

# Output in dist/ directory
```

## 📱 Responsive Design

The dashboard adapts to different screen sizes:

### Desktop (1440px+)
- Full two-column layout with sidebar
- All features visible without scrolling
- Maximum visual hierarchy

### Tablet (768px - 1440px)
- Single-column main content area
- Horizontal top navigation instead of sidebar
- Alerts panel stacks below feed

### Mobile (480px - 768px)
- Single column with stacked sections
- Simplified navigation
- Optimized touch targets

### Small Mobile (<480px)
- Full-screen optimized
- Simplified controls
- Readable font sizes
- Accessible touch areas

## 🎨 Color Palette

### Primary Colors
- **Red** (`#ef4444`): Critical alerts, CTAs, active states
- **Cyan** (`#22d3ee`): Success indicators, owner info status
- **Amber** (`#f59e0b`): Warnings and secondary actions

### Neutral Colors
- **Background Primary** (`#1a1d21`): Main page background
- **Background Secondary** (`#24282d`): Card surfaces
- **Background Tertiary** (`#2d3139`): Hover and interactive states
- **Text Primary** (`#f5f5f5`): Main text
- **Text Secondary** (`#a0a0a0`): Secondary labels
- **Text Tertiary** (`#707070`): Disabled or subtle text

## 🔐 Security Considerations

When integrating with a real backend:

1. **Data Validation**: Sanitize all user input and API responses
2. **HTTPS Only**: Always use secure connections for API calls
3. **CORS Configuration**: Properly configure Cross-Origin Resource Sharing
4. **Rate Limiting**: Implement request rate limits
5. **Authentication**: Use JWT tokens or session-based auth
6. **XSS Prevention**: HTML-escape all dynamic content (already handled in dashboard.ts)

## 🔌 API Integration

### Current Implementation
The dashboard uses mock data for demonstration. To connect real data:

1. Replace mock violations in `dashboard.ts` with API calls
2. Implement `/api/violations` endpoint to return violation list
3. Add `/api/alert` endpoint for Telegram notifications
4. Configure backend URL in `dashboard.ts` (line 3)

### Expected API Format

**GET /api/violations**
```json
[
  {
    "id": "v001",
    "time": "14:32:01",
    "location": "ZONE A (Gate 1)",
    "vehicle": "Toyota Fortuner",
    "plate": "51H-987.65",
    "ownerName": "Nguyễn Đức Hoàng",
    "ownerPhone": "091.234.5678",
    "ownerAddress": "Căn hộ A1203, Tòa S1",
    "violationType": "Parking - Trái phép",
    "status": "active",
    "violationHistory": [
      { "date": "2026-05-20", "count": 1 },
      { "date": "2026-06-01", "count": 1 }
    ],
    "warningMessage": "Xe Toyota Fortuner...",
    "mapThumbnail": "https://example.com/map.jpg"
  }
]
```

**POST /api/alert**
```json
{
  "violation_id": "v001",
  "message": "Custom alert message"
}
```

## 📝 Customization Guide

### Changing Accent Colors
Edit `:root` variables in `dashboard.css`:
```css
--color-primary: #your-red-color;
--color-success: #your-cyan-color;
```

### Adding New Navigation Items
Edit sidebar in `dashboard.html`:
```html
<button class="sidebar-item" title="New Item">🆕</button>
```

### Modifying Statistics
Update mock data in `dashboard.ts` or connect real API data.

### Extending Modal Content
Edit `createModalContent()` function in `dashboard.ts` to add new sections.

## 🐛 Troubleshooting

### Modal Not Opening
- Check browser console for errors
- Verify alert cards have correct `data-violation-id` attributes
- Ensure `openModal()` function is accessible

### Styling Issues
- Clear browser cache (Ctrl+Shift+Del)
- Check if CSS file is loaded (Network tab in DevTools)
- Verify CSS variables are defined in `:root`

### Animations Choppy
- Check if `prefers-reduced-motion` is enabled
- Reduce animation duration values
- Enable GPU acceleration (already done with `transform`)

## 📊 Performance Metrics

Target metrics for optimal performance:

- **LCP** (Largest Contentful Paint): < 2.5s
- **INP** (Interaction to Next Paint): < 200ms
- **CLS** (Cumulative Layout Shift): < 0.1
- **Bundle Size**: ~50KB gzipped (with Vite optimization)

## 📄 License

All rights reserved © 2024 Parking Detection System

## 🤝 Contributing

This is a specialized dashboard for the Parking Detection System. For modifications or improvements:

1. Maintain the existing design language
2. Preserve all original data and Vietnamese text
3. Test responsive behavior on all screen sizes
4. Follow the code style conventions
5. Document any major changes

---

**Built with premium design principles for professional parking violation monitoring.**
