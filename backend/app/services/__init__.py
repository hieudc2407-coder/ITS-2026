"""Services package"""
from .telegram_bot import send_violation_alert
from .ai_service import YOLODetector

__all__ = ["send_violation_alert", "YOLODetector"]
