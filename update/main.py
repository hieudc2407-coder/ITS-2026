import customtkinter as ctk

from camera_panel import create_camera_panel
from right_panel import create_right_panel

ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

app = ctk.CTk()

app.title("Illegal Parking Detection System")
app.geometry("1600x900")

# ==========================
# HEADER
# ==========================

header = ctk.CTkFrame(
    app,
    corner_radius=15
)

header.pack(
    fill="x",
    padx=15,
    pady=15
)

title = ctk.CTkLabel(
    header,
    text="🚗 ILLEGAL PARKING DETECTION SYSTEM",
    font=ctk.CTkFont(
        size=30,
        weight="bold"
    )
)

title.pack(pady=20)

# ==========================
# MAIN CONTENT
# ==========================

main_frame = ctk.CTkFrame(
    app,
    fg_color="transparent"
)

main_frame.pack(
    fill="both",
    expand=True,
    padx=15,
    pady=(0, 15)
)

create_camera_panel(main_frame)

create_right_panel(
    main_frame,
    app
)

app.mainloop()