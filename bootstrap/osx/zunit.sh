#!/usr/bin/env zsh
# taken from https://raw.githubusercontent.com/zulu-zsh/install/master/install
# because i don't trust the internet
if ! command -v zunit >/dev/null ; then
  local base=${ZULU_DIR:-"${ZDOTDIR:-$HOME}/.zulu"}
  local config=${ZULU_CONFIG_DIR:-"${ZDOTDIR:-$HOME}/.config/zulu"}

  function _zulu_color() {
    local color=$1

    shift

    case $color in
      black)    echo "\033[0;30m${@}\033[0;m" ;;
      red)      echo "\033[0;31m${@}\033[0;m" ;;
      green)    echo "\033[0;32m${@}\033[0;m" ;;
      yellow)   echo "\033[0;33m${@}\033[0;m" ;;
      blue)     echo "\033[0;34m${@}\033[0;m" ;;
      magenta)  echo "\033[0;35m${@}\033[0;m" ;;
      cyan)     echo "\033[0;36m${@}\033[0;m" ;;
      white)    echo "\033[0;37m${@}\033[0;m" ;;
    esac
  }

  function _zulu_spinner_callback() {
    print $@
  }

  function _zulu_spinner_process() {
    local msg="$1" spinner_index=0

    while [[ 1 -eq 1 ]]; do
      _zulu_spinner_spin
      sleep 0.1
    done
  }

  function _zulu_spinner_spin() {
    local -a frames; frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

    # ZSH arrays start at 1, so we need to bump the index if it's 0
    if [[ $spinner_index -eq 0 ]]; then
      spinner_index+=1
    fi

    # Echo the frame
    echo -n $frames[$spinner_index]

    # Set the spinner index to the next frame
    spinner_index=$(( $(( $spinner_index + 1 )) % ${#frames} ))

    # Echo the message and return to the beginning of the line
    echo -en " $msg\r"
  }

  function _zulu_spinner_start() {
    local msg="$1"

    _zulu_spinner_process "$msg" &!
    export ZULU_SPINNER_PID=$!
  }

  function _zulu_spinner_stop() {
    [[ "$ZULU_SPINNER_PID" != "" ]] && kill "$ZULU_SPINNER_PID" > /dev/null
    unset ZULU_SPINNER_PID
  }


  ###
  # Create the zulu directory structure
  ###
  function _zulu_create_base() {
    local -a dirs; dirs=('bin' 'init' 'packages' 'share')
    for dir in "${dirs[@]}"; do
      mkdir -p "$base/$dir"
      touch "$base/$dir/.gitkeep"
    done

    mkdir -p "$config/functions"
    touch "$config/packages"
  }

  ###
  # Install the zulu core functions
  ###
  function _zulu_install_core() {
    git clone "https://github.com/zulu-zsh/zulu" "$base/core"
  }

  ###
  # Install the package index
  ###
  function _zulu_install_index() {
    git clone "https://github.com/zulu-zsh/index" "$base/index"
  }

  ###
  # Use current $PATH to build a pathfile
  ###
  function _zulu_create_path() {
    local pathfile="$config/path"

    typeset -gUa items; items=()
    items+="$base/bin"
    for p in "${path[@]}"; do
      items+="$p"
    done

    local separator out

    # Separate the array by newlines, and print the contents to the pathfile
    separator=$'\n'
    local oldIFS=$IFS
    IFS="$separator"; out="${items[*]/#/${separator}}"
    echo ${out:${#separator}} >! $pathfile
    IFS=$oldIFS
    unset oldIFS
  }

  ###
  # Use current $fpath to build an fpathfile
  ###
  function _zulu_create_fpath() {
    local fpathfile="$config/fpath"

    typeset -gUa items; items=()
    items+="$base/share"
    for p in "${fpath[@]}"; do
      items+="$p"
    done

    local separator out

    # Separate the array by newlines, and print the contents to the fpathfile
    separator=$'\n'
    local oldIFS=$IFS
    IFS="$separator"; out="${items[*]/#/${separator}}"
    echo ${out:${#separator}} >! $fpathfile
    IFS=$oldIFS
    unset oldIFS
  }

  ###
  # Use current $cdpath to build an cdpathfile
  ###
  function _zulu_create_cdpath() {
    local cdpathfile="$config/cdpath"

    typeset -gUa items; items=()
    for p in "${cdpath[@]}"; do
      items+="$p"
    done

    local separator out

    # Separate the array by newlines, and print the contents to the cdpathfile
    separator=$'\n'
    local oldIFS=$IFS
    IFS="$separator"; out="${items[*]/#/${separator}}"
    echo ${out:${#separator}} >! $cdpathfile
    IFS=$oldIFS
    unset oldIFS
  }

  ###
  # Use current aliases to build alias file
  ###
  function _zulu_create_aliases() {
    local aliasfile="$config/alias"
    echo "" > $aliasfile
    local oldIFS=$IFS
    IFS=$'\n'; for a in `alias`; do
      echo "alias $a\n" >> $aliasfile
    done
    IFS=$oldIFS
    unset oldIFS
  }

  ###
  # Install the zulu completion definitions
  ###
  function _zulu_install_completion() {
    ln -s "$base/core/zulu.zsh-completion" "$base/share/_zulu"
  }

  ###
  # Install the initialization script
  ###
  function _zulu_install_init() {
    # Check if a .zshrc already exists
    if [[ -e "${ZDOTDIR:-$HOME}/.zshrc" ]]; then
      # If it contains the command 'zulu init', we don't need to
      # add the initialisation script again
      local check_script=$(cat "${ZDOTDIR:-$HOME}/.zshrc" | grep 'zulu init')
      if [[ -n "$check_script" ]]; then
        return 0
      fi
    fi

    # Add the init script to .zshrc
    local init='
  # Initialise zulu plugin manager
  source "${ZULU_DIR:-"${ZDOTDIR:-$HOME}/.zulu"}/core/zulu"
  zulu init
  '

    echo "$init" >> "${ZDOTDIR:-$HOME}/.zshrc"
  }

  ###
  # Remove zulu directories if install fails
  ###
  function _zulu_install_cleanup_on_failure() {
    _zulu_spinner_start "Rolling back installation..."

    if [[ -d $base ]]; then
      rm -rf $base
    fi

    if [[ -d $config && $config_exists -eq 0 ]]; then
      rm -rf $config
    fi

    echo "$(_zulu_color green '✔') Installation rolled back successfully        "
    _zulu_spinner_stop
  }

  ###
  # Install the zulu framework
  ###
  function zulu_install() {
    local out config_exists=0 overwrite_config=0

    if [[ -d $base ]]; then
      echo $(_zulu_color red "Zulu is already installed at $base.")
      echo "If you are wishing to update zulu, you should run 'zulu self-update' instead."
      return 1
    fi

    if [[ -d $config ]]; then
      config_exists=1
      echo $(_zulu_color yellow "Config already exists at $config. Overwrite? [y|N]")
      read -rs -k 1 input

      case $input in
        y)
          overwrite_config=1
          ;;
        *)
          overwrite_config=0
          ;;
      esac
    fi

    _zulu_spinner_start "Creating directory structure..."
    out=$(_zulu_create_base 2>&1)

    if [ $? -eq 0 ]; then
      _zulu_spinner_stop
      echo "$(_zulu_color green '✔') Created directory structure        "
    else
      _zulu_spinner_stop
      echo "$(_zulu_color red '✘') Error creating directory structure        "
      echo "$out"
      _zulu_install_cleanup_on_failure
      exit 1
    fi

    _zulu_spinner_start "Installing zulu core..."
    out=$(_zulu_install_core 2>&1)

    if [ $? -eq 0 ]; then
      _zulu_spinner_stop
      echo "$(_zulu_color green '✔') Installed zulu core        "
    else
      _zulu_spinner_stop
      echo "$(_zulu_color red '✘') Error installing zulu core        "
      echo "$out"
      _zulu_install_cleanup_on_failure
      exit 1
    fi

    _zulu_spinner_start "Installing package index..."
    out=$(_zulu_install_index 2>&1)

    if [ $? -eq 0 ]; then
      _zulu_spinner_stop
      echo "$(_zulu_color green '✔') Installed package index        "
    else
      _zulu_spinner_stop
      echo "$(_zulu_color red '✘') Error installing package index        "
      echo "$out"
      _zulu_install_cleanup_on_failure
      exit 1
    fi

    if [[ $config_exists -eq 0 ]] || [[ $config_exists -eq 1 && $overwrite_config -eq 1 ]]; then
      _zulu_spinner_start "Initializing \$PATH..."
      out=$(_zulu_create_path 2>&1)

      if [ $? -eq 0 ]; then
        _zulu_spinner_stop
        echo "$(_zulu_color green '✔') Initialized \$PATH        "
      else
        _zulu_spinner_stop
        echo "$(_zulu_color red '✘') Error initializing \$PATH        "
        echo "$out"
        _zulu_install_cleanup_on_failure
        exit 1
      fi

      _zulu_spinner_start "Initializing \$fpath..."
      out=$(_zulu_create_fpath 2>&1)

      if [ $? -eq 0 ]; then
        _zulu_spinner_stop
        echo "$(_zulu_color green '✔') Initialized \$fpath        "
      else
        _zulu_spinner_stop
        echo "$(_zulu_color red '✘') Error initializing \$fpath        "
        echo "$out"
        _zulu_install_cleanup_on_failure
        exit 1
      fi

      _zulu_spinner_start "Initializing \$cdpath..."
      out=$(_zulu_create_cdpath 2>&1)

      if [ $? -eq 0 ]; then
        _zulu_spinner_stop
        echo "$(_zulu_color green '✔') Initialized \$cdpath        "
      else
        _zulu_spinner_stop
        echo "$(_zulu_color red '✘') Error initializing \$cdpath        "
        echo "$out"
        _zulu_install_cleanup_on_failure
        exit 1
      fi

      _zulu_spinner_start "Initializing aliases..."
      out=$(_zulu_create_aliases 2>&1)

      if [ $? -eq 0 ]; then
        _zulu_spinner_stop
        echo "$(_zulu_color green '✔') Initialized aliases        "
      else
        _zulu_spinner_stop
        echo "$(_zulu_color red '✘') Error initializing aliases        "
        echo "$out"
        _zulu_install_cleanup_on_failure
        exit 1
      fi

      _zulu_spinner_start "Installing completion..."
      out=$(_zulu_install_completion 2>&1)

      if [ $? -eq 0 ]; then
        _zulu_spinner_stop
        echo "$(_zulu_color green '✔') Installed completion        "
      else
        _zulu_spinner_stop
        echo "$(_zulu_color red '✘') Error installing completion        "
        echo "$out"
        _zulu_install_cleanup_on_failure
        exit 1
      fi
    fi

    _zulu_spinner_start "Installing initialization script..."
    out=$(_zulu_install_init 2>&1)

    if [ $? -eq 0 ]; then
      _zulu_spinner_stop
      echo "$(_zulu_color green '✔') Installed initialization script        "
    else
      _zulu_spinner_stop
      echo "$(_zulu_color red '✘') Error installing initialization script        "
      echo "$out"
      _zulu_install_cleanup_on_failure
      exit 1
    fi

    local oldPWD=$PWD
    cd "$base/core"
    _zulu_spinner_start "Running build script..."
    out=$(./build.zsh 2>&1)
    state=$?

    cd $oldPWD
    unset oldPWD

    if [ $state -eq 0 ]; then
      _zulu_spinner_stop
      echo "$(_zulu_color green '✔') Build script complete        "
    else
      _zulu_spinner_stop
      echo "$(_zulu_color red '✘') Error running build script        "
      echo "$out"
      _zulu_install_cleanup_on_failure
      exit 1
    fi

    # Source zulu and install dependencies
    source "$base/core/zulu"
    zulu init

    # Install some important packages
    zulu install color revolver zulu-theme
    zulu theme zulu-theme

    echo
    echo " _____         ___"
    echo "/__  /  __  __/  /_  __"
    echo "  / /  / / / /  / / / /"
    echo " / /__/ /_/ /  / /_/ /"
    echo "/____/\\____/__/\\____/"
    echo
    echo "Version $(zulu --version)"
    echo
    echo "Thanks for installing Zulu! You're now all set up and ready to go."
    echo
    echo "Documentation: https://zulu.sh/docs"
    echo "Feedback:      https://github.com/zulu-zsh/zulu/issues"
    echo "Community:     https://gitter.im/zulu-zsh/zulu"
    echo
  }

  zulu_install
fi
