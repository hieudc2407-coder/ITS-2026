"""Configuration management using python-dotenv"""

import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables from .env file
env_path = Path(__file__).parent.parent.parent / ".env"
load_dotenv(env_path)


class Settings:
    """Application settings loaded from environment variables"""
    
    # Telegram Configuration
    TELEGRAM_BOT_TOKEN: str = os.getenv("TELEGRAM_BOT_TOKEN", "")
    TELEGRAM_CHAT_ID: str = os.getenv("TELEGRAM_CHAT_ID", "")
    
    # Server Configuration
    HOST: str = os.getenv("HOST", "0.0.0.0")
    PORT: int = int(os.getenv("PORT", "8000"))
    DEBUG: bool = os.getenv("DEBUG", "False").lower() == "true"
    
    # CORS Configuration
    ALLOWED_ORIGINS: list = [
        "http://localhost:5173",
        "http://localhost:3000",
        "http://localhost:8000",
        "http://127.0.0.1:5173",
    ]
    
    # Static Files Configuration
    STATIC_DIR: Path = Path(__file__).parent.parent / "static"
    IMAGES_DIR: Path = STATIC_DIR / "images"
    
    @classmethod
    def validate(cls) -> bool:
        """Validate essential configuration"""
        if not cls.TELEGRAM_BOT_TOKEN:
            print("⚠️ Warning: TELEGRAM_BOT_TOKEN not configured")
        if not cls.TELEGRAM_CHAT_ID:
            print("⚠️ Warning: TELEGRAM_CHAT_ID not configured")
        return True


# Create settings instance
settings = Settings()
settings.validate()
