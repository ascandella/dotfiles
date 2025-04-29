{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    # TODO: make this configurable, not just on macs
    signing = lib.mkIf pkgs.stdenv.isDarwin {
      key = "C19FAEAAFD6CC39783DAEB6617C559C421D83A19";
      signByDefault = true;
    };
    userName = "Aiden Scandella";
    userEmail = config.my.gitEmail;
    aliases = {
      abbrev = "!sh -c 'git rev-parse --short '\${1-`echo HEAD`}' -";
      add-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";
      amend = "commit --amend";
      branchname = "rev-parse --abbrev-ref HEAD";
      cached = "diff --cached";
      edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f` +Gdiff";
      delmerged = ''!git branch --merged | grep -v "\\*" | grep -v '^master' | xargs -n 1 git branch -d'';
      delsquash = "!git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -n 1 git branch -D";
      main = "!git checkout $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') && git pull && git delsquash";
      graph = "log --oneline --graph";
      l = "log --decorate --stat";
      lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'";
      lol = "log --oneline --decorate";
      patch = "add -p";
      refresh = ''!ssh-add -l && STASH=$(git stash) && git fetch && OVERCOMMIT_DISABLE=1 git rebase origin/HEAD && test "$STASH" != "No local changes to save" && git stash pop || true'';
      rmb = "!sh -c 'git branch -D $1 && git push origin :$1' -";
      sha1 = "rev-parse HEAD";
      sha = "!git rev-parse HEAD | cut -c 1-8";
      showstash = "stash show -p stash@{0}";
      upstream = "!git push -u origin $(git rev-parse --abbrev-ref HEAD)";
      who = "shortlog -n -s --no-merges";
      files = "show --pretty=format: --name-only";
      p = "add -p";
      unstage = "reset HEAD";
      glg = "log --graph --pretty=lg";
    };
    extraConfig = {
      http = lib.mkIf config.my.caCert.enable {
        sslCAInfo = config.my.caCert.path;
      };
      delta = {
        # Necessary inside zellij
        dark = true;
        navigate = true;
        hyperlinks = false;
        features = "decorations";
        line-numbers-left-format = "";
        line-numbers-right-format = "│ ";
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#6935BF";
          hunk-header-style = "line-number syntax file";
          file-style = "bold";
        };
      };
      core = {
        pager = "${pkgs.delta}/bin/delta";
        excludesfile = "${config.xdg.configHome}/git/global-ignore";
      };
      diff = {
        noprefix = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      interactive = {
        singleKey = true;
        diffFilter = "delta --color-only --features=interactive";
      };
      help = {
        autocorrect = 10; # 1 second
      };
      merge = {
        conflictStyle = "zdiff3";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
        updateRefs = true;
      };
      log = {
        gdecorate = "short";
      };
      color = {
        gui = true;
        ui = true;
      };
      rebase = {
        autosquash = true;
        autostash = true;
      };
      column = {
        ui = "auto";
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        autoSetupRemote = true;
      };
      pull = {
        ff = "only";
        rebase = true;
      };
    };
  };

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

  xdg.configFile = {
    "git/global-ignore".text = ''
      .dir-locals.el
      .DS_Store
      /.idea
      .autoenv.zsh
      .venv/
      .ipynb_checkpoints
      __pycache__/
      .ignore
      .dmypy.json
      .mypy_cache
      .envrc
      .lsp-session-*
      .elixir_ls/
    '';
  };

  home.packages = [
    pkgs.git-lfs
    (pkgs.writeShellScriptBin "git-gsub" ''
      old="$1"
      new="$2"
      path=$3

      files=$(git grep -l "$old" $path)
      echo $files
      sed -i ''' -e "s|$old|$new|g" $files
    '')
  ];
}
