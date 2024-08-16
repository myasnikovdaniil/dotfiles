#!/bin/bash

MONITOR="HDMI-A-1"         # Название второго монитора
PRIMARY_MONITOR="LVDS-1"   # Название основного монитора

# Доступные позиции
POSITIONS=(
 "left"
 "right"
 "above"
)

# Файл для хранения текущей позиции
STATE_FILE="/tmp/monitor_position_state"

# Читаем текущую позицию из файла
if [ ! -f "$STATE_FILE" ]; then
 echo "0" > "$STATE_FILE"
fi

CURRENT_INDEX=$(cat "$STATE_FILE")
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#POSITIONS[@]} ))

# Переменные
P_MON_W=$(swaymsg -t get_outputs | yq -r '.[] | select(.name == "'$PRIMARY_MONITOR'") | .current_mode.width')
P_MON_H=$(swaymsg -t get_outputs | yq -r '.[] | select(.name == "'$PRIMARY_MONITOR'") | .current_mode.height')
S_MON_W=$(swaymsg -t get_outputs | yq -r '.[] | select(.name == "'$MONITOR'") | .current_mode.width')
S_MON_H=$(swaymsg -t get_outputs | yq -r '.[] | select(.name == "'$MONITOR'") | .current_mode.height')


# Устанавливаем следующую позицию
case ${POSITIONS[$NEXT_INDEX]} in
 left)
   swaymsg output $MONITOR pos -- "-$S_MON_W -$((($S_MON_H-$P_MON_H)/2))"
   ;;
 right)
   swaymsg output $MONITOR pos -- "$P_MON_W -$((($S_MON_H-$P_MON_H)/2))"
   ;;
 above)
   swaymsg output $MONITOR pos -- "-$((($S_MON_W-$P_MON_W)/2)) -$S_MON_H"
   ;;
esac

# Сохраняем следующую позицию
echo $NEXT_INDEX > "$STATE_FILE"

