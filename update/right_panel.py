import customtkinter as ctk
from PIL import Image

from details_window import view_details
from alert_service import send_alert
from snapshot_service import save_snapshot

def create_right_panel(parent, app):

    # ==========================
    # RIGHT PANEL
    # ==========================

 right_panel = ctk.CTkFrame(
    parent,
    width=320,
    corner_radius=15
)

 right_panel.pack(
    side="right",
    fill="y"
)

 right_panel.pack_propagate(False)


# ==========================
# LICENSE PLATE CARD
# ==========================

 plate_card = ctk.CTkFrame(
    right_panel,
    corner_radius=12
)

 plate_card.pack(
    fill="x",
    padx=15,
    pady=15
)

 plate_title = ctk.CTkLabel(
    plate_card,
    text="LICENSE PLATE",
    font=ctk.CTkFont(
        size=16,
        weight="bold"
    )
)

 plate_title.pack(
    pady=10
)

 try:

    plate_image = ctk.CTkImage(
        light_image=Image.open("assets/plate.jpg"),
        dark_image=Image.open("assets/plate.jpg"),
        size=(280, 100)
    )

    plate_label = ctk.CTkLabel(
        plate_card,
        image=plate_image,
        text=""
    )

    plate_label.pack(
        pady=(0, 10)
    )

 except:

    plate_label = ctk.CTkLabel(
        plate_card,
        text="NO PLATE IMAGE"
    )

    plate_label.pack(
        pady=(0, 15)
    )


# ==========================
# BUTTONS
# ==========================

 details_btn = ctk.CTkButton(
    right_panel,
    text="📋 VIEW DETAILS",
    height=50,
    command=lambda: view_details(app)
)

 details_btn.pack(
    fill="x",
    padx=15,
    pady=8
)


 button_frame = ctk.CTkFrame(
    right_panel,
    fg_color="transparent"
)

 button_frame.pack(
    fill="x",
    padx=15,
    pady=10
)

 snapshot_btn = ctk.CTkButton(
    button_frame,
    text="📷 SNAPSHOT",
    command=save_snapshot
)

 snapshot_btn.pack(
    side="left",
    expand=True,
    fill="x",
    padx=(0,5)
)

 alert_btn = ctk.CTkButton(
    button_frame,
    text="🚨 ALERT",
    fg_color="#CC0000",
    hover_color="#990000",
    command=send_alert
)

 alert_btn.pack(
    side="right",
    expand=True,
    fill="x",
    padx=(5,0)
)


# ==========================
# EVIDENCE IMAGE CARD
# ==========================

 evidence_card = ctk.CTkFrame(
    right_panel,
    corner_radius=12
)

 evidence_card.pack(
    fill="x",
    padx=15,
    pady=(0,15)
)

 evidence_title = ctk.CTkLabel(
    evidence_card,
    text="EVIDENCE IMAGE",
    font=ctk.CTkFont(
        size=16,
        weight="bold"
    )
)

 evidence_title.pack(
    pady=10
)

 try:

    evidence_image = ctk.CTkImage(
        light_image=Image.open("assets/evidence.jpg"),
        dark_image=Image.open("assets/evidence.jpg"),
        size=(250,140)
    )

    evidence_label = ctk.CTkLabel(
        evidence_card,
        image=evidence_image,
        text=""
    )

    evidence_label.pack(
        pady=(0,10)
    )

 except:

    evidence_label = ctk.CTkLabel(
        evidence_card,
        text="NO EVIDENCE IMAGE"
    )

    evidence_label.pack(
        pady=(0,15)
    )

# ==========================
# LOCATION CARD
# ==========================

 location_card = ctk.CTkFrame(
    right_panel,
    corner_radius=12
)

 location_card.pack(
    fill="x",
    padx=15,
    pady=(0,10)
)

 ctk.CTkLabel(
    location_card,
    text="LOCATION",
    font=ctk.CTkFont(
        size=14,
        weight="bold"
    )
).pack(pady=(10,0))

 ctk.CTkLabel(
    location_card,
    text="Block A - Gate 2"
).pack(pady=(0,10))


# ==========================
# TIME CARD
# ==========================

 time_card = ctk.CTkFrame(
    right_panel,
    corner_radius=12
)

 time_card.pack(
    fill="x",
    padx=15,
    pady=(0,15)
)

 ctk.CTkLabel(
    time_card,
    text="TIME",
    font=ctk.CTkFont(
        size=14,
        weight="bold"
    )
).pack(pady=(10,0))

 ctk.CTkLabel(
    time_card,
    text="08:15:32"
).pack(pady=(0,10))

 status_card = ctk.CTkFrame(
    right_panel,
    corner_radius=12
)

 status_card.pack(
    fill="x",
    padx=15,
    pady=(0,15)
)

 ctk.CTkLabel(
    status_card,
    text="CURRENT STATUS",
    font=ctk.CTkFont(
        size=14,
        weight="bold"
    )
).pack(pady=(10,0))

 ctk.CTkLabel(
    status_card,
    text="ILLEGAL PARKING DETECTED",
    text_color="red",
    font=ctk.CTkFont(
        size=13,
        weight="bold"
    )
).pack(pady=(0,10))

# ==========================
# STATUS
# ==========================

 status_frame = ctk.CTkFrame(
    right_panel,
    corner_radius=12
)

 status_frame.pack(
    fill="x",
    padx=15,
    pady=15
)

 status_title = ctk.CTkLabel(
    status_frame,
    text="SYSTEM STATUS",
    font=ctk.CTkFont(
        size=15,
        weight="bold"
    )
)

 status_title.pack(
    pady=(10, 5)
)

 status_text = ctk.CTkLabel(
    status_frame,
    text=
    "🟢 Camera Online\n"
    "🟢 Detection Running\n"
    "🟢 Alert Service Connected",
    text_color="#00FF00"
)

 status_text.pack(
    pady=(0, 10)
)