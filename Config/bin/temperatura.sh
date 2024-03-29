#!/bin/sh

#temperature=$(sensors | grep "Package id 0:" | tr -d '+' | awk '{print $4}')
#icon=""  # Ejemplo de un icono de termómetro de Nerd Fonts

#echo "$temperature $icon"
curl -s https://ipinfo.io/json | grep region | cut -d '"' -f 4
