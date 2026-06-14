"""Telegram Bot Service for sending violation alerts"""

import asyncio
import httpx
import os
from pathlib import Path
from typing import Optional
import logging

logger = logging.getLogger(__name__)


class TelegramBotService:
    """Service for sending alerts via Telegram Bot API"""
    
    def __init__(self, bot_token: str, chat_id: str):
        """
        Initialize Telegram Bot Service
        
        Args:
            bot_token: Telegram Bot token
            chat_id: Telegram Chat ID to send messages to
        """
        self.bot_token = bot_token
        self.chat_id = chat_id
        self.api_url = f"https://api.telegram.org/bot{bot_token}"
        
    async def send_violation_alert(
        self, 
        violation_id: str,
        image_path: Optional[Path] = None,
        message: str = "Phát hiện vi phạm đỗ xe!"
    ) -> bool:
        """
        Send violation alert via Telegram with optional image
        
        Args:
            violation_id: ID of the violation
            image_path: Path to violation image (local file)
            message: Alert message text (supports HTML/MarkdownV2)
            
        Returns:
            bool: True if sent successfully, False otherwise
        """
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                if image_path and Path(image_path).exists():
                    # Send photo with caption
                    logger.info(f"Sending photo from {image_path} via Telegram")
                    with open(image_path, "rb") as photo:
                        files = {"photo": photo}
                        data = {
                            "chat_id": self.chat_id,
                            "caption": message,
                            "parse_mode": "HTML"  # Use HTML formatting for caption
                        }
                        response = await client.post(
                            f"{self.api_url}/sendPhoto",
                            data=data,
                            files=files
                        )
                else:
                    # Send text message only
                    logger.info(f"Sending text alert for violation {violation_id}")
                    data = {
                        "chat_id": self.chat_id,
                        "text": message,
                        "parse_mode": "HTML"  # Use HTML formatting
                    }
                    response = await client.post(
                        f"{self.api_url}/sendMessage",
                        json=data
                    )
                
                if response.status_code == 200:
                    logger.info(f"✅ Telegram alert sent successfully for violation {violation_id}")
                    return True
                else:
                    logger.error(f"❌ Failed to send Telegram alert: Status {response.status_code}, Response: {response.text}")
                    return False
                    
        except httpx.TimeoutException as e:
            logger.error(f"❌ Timeout while sending Telegram alert: {str(e)}")
            return False
        except FileNotFoundError as e:
            logger.error(f"❌ Image file not found: {str(e)}")
            return False
        except Exception as e:
            logger.error(f"❌ Error sending Telegram alert: {str(e)}")
            return False

    async def send_telegram_alert_with_image(
        self,
        violation_data: dict,
        image_path: str
    ) -> bool:
        """
        Send a formatted violation alert with image to Telegram
        
        Args:
            violation_data: Dictionary containing violation details with keys:
                - vehicle: Vehicle information
                - plate: License plate number
                - location: Violation location
                - time: Time of violation
                - owner: Vehicle owner name
            image_path: Local filesystem path to the image file
            
        Returns:
            bool: True if sent successfully, False otherwise
        """
        try:
            # Verify image file exists
            if not Path(image_path).exists():
                logger.error(f"❌ Image file not found at: {image_path}")
                return False
            
            # Format the HTML caption with violation details
            caption = self._format_violation_caption(violation_data)
            
            logger.info(f"Sending Telegram alert with image from: {image_path}")
            
            async with httpx.AsyncClient(timeout=30.0) as client:
                # Read image in binary mode
                with open(image_path, "rb") as image_file:
                    files = {"photo": image_file}
                    data = {
                        "chat_id": self.chat_id,
                        "caption": caption,
                        "parse_mode": "HTML"
                    }
                    
                    response = await client.post(
                        f"{self.api_url}/sendPhoto",
                        data=data,
                        files=files
                    )
                
                if response.status_code == 200:
                    logger.info("✅ Telegram alert with image sent successfully")
                    return True
                else:
                    logger.error(f"❌ Failed to send Telegram photo alert: Status {response.status_code}, Response: {response.text}")
                    return False
                    
        except FileNotFoundError as e:
            logger.error(f"❌ Image file not found: {str(e)}")
            return False
        except httpx.TimeoutException as e:
            logger.error(f"❌ Timeout while sending Telegram alert with image: {str(e)}")
            return False
        except IOError as e:
            logger.error(f"❌ I/O error reading image file: {str(e)}")
            return False
        except Exception as e:
            logger.error(f"❌ Error sending Telegram alert with image: {str(e)}")
            return False

    @staticmethod
    def _format_violation_caption(violation_data: dict) -> str:
        """
        Format violation data into HTML-formatted caption for Telegram
        
        Args:
            violation_data: Dictionary with violation details
            
        Returns:
            str: HTML-formatted caption string
        """
        vehicle = violation_data.get("vehicle", "N/A")
        plate = violation_data.get("plate", "N/A")
        location = violation_data.get("location", "N/A")
        time = violation_data.get("time", "N/A")
        owner = violation_data.get("owner", "N/A")
        
        caption = (
            f"<b>🚨 ILLEGAL PARKING VIOLATION DETECTED</b>\n\n"
            f"<b>Vehicle:</b> <code>{vehicle}</code>\n"
            f"<b>License Plate:</b> <code>{plate}</code>\n"
            f"<b>Location:</b> {location}\n"
            f"<b>Time:</b> {time}\n"
            f"<b>Owner:</b> {owner}\n\n"
            f"<i>Action Required: Please verify and take appropriate enforcement action.</i>"
        )
        
        return caption



async def send_violation_alert(
    bot_token: str,
    chat_id: str,
    violation_id: str,
    image_path: Optional[Path] = None,
    message: str = "Phát hiện vi phạm đỗ xe!"
) -> bool:
    """
    Async function to send violation alert via Telegram
    
    Args:
        bot_token: Telegram Bot token
        chat_id: Telegram Chat ID
        violation_id: ID of the violation
        image_path: Path to violation image (local file)
        message: Alert message text (supports HTML/MarkdownV2)
        
    Returns:
        bool: True if sent successfully, False otherwise
    """
    service = TelegramBotService(bot_token, chat_id)
    return await service.send_violation_alert(violation_id, image_path, message)


async def send_telegram_alert_with_image(
    violation_data: dict,
    image_path: str,
    bot_token: Optional[str] = None,
    chat_id: Optional[str] = None
) -> bool:
    """
    Send a formatted violation alert with image to Telegram
    
    This standalone function automatically loads bot credentials from environment variables
    if not provided explicitly.
    
    Args:
        violation_data: Dictionary containing violation details with keys:
            - vehicle: Vehicle information
            - plate: License plate number
            - location: Violation location
            - time: Time of violation
            - owner: Vehicle owner name
        image_path: Local filesystem path to the image file
        bot_token: Telegram Bot token (loaded from env if not provided)
        chat_id: Telegram Chat ID (loaded from env if not provided)
        
    Returns:
        bool: True if sent successfully, False otherwise
    """
    # Load credentials from environment if not provided
    if bot_token is None:
        bot_token = os.getenv("TELEGRAM_BOT_TOKEN")
        if not bot_token:
            logger.error("❌ TELEGRAM_BOT_TOKEN environment variable not set")
            return False
    
    if chat_id is None:
        chat_id = os.getenv("TELEGRAM_CHAT_ID")
        if not chat_id:
            logger.error("❌ TELEGRAM_CHAT_ID environment variable not set")
            return False
    
    service = TelegramBotService(bot_token, chat_id)
    return await service.send_telegram_alert_with_image(violation_data, image_path)
