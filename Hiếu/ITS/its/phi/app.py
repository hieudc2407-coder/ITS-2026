import tkinter as tk
from tkinter import messagebox
from PIL import Image, ImageTk


# ==========================
# Alert Function
# ==========================

def send_alert():
    status_label.config(
        text="Status: Alert Sent",
        fg="orange"
    )

    messagebox.showinfo(
        "Notification",
        "Alert has been sent to vehicle owner."
    )


# ==========================
# Main Window
# ==========================

root = tk.Tk()

root.title("Illegal Parking Detection System")
root.geometry("1400x800")
root.configure(bg="#111111")


# ==========================
# Header
# ==========================

title = tk.Label(
    root,
    text="🚗 ILLEGAL PARKING DETECTION SYSTEM",
    bg="#111111",
    fg="white",
    font=("Arial", 22, "bold")
)

title.pack(pady=15)


# ==========================
# Main Frame
# ==========================

main_frame = tk.Frame(
    root,
    bg="#111111"
)

main_frame.pack(
    fill="both",
    expand=True,
    padx=10,
    pady=10
)


# ==========================
# Camera Panel
# ==========================

camera_frame = tk.Frame(
    main_frame,
    bg="#222222",
    width=800
)

camera_frame.pack(
    side="left",
    fill="both",
    expand=True,
    padx=5
)

camera_label = tk.Label(
    camera_frame,
    text="📹 CAMERA FEED",
    bg="#000000",
    fg="#00FF00",
    font=("Arial", 20, "bold")
)

camera_label.pack(
    fill="both",
    expand=True,
    padx=10,
    pady=10
)


# ==========================
# Information Panel
# ==========================

info_frame = tk.Frame(
    main_frame,
    bg="#1A1A1A",
    width=550
)

info_frame.pack(
    side="right",
    fill="y",
    padx=5
)

# ==========================
# Title
# ==========================

info_title = tk.Label(
    info_frame,
    text="🚨 VIOLATION INFORMATION",
    bg="#1A1A1A",
    fg="red",
    font=("Arial", 16, "bold")
)

info_title.pack(pady=15)


# ==========================
# License Plate Image
# ==========================

plate_title = tk.Label(
    info_frame,
    text="LICENSE PLATE",
    bg="#1A1A1A",
    fg="white",
    font=("Arial", 12, "bold")
)

plate_title.pack()

try:
    plate_img = Image.open("assets/plate.jpg")
    plate_img = plate_img.resize((250, 80))

    plate_photo = ImageTk.PhotoImage(plate_img)

    plate_label = tk.Label(
        info_frame,
        image=plate_photo,
        bg="#1A1A1A"
    )

    plate_label.image = plate_photo
    plate_label.pack(pady=10)

except:
    plate_placeholder = tk.Label(
        info_frame,
        text="NO PLATE IMAGE",
        bg="#333333",
        fg="white",
        width=25,
        height=4
    )

    plate_placeholder.pack(pady=10)


# ==========================
# Violation
# ==========================

violation = tk.Label(
    info_frame,
    text="❌ Violation:\nParking in Emergency Lane",
    bg="#1A1A1A",
    fg="orange",
    font=("Arial", 13)
)

violation.pack(pady=8)


# ==========================
# Location
# ==========================

location = tk.Label(
    info_frame,
    text="📍 Location:\nBlock A - Gate 2",
    bg="#1A1A1A",
    fg="white",
    font=("Arial", 13)
)

location.pack(pady=8)


# ==========================
# Traffic Sign
# ==========================

traffic_sign = tk.Label(
    info_frame,
    text="🚫 Traffic Sign:\nNO PARKING",
    bg="#1A1A1A",
    fg="white",
    font=("Arial", 13)
)

traffic_sign.pack(pady=8)


# ==========================
# Restricted Zone
# ==========================

restricted_zone = tk.Label(
    info_frame,
    text="⛔ Restricted Zone:\nEmergency Lane",
    bg="#1A1A1A",
    fg="white",
    font=("Arial", 13)
)

restricted_zone.pack(pady=8)


# ==========================
# Time
# ==========================

time_label = tk.Label(
    info_frame,
    text="🕒 Time:\n08:15:32",
    bg="#1A1A1A",
    fg="white",
    font=("Arial", 13)
)

time_label.pack(pady=8)


# ==========================
# Evidence Image
# ==========================

evidence_title = tk.Label(
    info_frame,
    text="EVIDENCE IMAGE",
    bg="#1A1A1A",
    fg="white",
    font=("Arial", 12, "bold")
)

evidence_title.pack(pady=(15, 5))

try:
    evidence_img = Image.open("assets/evidence.jpg")
    evidence_img = evidence_img.resize((280, 120))

    evidence_photo = ImageTk.PhotoImage(evidence_img)

    evidence_label = tk.Label(
        info_frame,
        image=evidence_photo,
        bg="#1A1A1A"
    )

    evidence_label.image = evidence_photo
    evidence_label.pack(pady=5)

except:
    evidence_placeholder = tk.Label(
        info_frame,
        text="NO EVIDENCE IMAGE",
        bg="#333333",
        fg="white",
        width=35,
        height=6
    )

    evidence_placeholder.pack(pady=5)


# ==========================
# Status
# ==========================

status_label = tk.Label(
    info_frame,
    text="Status: Ready",
    bg="#1A1A1A",
    fg="#00FF00",
    font=("Arial", 11, "bold")
)

status_label.pack(side="bottom", pady=5)


# ==========================
# Alert Button
# ==========================

alert_button = tk.Button(
    info_frame,
    text="📨 SEND ALERT",
    bg="#cc0000",
    fg="white",
    font=("Arial", 14, "bold"),
    command=send_alert
)

alert_button.pack(
    side="bottom",
    fill="x",
    padx=20,
    pady=15
)


# ==========================
# Run App
# ==========================

root.mainloop()