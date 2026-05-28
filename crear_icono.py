from PIL import Image, ImageDraw

icono_path = "assets/icono_app.png"
output_path = "assets/icono_circular.png"

icono = Image.open(icono_path).convert("RGBA")
size = 1024
icono = icono.resize((size, size), Image.LANCZOS)

# Fondo azul sólido
resultado = Image.new("RGBA", (size, size), (0, 32, 91, 255))  # #00205B

# Crear máscara circular
mask = Image.new("L", (size, size), 0)
draw = ImageDraw.Draw(mask)
draw.ellipse((0, 0, size, size), fill=255)

# Pegar icono sobre fondo azul con máscara circular
resultado.paste(icono, (0, 0), mask)

resultado.save(output_path, "PNG")
print(f"OK: {output_path}")
