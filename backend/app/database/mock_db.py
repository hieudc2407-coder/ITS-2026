"""Mock database with sample parking violation data"""

from typing import List, Dict, Optional
from datetime import datetime


class Violation:
    """Parking Violation model"""
    
    def __init__(
        self,
        id: int,
        status: str,
        vehicle: str,
        location: str,
        owner: str,
        phone: str,
        room: str,
        history: str,
        image_url: str,
        timestamp: str
    ):
        self.id = id
        self.status = status  # "pending", "alerted", "resolved"
        self.vehicle = vehicle
        self.location = location
        self.owner = owner
        self.phone = phone
        self.room = room
        self.history = history
        self.image_url = image_url
        self.timestamp = timestamp
    
    def to_dict(self) -> Dict:
        """Convert to dictionary"""
        return {
            "id": self.id,
            "status": self.status,
            "vehicle": self.vehicle,
            "location": self.location,
            "owner": self.owner,
            "phone": self.phone,
            "room": self.room,
            "history": self.history,
            "image_url": self.image_url,
            "timestamp": self.timestamp
        }


# Mock database - In-memory storage
violations_db: List[Violation] = [
    Violation(
        id=1,
        status="pending",
        vehicle="GMC Terrain - 51A-987.65",
        location="ZONE A (Main Entrance)",
        owner="Nguyễn Đức Hoàng",
        phone="091.234.5678",
        room="Căn hộ A1203, Tòa S1",
        history="2 lần (2026-05-20, 2026-06-01)",
        image_url="/static/images/violation_car.png",
        timestamp="2026-06-10 14:32:01"
    ),
    Violation(
        id=2,
        status="pending",
        vehicle="Toyota Innova - 51B-456.78",
        location="ZONE B (Emergency Lane)",
        owner="Trần Văn Minh",
        phone="092.345.6789",
        room="Căn hộ B2105, Tòa S2",
        history="1 lần (2026-06-09)",
        image_url="/static/images/violation_car.png",
        timestamp="2026-06-10 13:15:30"
    ),
    Violation(
        id=3,
        status="alerted",
        vehicle="Honda CR-V - 51C-789.01",
        location="ZONE A (Main Entrance)",
        owner="Lê Thị Hương",
        phone="093.456.7890",
        room="Căn hộ A1501, Tòa S1",
        history="3 lần (2026-05-15, 2026-05-28, 2026-06-05)",
        image_url="/static/images/violation_car.png",
        timestamp="2026-06-10 12:00:00"
    ),
]


def get_all_violations() -> List[Dict]:
    """Get all violations"""
    return [v.to_dict() for v in violations_db]


def get_violation_by_id(violation_id: int) -> Optional[Dict]:
    """Get violation by ID"""
    for violation in violations_db:
        if violation.id == violation_id:
            return violation.to_dict()
    return None


def get_violations_by_status(status: str) -> List[Dict]:
    """Get violations filtered by status"""
    return [v.to_dict() for v in violations_db if v.status == status]


def update_violation_status(violation_id: int, new_status: str) -> bool:
    """Update violation status"""
    for violation in violations_db:
        if violation.id == violation_id:
            violation.status = new_status
            return True
    return False


def get_violation_data_for_alert(violation_id: int) -> Optional[Dict]:
    """Get violation data formatted for Telegram alert"""
    violation = get_violation_by_id(violation_id)
    if not violation:
        return None
    
    return {
        "vehicle": violation["vehicle"],
        "location": violation["location"],
        "owner": violation["owner"],
        "phone": violation["phone"],
        "room": violation["room"],
        "image_url": violation["image_url"]
    }
