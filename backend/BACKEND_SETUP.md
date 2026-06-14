# Backend Setup Guide - Parking Violation Detection System

## 📋 Overview

Backend FastAPI server cho hệ thống phát hiện và quản lý vi phạm đỗ xe. Hệ thống có khả năng:
- 📊 Cung cấp API để liệt kê vi phạm
- 📤 Gửi cảnh báo qua Telegram
- 🖼️ Phục vụ hình ảnh tĩnh
- 🔌 Tích hợp với Frontend Dashboard

---

## ✅ Prerequisites

- Python 3.8+
- pip (Python package manager)
- Telegram Bot Token (tạo từ @BotFather)
- Telegram Chat ID (lấy từ @userinfobot hoặc bot của bạn)

---

## 🚀 Installation & Setup

### 1. **Install Dependencies**

```bash
cd backend
pip install -r requirements.txt
```

**Packages installed:**
- `fastapi` - Web framework
- `uvicorn` - ASGI server
- `python-dotenv` - Environment variable management
- `httpx` - Async HTTP client (Telegram API)
- `pydantic` - Data validation

### 2. **Configure Environment Variables**

Tạo file `.env` trong thư mục `backend/` (hoặc copy từ `.env.example`):

```bash
# backend/.env

# Telegram Configuration
TELEGRAM_BOT_TOKEN=your_token_from_botfather
TELEGRAM_CHAT_ID=your_chat_id

# Server Configuration
HOST=0.0.0.0
PORT=8000
DEBUG=False
```

**Cách lấy Telegram Bot Token:**
1. Mở Telegram, tìm @BotFather
2. Gửi `/newbot`
3. Đặt tên bot
4. Copy token từ message

**Cách lấy Telegram Chat ID:**
1. Thêm bot vào Telegram
2. Gửi message `/start` cho bot
3. Truy cập: `https://api.telegram.org/bot{TOKEN}/getUpdates`
4. Tìm `"id"` trong response (Chat ID)

### 3. **Add Violation Car Image**

1. Tìm ảnh xe GMC Terrain đỗ vi phạm
2. Copy file vào: `backend/app/static/images/`
3. Đặt tên: `violation_car.png`

**Path Structure:**
```
backend/app/static/images/
├── README.md
└── violation_car.png  ← Tải ảnh vào đây
```

---

## 🎯 Running the Server

### Option 1: Direct Python Execution

```bash
cd backend
python main.py
```

Server sẽ chạy tại: **http://localhost:8000**

### Option 2: Using Uvicorn Directly

```bash
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

### Expected Output:

```
INFO:     Application startup
INFO:     Server running on 0.0.0.0:8000
INFO:     DEBUG mode: False
INFO:     TELEGRAM_BOT_TOKEN configured: True
INFO:     TELEGRAM_CHAT_ID configured: True
INFO:     Allowed origins: ['http://localhost:5173', ...]
INFO:     Static files mounted at /static (directory: ...)
INFO:     Starting Parking Detection API server on 0.0.0.0:8000
INFO:     API Documentation: http://0.0.0.0:8000/docs
```

---

## 📚 API Endpoints

### 1. **GET /api/violations** - List All Violations

```bash
curl http://localhost:8000/api/violations
```

**Query Parameters (optional):**
- `status`: Filter by status (`pending`, `alerted`, `resolved`)

**Response:**
```json
[
  {
    "id": 1,
    "status": "pending",
    "vehicle": "GMC Terrain - 51A-987.65",
    "location": "ZONE A (Main Entrance)",
    "owner": "Nguyễn Đức Hoàng",
    "phone": "091.234.5678",
    "room": "Căn hộ A1203, Tòa S1",
    "history": "2 lần (2026-05-20, 2026-06-01)",
    "image_url": "/static/images/violation_car.png",
    "timestamp": "2026-06-10 14:32:01"
  }
]
```

---

### 2. **GET /api/violations/{id}** - Get Single Violation

```bash
curl http://localhost:8000/api/violations/1
```

**Response:**
```json
{
  "id": 1,
  "status": "pending",
  "vehicle": "GMC Terrain - 51A-987.65",
  ...
}
```

---

### 3. **POST /api/violations/{id}/alert** - Send Telegram Alert

**Request:**
```bash
curl -X POST http://localhost:8000/api/violations/1/alert \
  -H "Content-Type: application/json" \
  -d '{"message": "Phát hiện vi phạm đỗ xe!"}'
```

**Response:**
```json
{
  "success": true,
  "message": "Alert sent successfully via Telegram",
  "violation_id": 1,
  "status": "alerted"
}
```

**What happens:**
1. Backend lấy thông tin vi phạm từ database
2. Đọc file ảnh từ `app/static/images/violation_car.png`
3. Gửi cảnh báo kèm ảnh và thông tin chi tiết qua Telegram API
4. Cập nhật status của vi phạm thành `"alerted"`

---

### 4. **GET /api/health** - Health Check

```bash
curl http://localhost:8000/api/health
```

**Response:**
```json
{
  "status": "healthy",
  "message": "Parking Detection API is running",
  "telegram_configured": true,
  "version": "1.0.0"
}
```

---

## 🌐 CORS Configuration

Backend cho phép request từ:
- `http://localhost:5173` (Frontend Vite)
- `http://localhost:3000` (Alt Frontend)
- `http://localhost:8000` (Same Origin)
- `http://127.0.0.1:5173` (Local Alternative)

Để thêm origin khác, edit `backend/app/core/config.py`:

```python
ALLOWED_ORIGINS: list = [
    "http://localhost:5173",
    "http://your-domain.com",  # ← Add here
]
```

---

## 📁 Project Structure

```
backend/
├── main.py                    # Entry point
├── requirements.txt           # Dependencies
├── .env                       # Configuration (git ignored)
├── .env.example              # Configuration template
│
├── app/
│   ├── __init__.py
│   ├── core/
│   │   ├── __init__.py
│   │   └── config.py         # Settings & environment loading
│   │
│   ├── api/
│   │   ├── __init__.py
│   │   └── routes.py         # API endpoints
│   │
│   ├── services/
│   │   ├── __init__.py
│   │   ├── telegram_bot.py   # Telegram integration
│   │   └── ai_service.py     # (AI detection - future)
│   │
│   ├── database/
│   │   ├── __init__.py
│   │   └── mock_db.py        # Mock database with sample data
│   │
│   └── static/
│       └── images/
│           ├── README.md
│           └── violation_car.png  ← Add your image here
```

---

## 🧪 Testing with FastAPI Docs

FastAPI tự động generate interactive documentation:

1. **Swagger UI:** http://localhost:8000/docs
2. **ReDoc:** http://localhost:8000/redoc

Trực tiếp test API từ trình duyệt!

---

## 🔐 Security Notes

1. **Never commit `.env` file** - Keep sensitive data safe
2. **Use strong tokens** - Telegram Bot Token và Chat ID
3. **CORS configured** - Only allow trusted origins
4. **Validation enabled** - Pydantic validates all inputs

---

## 🐛 Troubleshooting

### Issue: "ModuleNotFoundError: No module named 'fastapi'"

**Solution:**
```bash
pip install -r requirements.txt
```

### Issue: "TELEGRAM_BOT_TOKEN not configured"

**Solution:**
1. Check `.env` file exists
2. Verify token is correct: `TELEGRAM_BOT_TOKEN=xxx`
3. Restart server

### Issue: "Static files not found" (404 on images)

**Solution:**
1. Ensure `violation_car.png` exists in `backend/app/static/images/`
2. Check path: `http://localhost:8000/static/images/violation_car.png`
3. Verify server has read permissions

### Issue: Image not displaying in Frontend

**Solution:**
1. Verify CORS is configured for `http://localhost:5173`
2. Check image exists and is accessible
3. Use browser DevTools to inspect network requests

---

## 📞 Support

- 📖 **FastAPI Docs:** https://fastapi.tiangolo.com/
- 🤖 **Telegram Bot API:** https://core.telegram.org/bots/api
- 📚 **Python Async:** https://docs.python.org/3/library/asyncio.html

---

## ✨ Next Steps

1. ✅ Configure `.env` file
2. ✅ Add violation car image
3. ✅ Start backend server
4. 🔄 Run Frontend server (npm run dev)
5. 🧪 Test API endpoints
6. 🚀 Deploy to production

---

**Happy Coding! 🚀**
