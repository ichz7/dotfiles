#!/usr/bin/env bash

# Caminhos
WALL_DIR="$HOME/wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper_thumbs"

# Criar pasta de cache se não existir
mkdir -p "$CACHE_DIR"

# 1. Gerar miniaturas (Horizontal 16:9)
echo "Gerando miniaturas..."
# Usamos um loop mais robusto que não reclama se uma extensão faltar
find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | while read -r img; do
    img_name=$(basename "$img")
    if [ ! -f "$CACHE_DIR/$img_name" ]; then
        # Criamos uma miniatura 16:9 (ex: 320x180)
        magick "$img" -thumbnail 320x180^ -gravity center -extent 320x180 "$CACHE_DIR/$img_name"
    fi
done

# 2. Montar a lista para o Rofi
LISTA=""
while read -r img; do
    name=$(basename "$img")
    LISTA+="$name\0icon\x1f$CACHE_DIR/$name\n"
done < <(find "$WALL_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))

# 3. Rofi com layout Horizontal
# Ajustei o theme-str para dar destaque à largura da imagem
CHOICE=$(echo -e "$LISTA" | rofi -dmenu -i -show-icons -p "🖼️ Wallpaper" \
    -theme-str '
        window { width: 50%; }
        listview { columns: 2; lines: 4; scrollbar: false; }
        element { orientation: horizontal; padding: 10px; spacing: 15px; }
        element-icon { size: 160px; }
        element-text { vertical-align: 0.5; }
    ')

# 4. Aplicar
if [ -n "$CHOICE" ]; then
    swww img "$WALL_DIR/$CHOICE" --transition-type grow --transition-fps 60
    notify-send "Wallpaper" "Fundo alterado para $CHOICE"
fi