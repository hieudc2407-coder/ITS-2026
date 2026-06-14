import customtkinter as ctk


def view_details(app):

    detail_window = ctk.CTkToplevel(app)

    detail_window.title("Violation Details")
    detail_window.geometry("500x550")

    title = ctk.CTkLabel(
        detail_window,
        text="VIOLATION DETAILS",
        font=ctk.CTkFont(
            size=22,
            weight="bold"
        )
    )

    title.pack(pady=20)

    cards = [

        ("VIOLATION",
         "Parking in Emergency Lane"),

        ("TRAFFIC SIGN",
         "NO PARKING"),

        ("RESTRICTED ZONE",
         "Emergency Lane"),

        ("DETECTION RESULT",
         "✓ Vehicle Detected\n"
         "✓ Plate Detected\n"
         "✓ Traffic Sign Detected\n"
         "✓ Illegal Parking Confirmed")
    ]

    for title_text, value_text in cards:

        card = ctk.CTkFrame(
            detail_window,
            corner_radius=10
        )

        card.pack(
            fill="x",
            padx=20,
            pady=10
        )

        ctk.CTkLabel(
            card,
            text=title_text,
            font=ctk.CTkFont(
                size=14,
                weight="bold"
            )
        ).pack(
            pady=(10, 0)
        )

        ctk.CTkLabel(
            card,
            text=value_text
        ).pack(
            pady=(0, 10)
        )

    close_btn = ctk.CTkButton(
        detail_window,
        text="CLOSE",
        command=detail_window.destroy
    )

    close_btn.pack(
        pady=20
    )