#!/usr/bin/env bash
# Options
shutdown=" shutdown" # \uf011
reboot=" reboot" # \uf01e
lock=" lock" # \uf023
suspend=" suspend" # \uf186
logout=" logout" # \uf2f5

options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | rofi -dmenu -selected-row 2 -location 3)"
case "${chosen}" in
    "${shutdown}")
      systemctl poweroff
      ;;
    "${reboot}")
      systemctl reboot
      ;;
    "${lock}")
      betterlockscreen -l
      ;;
    "${suspend}")
      amixer set Master mute
      systemctl suspend
      ;;
    "${logout}")
      i3-msg exit
      ;;
    *)
      echo "$chosen"
esac
