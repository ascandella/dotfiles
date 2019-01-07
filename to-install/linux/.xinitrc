# System wide stuff, set by DE normally
if [[ -d "/etc/X11/xinit/xinitrc.d/" ]] ; then
  for f in /etc/X11/xinit/xinitrc.d/* ; do
    source $f
  done
fi


# Multimedia keys
xbindkeys
# God's keyboard layout
setxkbmap dvorak
setxkbmap -option altwin:swap_alt_win
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

export SSH_AUTH_SOCK

if [[ -d "${HOME}/.xinitrc.local" ]] ; then
  source "${HOME}/.xinitrc.local"
fi

# Auto-set blue light filter at night
blugon --interval 10 &

exec bspwm

# vim: ft=sh
