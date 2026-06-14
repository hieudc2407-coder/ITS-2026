import customtkinter as ctk


def create_camera_panel(parent):

    camera_frame = ctk.CTkFrame(
        parent,
        corner_radius=15
    )

    camera_frame.pack(
        side="left",
        fill="both",
        expand=True,
        padx=(0, 10)
    )

    camera_label = ctk.CTkLabel(
        camera_frame,
        text="📹 CAMERA FEED",
        text_color="#00FF00",
        font=ctk.CTkFont(
            size=24,
            weight="bold"
        )
    )

    camera_label.pack(
        pady=15
    )

    camera_info = ctk.CTkLabel(
        camera_frame,
        text=
        "Camera ID: CAM-01 | FPS: 30 | Status: Online",
        text_color="lightgray",
        font=("Arial", 12)
    )

    camera_info.pack(
        pady=(0, 10)
    )

    camera_placeholder = ctk.CTkFrame(
        camera_frame,
        fg_color="black",
        corner_radius=10
    )

    camera_placeholder.pack(
        fill="both",
        expand=True,
        padx=15,
        pady=(0, 15)
    )

    video_text = ctk.CTkLabel(
        camera_placeholder,
        text="VIDEO STREAM",
        text_color="#00FF00",
        font=ctk.CTkFont(
            size=28,
            weight="bold"
        )
    )

    video_text.place(
        relx=0.5,
        rely=0.5,
        anchor="center"
    )