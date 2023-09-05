#!/bin/zsh

battery_info=$(acpi -b)
formatted_info=$(echo $battery_info | awk -F ', ' '{print $1, $2}' | sed 's/Battery [0-9]: //')
battery_icon=""

echo "$battery_icon $formatted_info"
