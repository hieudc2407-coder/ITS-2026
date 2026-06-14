# Parking Detection Dashboard - Frontend

A modern, responsive web dashboard for monitoring parking violations in real-time. Built with Vite, Vanilla TypeScript, and pure CSS.

## Features

- 📊 **Real-time Violations Dashboard** - Monitor detected parking violations with live updates
- 🚨 **Alert System** - Send instant Telegram notifications for violations
- 🔍 **Search & Filter** - Find violations by license plate, location, or details
- 📱 **Responsive Design** - Works seamlessly on desktop, tablet, and mobile devices
- 🎨 **Modern UI** - Clean, professional interface with dark mode support
- ⚡ **Fast Performance** - Built with Vite for instant hot module replacement (HMR)
- ♿ **Accessible** - WCAG compliant with keyboard navigation support

## Quick Start

### Prerequisites

- Node.js 16+ or higher
- npm or yarn package manager

### Installation

```bash
# Install dependencies
npm install
```

### Development

```bash
# Start the development server
npm run dev
```

The application will open at `http://localhost:5173` with hot module replacement enabled.

### Build for Production

```bash
# Build the project
npm run build

# Preview the production build
npm run preview
```

## Project Structure

```
frontend/
├── src/
│   ├── styles/
│   │   └── main.css          # Main stylesheet
│   ├── api.ts                # API client functions
│   ├── main.ts               # Application logic
├── index.html                # Entry point
├── tsconfig.json             # TypeScript configuration
├── vite.config.ts            # Vite configuration
├── package.json              # Dependencies and scripts
└── README.md                 # This file
```

## API Integration

The dashboard communicates with the backend API at `http://localhost:8000/api`.

### API Endpoints

- `GET /api/violations` - Fetch all parking violations
- `POST /api/alert` - Send alert notification for a violation
- `GET /api/health` - Health check endpoint

### Violation Object

```typescript
interface Violation {
  id: string;
  plate_number: string;
  location: string;
  timestamp: string;
  severity: 'low' | 'medium' | 'high';
  status: 'pending' | 'alerted' | 'resolved';
  image_url?: string;
  details?: string;
}
```

## Key Components

### API Service (`src/api.ts`)
- `getViolations()` - Fetch violations from backend
- `sendAlert()` - Send Telegram notification
- `healthCheck()` - Verify backend connectivity
- `formatTimestamp()` - Format timestamps to readable format

### Main Application (`src/main.ts`)
- Handles DOM rendering and state management
- Manages user interactions and event handling
- Implements search and filtering functionality
- Auto-refreshes violations every 30 seconds

### Styling (`src/styles/main.css`)
- Responsive grid layouts
- Dark mode support with light mode fallback
- Accessible color contrasts (WCAG AA compliant)
- Smooth animations and transitions
- Mobile-first responsive design

## Usage

### Viewing Violations

The dashboard automatically loads and displays all parking violations. Each violation card shows:
- License plate number
- Location
- Detection timestamp
- Severity level (low/medium/high)
- Current status (pending/alerted/resolved)
- Detailed information

### Sending Alerts

Click the **⚠️ Alert Now** button on any violation card to:
1. Send an instant notification to Telegram
2. Update the violation status to "alerted"
3. Display a success confirmation

### Filtering Violations

- **Search**: Use the search box to filter by plate number, location, or details
- **Status Filter**: Select a status from the dropdown to view violations by status
- **Auto-refresh**: The dashboard automatically refreshes every 30 seconds

### Marking as Resolved

Click the **✓ Mark Resolved** button to mark a violation as resolved (removes it from the active monitoring list).

## Configuration

### Backend URL

To change the backend API URL, edit `src/api.ts`:

```typescript
const API_BASE_URL = 'http://localhost:8000/api'; // Change this
```

### Auto-refresh Interval

To change the auto-refresh interval, edit `src/main.ts`:

```typescript
setupAutoRefresh(): // Currently 30 seconds
```

## Browser Support

- Chrome/Edge 90+
- Firefox 88+
- Safari 14+
- Mobile browsers (iOS Safari 14+, Chrome Mobile)

## Performance

- **LCP** (Largest Contentful Paint): < 2.5s
- **INP** (Interaction to Next Paint): < 200ms
- **CLS** (Cumulative Layout Shift): < 0.1
- Optimized for Core Web Vitals

## Accessibility Features

- WCAG 2.1 Level AA compliance
- Keyboard navigation support
- Screen reader friendly
- High contrast support
- Reduced motion support for users who prefer it

## Development Tips

### Hot Module Replacement (HMR)

Changes to TypeScript and CSS files are automatically reloaded in the browser without full refresh.

### TypeScript Support

The project uses TypeScript for type safety. All API responses and UI state are fully typed.

### Debugging

Open browser DevTools (F12) to access:
- Console logs for debugging
- Network tab to monitor API calls
- Elements inspector for DOM inspection

## Building for Production

The `npm run build` command:
1. Compiles TypeScript to JavaScript
2. Bundles and minifies all assets
3. Optimizes images and other resources
4. Outputs to the `dist/` directory

## Troubleshooting

### Backend Connection Failed

If you see "Server connection failed" in the footer:
1. Ensure the backend is running at `http://localhost:8000`
2. Check CORS headers are properly configured
3. Verify network connectivity

### No Violations Displayed

1. Check if the backend has any violations in the database
2. Use browser DevTools Network tab to inspect API responses
3. Check console for error messages

### Styling Issues

1. Clear browser cache (Ctrl+Shift+Del)
2. Do a hard refresh (Ctrl+Shift+R)
3. Rebuild the project: `npm run build`

## License

All rights reserved © 2024 Parking Detection System
- `services/` - API services
- `hooks/` - Custom React hooks
- `types/` - TypeScript type definitions

## Technologies:
- TypeScript
- React/Next.js (optional)
- CSS/TailwindCSS
- REST API client (fetch/axios)

To be implemented in Phase 2 of the project.
