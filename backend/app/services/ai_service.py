"""AI Service for YOLO-based parking violation detection"""

import cv2
import numpy as np
from pathlib import Path
from typing import Tuple, Optional
import logging
from datetime import datetime

logger = logging.getLogger(__name__)


class YOLODetector:
    """YOLO-based detector for parking violations"""
    
    def __init__(self, model_name: str = "yolov8n.pt", output_dir: str = "output"):
        """
        Initialize YOLO Detector
        
        Args:
            model_name: YOLO model name (e.g., 'yolov8n.pt')
            output_dir: Directory to save output images
        """
        self.model_name = model_name
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(exist_ok=True, parents=True)
        
        # Simulated model (in production, load actual YOLO model)
        self.model = None
        logger.info(f"YOLODetector initialized with model: {model_name}")
        
    def detect_violations(self, frame: np.ndarray) -> Tuple[np.ndarray, list]:
        """
        Detect parking violations in a frame
        
        Args:
            frame: Input image frame (numpy array)
            
        Returns:
            Tuple of:
                - Output frame with detections drawn
                - List of detected violations with bounding boxes
        """
        try:
            output_frame = frame.copy()
            detections = []
            
            # Simulated detection logic
            # In production, this would use actual YOLO model:
            # results = self.model(frame)
            
            # For now, simulate by detecting vehicles in lower half of frame
            height, width = frame.shape[:2]
            
            # Simulate some random detections
            detected_cars = self._simulate_detections(width, height)
            
            for i, (x1, y1, x2, y2, confidence) in enumerate(detected_cars):
                # Draw bounding box in red
                cv2.rectangle(output_frame, (x1, y1), (x2, y2), (0, 0, 255), 2)
                
                # Add label
                label = f"Car {i+1}: {confidence:.2%}"
                cv2.putText(
                    output_frame, 
                    label, 
                    (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.5,
                    (0, 0, 255),
                    2
                )
                
                detections.append({
                    "id": i,
                    "bbox": [x1, y1, x2, y2],
                    "confidence": confidence,
                    "label": "parking_violation"
                })
            
            logger.info(f"Detected {len(detections)} potential violations")
            return output_frame, detections
            
        except Exception as e:
            logger.error(f"Error during detection: {str(e)}")
            return frame, []
    
    def _simulate_detections(self, width: int, height: int) -> list:
        """
        Simulate vehicle detections for demo purposes
        
        Returns:
            List of detected boxes as (x1, y1, x2, y2, confidence)
        """
        import random
        
        detections = []
        # Simulate 1-3 detections in lower half of frame
        num_detections = random.randint(1, 3)
        
        for _ in range(num_detections):
            # Random position in lower half of frame
            x1 = random.randint(0, width - 150)
            y1 = random.randint(int(height * 0.6), height - 100)
            x2 = x1 + random.randint(80, 150)
            y2 = y1 + random.randint(60, 120)
            
            confidence = random.uniform(0.7, 0.99)
            detections.append((x1, y1, x2, y2, confidence))
        
        return detections
    
    def process_frame(
        self, 
        frame: np.ndarray, 
        violation_id: Optional[str] = None
    ) -> Tuple[np.ndarray, str]:
        """
        Process a frame and save output with detections
        
        Args:
            frame: Input image frame
            violation_id: Optional violation ID for naming
            
        Returns:
            Tuple of:
                - Processed frame with bounding boxes
                - Path to saved output image
        """
        try:
            # Detect violations
            output_frame, detections = self.detect_violations(frame)
            
            # Generate output filename
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            violation_id = violation_id or "unknown"
            output_filename = f"violation_{violation_id}_{timestamp}.jpg"
            output_path = self.output_dir / output_filename
            
            # Save output frame
            cv2.imwrite(str(output_path), output_frame)
            logger.info(f"Output image saved to: {output_path}")
            
            return output_frame, str(output_path)
            
        except Exception as e:
            logger.error(f"Error processing frame: {str(e)}")
            return frame, ""
    
    def draw_bounding_boxes(
        self, 
        frame: np.ndarray, 
        detections: list,
        color: Tuple[int, int, int] = (0, 0, 255)
    ) -> np.ndarray:
        """
        Draw bounding boxes on frame
        
        Args:
            frame: Input frame
            detections: List of detections with bbox coordinates
            color: RGB color for boxes (default: red)
            
        Returns:
            Frame with drawn bounding boxes
        """
        output_frame = frame.copy()
        
        for detection in detections:
            x1, y1, x2, y2 = detection["bbox"]
            cv2.rectangle(output_frame, (x1, y1), (x2, y2), color, 2)
            
            label = f"{detection['label']}: {detection['confidence']:.2%}"
            cv2.putText(
                output_frame,
                label,
                (x1, y1 - 10),
                cv2.FONT_HERSHEY_SIMPLEX,
                0.5,
                color,
                2
            )
        
        return output_frame
