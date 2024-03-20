_:

{
  programs.zsh.initExtra = ''
    # bind UP and DOWN arrow keys
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down

    # Edit command
    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^Be" edit-command-line
    bindkey "^B^E" edit-command-line
  '';
}
