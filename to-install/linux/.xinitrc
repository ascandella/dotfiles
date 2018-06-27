#xrandr --dpi 192
# xrandr --output eDP-1 --scale 1.5x1.5

# xinput --set-prop 13 "libinput Natural Scrolling Enabled" 1
xinput --set-prop 14 "libinput Natural Scrolling Enabled" 1

# For function/media keys on X1 Carbon
xbindkeys
setxkbmap dvorak

setxkbmap -option altwin:swap_alt_win

exec bspwm
