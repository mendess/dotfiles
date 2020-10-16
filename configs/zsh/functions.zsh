function op () {
    xdg-open "$@" & disown 
}

extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 -v "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.xz)        xz -d "$1"     ;;
      *)           echo "$1 cannot be extracted via ex()" ;;
    esac
  else
    echo "$1 is not a valid file"
  fi
}
layout(){

    setxkbmap -layout pt -option caps:escape &
    xmodmap -e "clear lock"
    xmodmap -e "keycode 9 = Caps_Lock NoSymbol Caps_Lock"
    xmodmap -e "keycode 66 = Escape NoSymbol Escape"

}

monitor() {

  if [[ "$1" == "single" ]]; then
    xrandr --output HDMI-1 --off 
  else 
    xrandr --output HDMI-1 --auto
    xrandr --output HDMI-1 --left-of eDP-1
    layout
    
  fi

  feh --bg-fill --randomize ~/Pictures/Wallpapers/
  killall picom ; killall polybar
  picom -b --backend glx --experimental-backends & disown
  bash ~/.config/polybar/launch.sh

}

f() {

  if [ "$1" == "a" ]
  then
      FZF_DEFAULT_COMMAND='find .' f
      exit
  fi

  file=$(fzf --preview-window=right:60% --preview='bat --color "always" {}')
  filetype=$(xdg-mime query filetype "$file")
  app=$(xdg-mime query default "$filetype")

  if [ "$app" == "nvim.desktop" ]
  then
      nvim "$file"
  elif [ "$1" == "launcher" ]
  then
    setsid /bin/sh -c "xdg-open $file" &>/dev/null </dev/null &
    sleep 0.01
  else
      xdg-open "$file" & disown 
  fi

}

mkcd() {
  mkdir $@
  cd $@
}
randfile() {
    length=`ls $1 | wc -l`
    number=$(($RANDOM%$length))
    name=`ls $1 | head -$number | tail -1`
    echo $name

}

send-sms() {
  curl -X POST https://textbelt.com/text \
       --data-urlencode phone="$1" \
       --data-urlencode message="$2" \
       -d key=textbelt
}

torrent(){

  transmission-daemon --download-dir "~/Downloads"
  transmission-remote "$1" "$2" 2> /dev/null

}

