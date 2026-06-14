@echo off
REM Setup script for Parking Detection API Backend

cd backend

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║   Parking Detection API - Backend Setup (Windows)            ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Check Python installation
python --version >nul 2>&1
if errorlevel 1 (
    echo ✗ Python is not installed or not in PATH
    echo   Please install Python 3.9+ from https://www.python.org
    pause
    exit /b 1
)

echo ✓ Python found
python --version

REM Create virtual environment
if not exist "venv" (
    echo.
    echo Creating virtual environment...
    python -m venv venv
    if errorlevel 1 (
        echo ✗ Failed to create virtual environment
        pause
        exit /b 1
    )
    echo ✓ Virtual environment created
) else (
    echo ✓ Virtual environment already exists
)

REM Activate virtual environment
echo.
echo Activating virtual environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo ✗ Failed to activate virtual environment
    pause
    exit /b 1
)
echo ✓ Virtual environment activated

REM Create .env file if it doesn't exist
if not exist ".env" (
    echo.
    echo Creating .env file from template...
    copy .env.example .env >nul
    echo ✓ .env file created
    echo.
    echo ⚠️  IMPORTANT: Edit backend\.env and add your Telegram credentials:
    echo    - TELEGRAM_BOT_TOKEN: Your bot token from @BotFather
    echo    - TELEGRAM_CHAT_ID: Your chat ID
) else (
    echo ✓ .env file already exists
)

REM Install dependencies
echo.
echo Installing Python dependencies...
pip install --upgrade pip setuptools wheel >nul 2>&1
pip install -r requirements.txt
if errorlevel 1 (
    echo ✗ Failed to install dependencies
    pause
    exit /b 1
)
echo ✓ Dependencies installed successfully

REM Summary
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║   Setup Complete! ✓                                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo Next steps:
echo 1. Edit backend\.env with your Telegram credentials
echo 2. Run: python main.py
echo 3. Open browser to: http://localhost:8000/docs
echo.
echo To activate virtual environment manually later:
echo   cd backend
echo   venv\Scripts\activate
echo.
pause
