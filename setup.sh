#!/bin/bash
# Setup script for Parking Detection API Backend (Linux/macOS)

cd backend || exit 1

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Parking Detection API - Backend Setup (Linux/macOS)        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check Python installation
if ! command -v python3 &> /dev/null; then
    echo "✗ Python 3 is not installed"
    echo "  Please install Python 3.9+ from https://www.python.org"
    exit 1
fi

echo "✓ Python found"
python3 --version

# Create virtual environment
if [ ! -d "venv" ]; then
    echo ""
    echo "Creating virtual environment..."
    python3 -m venv venv
    if [ $? -ne 0 ]; then
        echo "✗ Failed to create virtual environment"
        exit 1
    fi
    echo "✓ Virtual environment created"
else
    echo "✓ Virtual environment already exists"
fi

# Activate virtual environment
echo ""
echo "Activating virtual environment..."
source venv/bin/activate
if [ $? -ne 0 ]; then
    echo "✗ Failed to activate virtual environment"
    exit 1
fi
echo "✓ Virtual environment activated"

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo ""
    echo "Creating .env file from template..."
    cp .env.example .env
    echo "✓ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Edit backend/.env and add your Telegram credentials:"
    echo "   - TELEGRAM_BOT_TOKEN: Your bot token from @BotFather"
    echo "   - TELEGRAM_CHAT_ID: Your chat ID"
else
    echo "✓ .env file already exists"
fi

# Install dependencies
echo ""
echo "Installing Python dependencies..."
pip install --upgrade pip setuptools wheel > /dev/null 2>&1
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo "✗ Failed to install dependencies"
    exit 1
fi
echo "✓ Dependencies installed successfully"

# Summary
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║   Setup Complete! ✓                                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "1. Edit backend/.env with your Telegram credentials"
echo "2. Run: python main.py"
echo "3. Open browser to: http://localhost:8000/docs"
echo ""
echo "To activate virtual environment manually later:"
echo "   cd backend"
echo "   source venv/bin/activate"
echo ""
