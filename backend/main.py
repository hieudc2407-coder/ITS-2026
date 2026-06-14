"""FastAPI main application entry point"""

import os
import logging
from pathlib import Path
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from dotenv import load_dotenv

from app.api import routes
from app.core.config import settings

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Load environment variables
env_path = Path(__file__).parent / ".env"
load_dotenv(env_path)

# Initialize FastAPI app
app = FastAPI(
    title="Parking Detection API",
    description="AI-powered parking violation detection system",
    version="1.0.0"
)

# CORS middleware - Allow only Frontend from localhost:5173
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files for images and assets
static_dir = Path(__file__).parent / "app" / "static"
if static_dir.exists():
    app.mount("/static", StaticFiles(directory=static_dir), name="static")

# Include routes
app.include_router(routes.router)


@app.on_event("startup")
async def startup_event():
    """Application startup event"""
    logger.info("Application startup")
    logger.info(f"Server running on {settings.HOST}:{settings.PORT}")
    logger.info(f"DEBUG mode: {settings.DEBUG}")
    logger.info(f"TELEGRAM_BOT_TOKEN configured: {bool(settings.TELEGRAM_BOT_TOKEN)}")
    logger.info(f"TELEGRAM_CHAT_ID configured: {bool(settings.TELEGRAM_CHAT_ID)}")
    logger.info(f"Allowed origins: {settings.ALLOWED_ORIGINS}")
    logger.info(f"Static files mounted at /static (directory: {Path('app/static').resolve()})")


@app.on_event("shutdown")
async def shutdown_event():
    """Application shutdown event"""
    logger.info("Application shutdown")


@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Welcome to Parking Detection API",
        "docs_url": "/docs",
        "version": "1.0.0"
    }


if __name__ == "__main__":
    import uvicorn
    
    logger.info(f"Starting Parking Detection API server on {settings.HOST}:{settings.PORT}")
    logger.info(f"API Documentation: http://{settings.HOST}:{settings.PORT}/docs")
    
    uvicorn.run(
        app,
        host=settings.HOST,
        port=settings.PORT,
        debug=settings.DEBUG,
        reload=settings.DEBUG
    )
