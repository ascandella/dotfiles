#xrandr --dpi 192
# xrandr --output eDP-1 --scale 1.5x1.5

# xinput --set-prop 13 "libinput Natural Scrolling Enabled" 1
xinput --set-prop 14 "libinput Natural Scrolling Enabled" 1

if [[ -d "/etc/X11/xinit/xinitrc.d/" ]] ; then
  for f in /etc/X11/xinit/xinitrc.d/* ; do
    source $f
  done
fi

# For function/media keys on X1 Carbon
xbindkeys
setxkbmap dvorak

setxkbmap -option altwin:swap_alt_win

exec bspwm
