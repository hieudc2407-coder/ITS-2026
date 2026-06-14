# Parking Detection API - Fullstack Restructure

## 📋 Project Overview

This is a complete restructure of the Parking Detection API as a **Fullstack Monorepo** with three main components:

1. **Backend** - FastAPI/Python (AI-powered detection system)
2. **Frontend** - TypeScript/Web (Dashboard and monitoring)
3. **Telegram Bot** - Integration for real-time alerts

---

## 🗂️ Project Structure

```
.
├── backend/                      # FastAPI Backend
│   ├── app/
│   │   ├── __init__.py
│   │   ├── api/
│   │   │   ├── __init__.py
│   │   │   └── routes.py         # API endpoints
│   │   └── services/
│   │       ├── __init__.py
│   │       ├── ai_service.py     # YOLO detection
│   │       └── telegram_bot.py   # Telegram integration
│   ├── main.py                   # FastAPI app entry point
│   ├── requirements.txt          # Python dependencies
│   ├── .env.example              # Environment variables template
│   ├── .gitignore                # Git ignore rules
│   └── __init__.py
│
├── frontend/                     # Web Frontend (TypeScript/React)
│   ├── src/                      # TypeScript source files
│   ├── public/                   # Static assets
│   ├── styles/                   # CSS files
│   └── README.md
│
├── .github/                      # GitHub workflows (if applicable)
├── .gitignore                    # Root .gitignore
├── .env                          # Root environment (dev)
├── .env.example                  # Environment template
└── README.md                     # This file
```

---

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Node.js 16+ (for frontend)
- pip (Python package manager)

### Backend Setup

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Create virtual environment:**
   ```bash
   # Windows
   python -m venv venv
   venv\Scripts\activate
   
   # Linux/macOS
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Copy environment file:**
   ```bash
   cp .env.example .env
   ```

4. **Edit `.env` with your Telegram credentials:**
   ```
   TELEGRAM_BOT_TOKEN=your_bot_token_here
   TELEGRAM_CHAT_ID=your_chat_id_here
   DEBUG=True
   ```

5. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

6. **Run the API server:**
   ```bash
   python main.py
   ```

   Or with uvicorn directly:
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

7. **Access the API:**
   - API Docs: http://localhost:8000/docs
   - ReDoc: http://localhost:8000/redoc
   - Health Check: http://localhost:8000/api/health

---

## 📡 API Endpoints

### Core Endpoints

- **`GET /api/violations`** - Get all violations
- **`GET /api/violations/{violation_id}`** - Get specific violation
- **`POST /api/alert/{violation_id}`** - Send Telegram alert
- **`POST /api/violations`** - Create new violation
- **`GET /api/health`** - Health check

### Query Parameters
- `processed` (optional): Filter violations by processed status

---

## 🔧 Environment Variables

Create a `.env` file in the backend directory:

```env
TELEGRAM_BOT_TOKEN=your_bot_token_here
TELEGRAM_CHAT_ID=your_chat_id_here
DEBUG=False
HOST=0.0.0.0
PORT=8000
```

---

## 🤖 Services

### Telegram Bot Service
Handles sending violation alerts via Telegram Bot API with support for images and captions.

### AI Detection Service
YOLO-based detector for parking violation detection with frame processing and bounding box drawing.

---

## 📦 Dependencies

See [backend/requirements.txt](backend/requirements.txt) for complete details.

Key packages:
- `fastapi` - Web framework
- `uvicorn` - ASGI server
- `httpx` - Async HTTP client
- `ultralytics` - YOLO models
- `opencv-python` - Image processing
- `pydantic` - Data validation

---

## 🚧 Next Steps

- [ ] Phase 2: Frontend Development (React/TypeScript)
- [ ] Phase 3: Telegram Bot Enhancement
- [ ] Phase 4: Database Integration (PostgreSQL)

---

**Last Updated:** June 10, 2026  
**Version:** 1.0.0 - Initial Restructure  
**Status:** Backend Core Complete ✅
