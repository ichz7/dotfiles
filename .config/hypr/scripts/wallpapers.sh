#!/usr/bin/env bash

# 1. Selecionar um wallpaper aleatório
# Usei o 'find' porque ele lida melhor com nomes de arquivos do que o 'ls'
WALLPAPER=$(find "$HOME/wallpapers" -type f | shuf -n 1)

# 2. Verificar se o daemon do swww está rodando
# (Se não estiver, ele inicia automaticamente)
if ! pgrep -x "swww-daemon" > /dev/null; then
    swww-daemon &
    sleep 0.5 # Pequena pausa para o daemon carregar
fi

# 3. O "Pulo do Gato": Mudar o wallpaper com transição
# Escolhi o efeito 'grow' (círculo abrindo), mas você pode trocar
swww img "$WALLPAPER" \
    --transition-type grow \
    --transition-pos 0.5,0.5 \
    --transition-duration 1.5 \
    --transition-fps 60

# Opcional: Notificação no sistema (já que você instalou o SwayNC)
notify-send "Wallpaper Alterado" "Novo fundo: $(basename "$WALLPAPER")" -i "image-x-generic"