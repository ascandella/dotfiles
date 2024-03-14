{ ... }:
{
  programs.zsh.initExtra = ''
    is_in_git_repo() {
      git rev-parse HEAD > /dev/null 2>&1
    }

    fzf-down() {
      fzf --height 50% "$@" --border
    }

    _gf() {
      is_in_git_repo || return
      git -c color.status=always status --short |
      fzf-down -m --ansi --nth 2..,.. \
        --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
      cut -c4- | sed 's/.* -> //'
    }

    _gb() {
      is_in_git_repo || return
      git branch --color=always | grep -v '/HEAD\s' | sort |
      fzf-down --ansi --multi --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
      sed 's/^..//' | cut -d' ' -f1 |
      sed 's#^remotes/##'
    }

    gsw() {
      \git checkout $(_gb)
    }

    db() {
      \git branch -D $(_gb)
    }

    _gh() {
      is_in_git_repo || return
      git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
      fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
        --header 'Press CTRL-S to toggle sort' \
        --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
      grep -o "[a-f0-9]\{7,\}"
    }

    _gr() {
      is_in_git_repo || return
      git remote -v | awk '{print $1 "\t" $2}' | uniq |
      fzf-down --tac \
        --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
      cut -d$'\t' -f1
    }

    __join-lines() {
      local item
      while read item; do
        echo -n "''${(q)item} "
      done
    }

    bind-git-helper() {
      local c
      for c in $@; do
        eval "fzf-g$c-widget() { local result=\$(_g$c | __join-lines); zle reset-prompt; LBUFFER+=\$result }"
        eval "zle -N fzf-g$c-widget"
        eval "bindkey '^g^$c' fzf-g$c-widget"
      done
    }

    # Unbind "^g"
    bindkey -r "^g"
    bind-git-helper f b r h
    unset -f bind-git-helper
  '';
}