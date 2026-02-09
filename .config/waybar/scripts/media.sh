#!/bin/bash

INFO=$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null)
PLAYER=$(playerctl -l 2>/dev/null | head -n1)

if [ -z "$INFO" ]; then
  echo '{"text":"", "class":"custom-media"}'
  exit 0
fi

# cortar texto longo
MAX=35
if [ ${#INFO} -gt $MAX ]; then
  INFO="${INFO:0:$MAX}..."
fi

# ícones por player
ICON="🎧"
CLASS="custom-media"

if [[ "$PLAYER" == *spotify* ]]; then
  ICON=""
  CLASS="custom-spotify"
elif [[ "$PLAYER" == *firefox* || "$PLAYER" == *chromium* ]]; then
  ICON=""
  CLASS="custom-youtube"
elif [[ "$PLAYER" == *vlc* ]]; then
  ICON="󰕼"
  CLASS="custom-vlc"
fi

echo "{\"text\":\"$ICON $INFO\", \"class\":\"$CLASS\"}"
