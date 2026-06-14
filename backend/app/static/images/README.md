# Static Images Directory

## Instructions for Adding Violation Car Image

1. **Prepare Image:**
   - Get an image of a GMC Terrain (or any vehicle) parked in violation
   - Recommended format: PNG or JPG
   - Recommended size: 800x600px or higher

2. **Place Image:**
   - Copy the image file to this directory
   - Rename it to: `violation_car.png`
   - Example: `violation_car.png`

3. **Access via API:**
   - Once placed, the image will be accessible at:
     ```
     http://localhost:8000/static/images/violation_car.png
     ```

4. **Telegram Integration:**
   - The Backend will automatically send this image when an alert is triggered
   - The image will be included in the Telegram message with violation details

## Example File Structure

```
backend/app/static/images/
├── README.md (this file)
└── violation_car.png (your image here)
```

## Notes

- The image is used in the `/api/violations/{id}/alert` endpoint
- Frontend Dashboard will display the image from the `/static/images/` route
- Make sure CORS is enabled in FastAPI (already configured)
