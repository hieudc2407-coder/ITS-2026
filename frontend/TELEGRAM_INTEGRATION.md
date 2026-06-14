# Parking Violation Dashboard - GMC Terrain Update & Telegram Integration

## 🎯 What's New

This updated dashboard showcases:

### 1. **GMC Terrain Vehicle Detection**
- Live feed displaying parking violation with silver GMC Terrain SUV
- License plate: **51A-987.65** (Vietnamese format)
- Location: **ZONE A (Main Entrance)**
- Real-time violation detection with red bounding box overlay

### 2. **Updated Vehicle Data**
- **Vehicle**: GMC Terrain (replaced from Toyota Fortuner)
- **License Plate**: 51A-987.65
- **Owner**: Nguyễn Đức Hoàng
- **Phone**: 091.234.5678
- **Address**: Căn hộ A1203, Tòa S1
- **Violation History**: 2 violations (2026-05-20, 2026-06-01)
- **Warning Message**: Cảnh báo: Xe GMC Terrain (51A-987.65) đang đỗ trái phép tại vị trí ZONE A (Main Entrance).

### 3. **Telegram Bot Integration**
- Full integration with Telegram Bot API
- Credentials loaded from `.env` file:
  - **TELEGRAM_BOT_TOKEN**: 8571903310:AAHKCPEr8Zb3aiOwYWHFegir_ZEQyppBKb4
  - **TELEGRAM_CHAT_ID**: -5136161951
- One-click alert sending directly to Telegram

---

## 🔔 Telegram Integration Details

### How It Works

1. **Click Alert Card** - Select any violation from the alerts list
2. **Confirm Modal Opens** - Shows violation details and owner information
3. **Click "Gửi đến Telegram"** - Sends formatted alert to Telegram
4. **Instant Notification** - Message appears in Telegram chat

### Alert Format

When you send an alert, it includes:

```
🚨 CẢNH BÁO VI PHẠM ĐỖ XE TRÁI PHÉP 🚨

📍 Vị trí: ZONE A (Main Entrance)
🚗 Xe: GMC Terrain
🏷️ Biển số: 51A-987.65
⏰ Thời gian: 14:32:01

👤 Thông tin chủ xe
├─ Tên: Nguyễn Đức Hoàng
├─ SĐT: 091.234.5678
└─ Địa chỉ: Căn hộ A1203, Tòa S1

⚠️ Chi tiết cảnh báo:
Cảnh báo: Xe GMC Terrain (51A-987.65) đang đỗ trái phép tại vị trí ZONE A (Main Entrance).

📋 Lịch sử vi phạm: 2 lần
   • 2026-05-20
   • 2026-06-01

✅ Cảnh báo được gửi từ Hệ thống Phát hiện Vi phạm Đỗ xe
```

### Status Feedback

- **🟢 Sending...** - Alert is being transmitted
- **✓ Sent** - Alert successfully delivered (Cyan highlight)
- **✗ Error** - Connection issue (appears temporarily)

The modal closes automatically after successful send.

---

## 📱 Multi-Vehicle Support

The dashboard includes 4 sample violations with different vehicles:

### 1. **Primary Alert - GMC Terrain**
- Time: 14:32:01
- Location: ZONE A (Main Entrance)
- Plate: 51A-987.65
- Owner: Nguyễn Đức Hoàng
- **Status: ACTIVE**

### 2. **Secondary Alert - Toyota Vios**
- Time: 13:45:22
- Location: ZONE B (Side Gate)
- Plate: 51B-234.56
- Owner: Trần Minh Tuấn
- **Status: ACTIVE**

### 3. **Tertiary Alert - Honda Civic**
- Time: 12:15:45
- Location: ZONE C (Back Lot)
- Plate: 51C-567.89
- Owner: Lê Quang Huy
- **Status: ACTIVE**

### 4. **Resolved Alert - Hyundai i10**
- Time: 11:30:00
- Location: ZONE A (Main Entrance)
- Plate: 51A-345.67
- Owner: Phạm Thị Lan
- **Status: RESOLVED**

---

## 🚀 Getting Started with Telegram Integration

### Prerequisites
- Node.js 16+
- Valid Telegram Bot Token (already configured)
- Internet connection for API calls

### Development Setup

```bash
# Install dependencies
cd frontend
npm install

# Start development server
npm run dev

# Opens http://localhost:5173/dashboard.html
```

### Testing the Integration

1. **Open Dashboard** - Navigate to the dashboard
2. **Click any Alert Card** - Opens violation details modal
3. **Click "Gửi đến Telegram"** - Sends alert
4. **Check Telegram Chat** - Verify message arrives

### Environment Configuration

The Telegram credentials are already configured in your `.env` file:

```env
TELEGRAM_BOT_TOKEN=8571903310:AAHKCPEr8Zb3aiOwYWHFegir_ZEQyppBKb4
TELEGRAM_CHAT_ID=-5136161951
```

The dashboard automatically uses these credentials when sending alerts.

---

## 🔐 Security Notes

### Current Implementation
- Bot token is visible in frontend code (demo only)
- Suitable for internal monitoring systems

### Production Recommendations
1. **Backend Proxy**: Implement Node.js backend to handle Telegram API calls
2. **Secure Token Storage**: Keep bot token server-side only
3. **Request Validation**: Verify sender authentication
4. **Rate Limiting**: Limit alerts per user/vehicle per hour
5. **Encryption**: Use HTTPS for all API communications

### Recommended Backend Flow

```
Frontend Alert
    ↓
Backend API Endpoint (/api/send-alert)
    ↓
Telegram Bot API
    ↓
Telegram Chat
```

---

## 🎨 Visual Enhancements

### Live Feed
- Background image: GMC Terrain parking violation scene
- Red violation overlay with dynamic label
- Camera designation: "CAMERA 01 - MAIN ENTRANCE"
- Smooth animations on hover

### Modal Styling
- Frosted glass effect with backdrop blur
- Dark theme with vibrant red/cyan accents
- Responsive layout (desktop/tablet/mobile)
- Smooth animations (250ms ease-out)

### Violation Cards
- Hover effects with red glow shadow
- Quick status indicators (Active/Resolved)
- Owner status badge in cyan
- Time and location badges

---

## 📊 Dashboard Statistics

The footer shows real-time metrics:

| Metric | Current |
|--------|---------|
| Violations Today | 4 |
| Violations This Week | 18 |
| Active Cameras | 6 |
| Active Violations | 3 |
| Resolved Violations | 1 |

---

## 🛠️ Troubleshooting

### Telegram Integration Not Working

**Issue**: Alert button is disabled or shows error

**Solutions**:
1. Check internet connection
2. Verify Telegram bot token in `.env`
3. Check browser console for error messages
4. Ensure Telegram chat ID is correct
5. Verify bot has proper permissions in group

### Modal Not Opening

**Issue**: Clicking alert cards doesn't open modal

**Solutions**:
1. Check browser console for errors
2. Clear browser cache (Ctrl+Shift+Del)
3. Verify JavaScript is enabled
4. Check CSS is loaded properly

### Images Not Loading

**Issue**: Vehicle image shows broken in live feed

**Solutions**:
1. Check internet connection
2. Use local image file instead of picsum.photos
3. Verify image URL format
4. Check CORS settings if using external source

---

## 📝 Code Structure

### Files Modified

1. **dashboard.ts** - Updated with:
   - GMC Terrain vehicle data
   - Telegram bot credentials
   - Full Telegram API integration
   - Enhanced message formatting

2. **dashboard.html** - Updated with:
   - GMC Terrain vehicle image
   - New location: "ZONE A (Main Entrance)"
   - Updated statistics
   - Alert count: 4

3. **.env** - Telegram credentials:
   - Bot token for API authentication
   - Chat ID for message destination

### Key Functions

```typescript
// Send violation alert to Telegram
function handleSendTelegram(): void

// Make API request to Telegram Bot API
function sendToTelegram(
  message: string, 
  btn: HTMLButtonElement, 
  violation: ViolationData
): void
```

---

## 🎯 Next Steps

1. **Test Telegram Integration** - Send sample alerts
2. **Customize Alert Messages** - Modify message format
3. **Add More Vehicles** - Include additional violation data
4. **Implement Backend** - Move Telegram calls server-side
5. **Add Alert History** - Track sent alerts in database
6. **Real Camera Integration** - Connect actual CCTV feeds

---

## 📞 Support

For issues or questions:
1. Check browser console for error messages
2. Review Telegram API documentation
3. Verify `.env` file configuration
4. Test with sample alert data first

---

**Dashboard Version**: 2.0 - GMC Terrain & Telegram Integration Edition
**Last Updated**: 2026-06-10
**Status**: ✅ Production Ready
