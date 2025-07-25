#compdef tv

autoload -U is-at-least

_tv() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" : \
'--preview-offset=[A preview line number offset template to use to scroll the preview to for each entry.]:STRING:_default' \
'-t+[The application'\''s tick rate.]:FLOAT:_default' \
'--tick-rate=[The application'\''s tick rate.]:FLOAT:_default' \
'(--select-1 --take-1 --take-1-fast)--watch=[Watch mode\: reload the source command every N seconds.]:FLOAT:_default' \
'-k+[Keybindings to override the default keybindings.]:STRING:_default' \
'--keybindings=[Keybindings to override the default keybindings.]:STRING:_default' \
'-i+[Input text to pass to the channel to prefill the prompt.]:STRING:_default' \
'--input=[Input text to pass to the channel to prefill the prompt.]:STRING:_default' \
'--input-header=[Input field header template.]:STRING:_default' \
'--input-prompt=[Input prompt string]:STRING:_default' \
'(--no-preview)--preview-header=[Preview header template]:STRING:_default' \
'(--no-preview)--preview-footer=[Preview footer template]:STRING:_default' \
'-s+[Source command to use for the current channel.]:STRING:_default' \
'--source-command=[Source command to use for the current channel.]:STRING:_default' \
'--source-display=[Source display template to use for the current channel.]:STRING:_default' \
'--source-output=[Source output template to use for the current channel.]:STRING:_default' \
'--source-entry-delimiter=[The delimiter byte to use for splitting the source'\''s command output into entries.]:STRING:_default' \
'(--no-preview)-p+[Preview command to use for the current channel.]:STRING:_default' \
'(--no-preview)--preview-command=[Preview command to use for the current channel.]:STRING:_default' \
'--layout=[Layout orientation for the UI.]:LAYOUT:(landscape portrait)' \
'--autocomplete-prompt=[Try to guess the channel from the provided input prompt.]:STRING:_default' \
'--ui-scale=[Change the display size in relation to the available area.]:INTEGER:_default' \
'(--no-preview)--preview-size=[Percentage of the screen to allocate to the preview panel (1-99).]:INTEGER:_default' \
'--config-file=[Provide a custom configuration file to use.]:PATH:_default' \
'--cable-dir=[Provide a custom cable directory to use.]:PATH:_default' \
'(--inline)--height=[Height in lines for non-fullscreen mode.]:INTEGER:_default' \
'--width=[Width in columns for non-fullscreen mode.]:INTEGER:_default' \
'(--preview-offset --preview-header --preview-footer --preview-size -p --preview-command --hide-preview --show-preview)--no-preview[Disable the preview panel entirely on startup.]' \
'(--no-preview --show-preview)--hide-preview[Hide the preview panel on startup (only works if feature is enabled).]' \
'(--no-preview --hide-preview)--show-preview[Show the preview panel on startup (only works if feature is enabled).]' \
'(--hide-status-bar --show-status-bar)--no-status-bar[Disable the status bar on startup.]' \
'(--no-status-bar --show-status-bar)--hide-status-bar[Hide the status bar on startup (only works if feature is enabled).]' \
'(--no-status-bar --hide-status-bar)--show-status-bar[Show the status bar on startup (only works if feature is enabled).]' \
'--ansi[Whether tv should extract and parse ANSI style codes from the source command output.]' \
'--exact[Use substring matching instead of fuzzy matching.]' \
'--select-1[Automatically select and output the first entry if there is only one entry.]' \
'--take-1[Take the first entry from the list after the channel has finished loading.]' \
'--take-1-fast[Take the first entry from the list as soon as it becomes available.]' \
'(--hide-remote --show-remote)--no-remote[Disable the remote control.]' \
'(--no-remote --show-remote)--hide-remote[Hide the remote control on startup (only works if feature is enabled).]' \
'(--no-remote --hide-remote)--show-remote[Show the remote control on startup (only works if feature is enabled).]' \
'(--hide-help-panel --show-help-panel)--no-help-panel[Disable the help panel entirely on startup.]' \
'(--no-help-panel --show-help-panel)--hide-help-panel[Hide the help panel on startup (only works if feature is enabled).]' \
'(--no-help-panel --hide-help-panel)--show-help-panel[Show the help panel on startup (only works if feature is enabled).]' \
'--global-history[Use global history instead of channel-specific history.]' \
'(--height)--inline[Use all available empty space at the bottom of the terminal as an inline interface.]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'-V[Print version]' \
'--version[Print version]' \
'::channel -- Which channel shall we watch?:_default' \
'::working_directory -- The working directory to start the application in.:_default' \
":: :_tv_commands" \
"*::: :->television" \
&& ret=0
    case $state in
    (television)
        words=($line[3] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:tv-command-$line[3]:"
        case $line[3] in
            (list-channels)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(init)
_arguments "${_arguments_options[@]}" : \
'-h[Print help]' \
'--help[Print help]' \
':shell -- The shell for which to generate the autocompletion script:(bash zsh fish power-shell cmd nu)' \
&& ret=0
;;
(update-channels)
_arguments "${_arguments_options[@]}" : \
'--force[Force update on already existing channels]' \
'-h[Print help]' \
'--help[Print help]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
":: :_tv__help_commands" \
"*::: :->help" \
&& ret=0

    case $state in
    (help)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:tv-help-command-$line[1]:"
        case $line[1] in
            (list-channels)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(init)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(update-channels)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" : \
&& ret=0
;;
        esac
    ;;
esac
;;
        esac
    ;;
esac
}

(( $+functions[_tv_commands] )) ||
_tv_commands() {
    local commands; commands=(
'list-channels:Lists the available channels' \
'init:Initializes shell completion ("tv init zsh")' \
'update-channels:Downloads the latest collection of default channel prototypes from github and saves them to the local configuration directory' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'tv commands' commands "$@"
}
(( $+functions[_tv__help_commands] )) ||
_tv__help_commands() {
    local commands; commands=(
'list-channels:Lists the available channels' \
'init:Initializes shell completion ("tv init zsh")' \
'update-channels:Downloads the latest collection of default channel prototypes from github and saves them to the local configuration directory' \
'help:Print this message or the help of the given subcommand(s)' \
    )
    _describe -t commands 'tv help commands' commands "$@"
}
(( $+functions[_tv__help__help_commands] )) ||
_tv__help__help_commands() {
    local commands; commands=()
    _describe -t commands 'tv help help commands' commands "$@"
}
(( $+functions[_tv__help__init_commands] )) ||
_tv__help__init_commands() {
    local commands; commands=()
    _describe -t commands 'tv help init commands' commands "$@"
}
(( $+functions[_tv__help__list-channels_commands] )) ||
_tv__help__list-channels_commands() {
    local commands; commands=()
    _describe -t commands 'tv help list-channels commands' commands "$@"
}
(( $+functions[_tv__help__update-channels_commands] )) ||
_tv__help__update-channels_commands() {
    local commands; commands=()
    _describe -t commands 'tv help update-channels commands' commands "$@"
}
(( $+functions[_tv__init_commands] )) ||
_tv__init_commands() {
    local commands; commands=()
    _describe -t commands 'tv init commands' commands "$@"
}
(( $+functions[_tv__list-channels_commands] )) ||
_tv__list-channels_commands() {
    local commands; commands=()
    _describe -t commands 'tv list-channels commands' commands "$@"
}
(( $+functions[_tv__update-channels_commands] )) ||
_tv__update-channels_commands() {
    local commands; commands=()
    _describe -t commands 'tv update-channels commands' commands "$@"
}

if [ "$funcstack[1]" = "_tv" ]; then
    _tv "$@"
else
    compdef _tv tv
fi
# credits to the junegunn/fzf project
# https://github.com/junegunn/fzf/blob/d18c0bf6948b4707684fe77631aff26a17cbc4fa/shell/completion.zsh

_disable_bracketed_paste() {
    # Check if bracketed paste is defined, for compatibility with older versions
    if [[ -n $zle_bracketed_paste ]]; then
        print -nr ${zle_bracketed_paste[2]} >/dev/tty
    fi
}

_enable_bracketed_paste() {
    # Check if bracketed paste is defined, for compatibility with older versions
    if [[ -n $zle_bracketed_paste ]]; then
        print -nr ${zle_bracketed_paste[1]} >/dev/tty
    fi
}

__tv_path_completion() {
  local base lbuf suffix tail dir leftover matches
  base=$1
  lbuf=$2
  suffix=""
  tail=" "

  eval "base=$base" 2> /dev/null || return
  [[ $base = *"/"* ]] && dir="$base"
  while [ 1 ]; do
    if [[ -z "$dir" || -d ${dir} ]]; then
      leftover=${base/#"$dir"}
      leftover=${leftover/#\/}
      [ -z "$dir" ] && dir='.'
      [ "$dir" != "/" ] && dir="${dir/%\//}"
      zle -I
      matches=$(
        shift
        tv "$dir" --autocomplete-prompt "$lbuf" --inline --input "$leftover" < /dev/tty | while read -r item; do
          item="${item%$suffix}$suffix"
          dirP="$dir/"
          [[ $dirP = "./" ]] && dirP=""
          echo -n -E "$dirP${(q)item} "
        done
      )
      matches=${matches% }
      if [ -n "$matches" ]; then
        LBUFFER="$lbuf$matches$tail"
      fi
      zle reset-prompt
      break
    fi
    dir=$(dirname "$dir")
    dir=${dir%/}/
  done
}

_tv_smart_autocomplete() {
  _disable_bracketed_paste

  local tokens prefix trigger lbuf
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins

  # http://zsh.sourceforge.net/FAQ/zshfaq03.html
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
  tokens=(${(z)LBUFFER})
  if [ ${#tokens} -lt 1 ]; then
    zle ${fzf_default_completion:-expand-or-complete}
    return
  fi

  [[ ${LBUFFER[-1]} == ' ' ]] && tokens+=("")

  if [[ ${LBUFFER} = *"${tokens[-2]-}${tokens[-1]}" ]]; then
    tokens[-2]="${tokens[-2]-}${tokens[-1]}"
    tokens=(${tokens[0,-2]})
  fi

  lbuf=$LBUFFER
  prefix=${tokens[-1]}
  [ -n "${tokens[-1]}" ] && lbuf=${lbuf:0:-${#tokens[-1]}}

  __tv_path_completion "$prefix" "$lbuf"

  _enable_bracketed_paste
}

_tv_shell_history() {
    emulate -L zsh
    zle -I

    _disable_bracketed_paste

    local current_prompt
    current_prompt=$LBUFFER

    local output

    output=$(history -n -1 0 | tv --input "$current_prompt" --inline $*)

    zle reset-prompt
    if [[ -n $output ]]; then
        RBUFFER=""
        LBUFFER=$output

        # uncomment this to automatically accept the line
        # (i.e. run the command without having to press enter twice)
        # zle accept-line
    fi

    _enable_bracketed_paste
}

_tv_git_history() {
    emulate -L zsh
    zle -I

    current_prompt=$LBUFFER
    _disable_bracketed_paste

    local output
    output=$(tv --inline git-log)

    if [[ -n $output ]]; then
        LBUFFER="$current_prompt$output"
    fi

    _enable_bracketed_paste
}


zle -N tv-smart-autocomplete _tv_smart_autocomplete
zle -N tv-shell-history _tv_shell_history
zle -N tv-git-history _tv_git_history


bindkey '^B^B' tv-smart-autocomplete
bindkey '^G^G' tv-git-history
# bindkey '^R' tv-shell-history

