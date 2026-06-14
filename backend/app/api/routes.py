"""API routes for parking violation detection system"""

from fastapi import APIRouter, HTTPException
from typing import List, Optional, Dict, Any
from pydantic import BaseModel
import logging
import os
from pathlib import Path

from app.database import mock_db
from app.services.telegram_bot import TelegramBotService
from app.core.config import settings

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["violations"])


# Pydantic Models
class ViolationResponse(BaseModel):
    """Violation response model"""
    id: int
    status: str
    vehicle: str
    location: str
    owner: str
    phone: str
    room: str
    history: str
    image_url: str
    timestamp: str


class AlertRequest(BaseModel):
    """Alert request model"""
    message: Optional[str] = "Phát hiện vi phạm đỗ xe!"


class AlertResponse(BaseModel):
    """Alert response model"""
    success: bool
    message: str
    violation_id: int
    status: str


# ============================================================
# GET Endpoints
# ============================================================

@router.get("/violations", response_model=List[ViolationResponse])
async def get_violations(status: Optional[str] = None) -> List[ViolationResponse]:
    """
    Get list of all parking violations
    
    Query Parameters:
        - status (optional): Filter by status ('pending', 'alerted', 'resolved')
    
    Returns:
        List of violations
    """
    try:
        if status:
            violations = mock_db.get_violations_by_status(status)
        else:
            violations = mock_db.get_all_violations()
        
        return [ViolationResponse(**v) for v in violations]
    except Exception as e:
        logger.error(f"Error fetching violations: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch violations")


@router.get("/violations/{violation_id}", response_model=ViolationResponse)
async def get_violation(violation_id: int) -> ViolationResponse:
    """
    Get specific violation by ID
    
    Path Parameters:
        - violation_id: ID of the violation
    
    Returns:
        Violation details
    """
    try:
        violation = mock_db.get_violation_by_id(violation_id)
        if not violation:
            raise HTTPException(status_code=404, detail="Violation not found")
        
        return ViolationResponse(**violation)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching violation {violation_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch violation")


# ============================================================
# POST Endpoints
# ============================================================

@router.post("/violations/{violation_id}/alert", response_model=AlertResponse)
async def send_violation_alert(
    violation_id: int,
    request: Optional[AlertRequest] = None
) -> AlertResponse:
    """
    Send Telegram alert for a parking violation
    
    Path Parameters:
        - violation_id: ID of the violation to alert
    
    Request Body:
        - message (optional): Custom alert message
    
    Returns:
        Alert response with success status
    """
    try:
        # Get violation from database
        violation_data = mock_db.get_violation_by_id(violation_id)
        if not violation_data:
            raise HTTPException(status_code=404, detail="Violation not found")
        
        # Check if bot token and chat ID are configured
        if not settings.TELEGRAM_BOT_TOKEN or not settings.TELEGRAM_CHAT_ID:
            logger.warning("Telegram not configured - alert not sent")
            # Still update status for demo purposes
            mock_db.update_violation_status(violation_id, "alerted")
            return AlertResponse(
                success=True,
                message="Alert status updated (Telegram not configured)",
                violation_id=violation_id,
                status="alerted"
            )
        
        # Prepare alert message
        alert_message = request.message if request else "Phát hiện vi phạm đỗ xe!"
        
        # Get image path
        image_path = None
        if violation_data.get("image_url"):
            # Convert URL to local file path
            if violation_data["image_url"].startswith("/static/"):
                local_path = Path(__file__).parent.parent / violation_data["image_url"].lstrip("/")
                if local_path.exists():
                    image_path = local_path
        
        # Create Telegram service and send alert
        telegram_service = TelegramBotService(
            bot_token=settings.TELEGRAM_BOT_TOKEN,
            chat_id=settings.TELEGRAM_CHAT_ID
        )
        
        # Format caption for Telegram with violation info
        caption_text = f"""
🚨 <b>{alert_message}</b>

<b>Thông tin vi phạm:</b>
📍 <b>Vị trí:</b> {violation_data['location']}
🚗 <b>Xe:</b> {violation_data['vehicle']}
👤 <b>Chủ xe:</b> {violation_data['owner']}
📱 <b>Điện thoại:</b> {violation_data['phone']}
🏠 <b>Căn hộ:</b> {violation_data['room']}
📅 <b>Lần vi phạm:</b> {violation_data['history']}
⏰ <b>Thời gian:</b> {violation_data['timestamp']}
        """
        
        # Send alert via Telegram
        success = await telegram_service.send_violation_alert(
            violation_id=str(violation_id),
            image_path=image_path,
            message=caption_text
        )
        
        if success:
            # Update violation status to "alerted"
            mock_db.update_violation_status(violation_id, "alerted")
            logger.info(f"Alert sent successfully for violation {violation_id}")
            
            return AlertResponse(
                success=True,
                message="Alert sent successfully via Telegram",
                violation_id=violation_id,
                status="alerted"
            )
        else:
            logger.warning(f"Failed to send alert for violation {violation_id}")
            return AlertResponse(
                success=False,
                message="Failed to send alert via Telegram",
                violation_id=violation_id,
                status=violation_data.get("status", "pending")
            )
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error processing alert for violation {violation_id}: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail="Failed to process alert"
        )


# ============================================================
# Health Check
# ============================================================

@router.get("/health")
async def health_check() -> Dict[str, Any]:
    """
    Health check endpoint
    
    Returns:
        Health status and configuration info
    """
    return {
        "status": "healthy",
        "message": "Parking Detection API is running",
        "telegram_configured": bool(settings.TELEGRAM_BOT_TOKEN),
        "version": "1.0.0"
    }
