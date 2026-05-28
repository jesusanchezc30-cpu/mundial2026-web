from PIL import Image

icono_path = "assets/icono_app.png"
output_path = "assets/icono_splash.png"

icono = Image.open(icono_path).convert("RGBA")

canvas_size = 1024
canvas = Image.new("RGBA", (canvas_size, canvas_size), (0, 32, 91, 255))

icon_size = int(canvas_size * 0.60)
icono_resized = icono.resize((icon_size, icon_size), Image.LANCZOS)

# Centrado perfectamente
offset = (canvas_size - icon_size) // 2
canvas.paste(icono_resized, (offset, offset), icono_resized)

canvas.save(output_path, "PNG")
print(f"OK: {output_path}")
