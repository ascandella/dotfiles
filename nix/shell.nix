{ pkgs, ... }:

{
  home.packages = with pkgs; [
    zsh-autopair
  ];

  programs.zsh = {
    enable = true;
    
    autocd = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    defaultKeymap = "emacs";

    history = {
      size = 100000;
      path = "$HOME/.history";
      ignoreAllDups = true;
      share = true;
    };

    shellAliases = {
      j = "z";
      g = "git";
      gst = "git status -sb";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gca = "git commit --amend";
      gcn = "git commit --no-edit --no-verify --amend";
      vi = "nvim";
      vim = "nvim";
      k = "kubectl";
      kc = "kubectl config use-context";
    };

    initExtra = ''
      # Allow c-w to backwards word but stop at e.g. path separators
      WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
      # Postfix alias, syntax not supported in nix?
      alias -g G=' | grep '
      # Allow git commit -m and auto-quote arguments
      gcm () {
        git commit -m "$*"
      }

      # https://github.com/zsh-users/zsh-syntax-highlighting/issues/171
      # Cursor disappearing on move in linux
      export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
      fzf_default_opts+=(
        "--layout=reverse"
        "--info=inline"
        "--height=40%"
        "--multi"
        "--preview='$FZF_PREVIEW'"
        "--preview-window='$FZF_PREVIEW_WINDOW'"
        "--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284"
        "--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf"
        "--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
        "--prompt='∼ '"
        "--pointer='▶'"
        "--marker='✓'"
        "--border='rounded' --border-label=''' --preview-window='border-rounded'"
        "--bind '?:toggle-preview'"
        "--bind 'ctrl-a:select-all'"
        "--bind 'ctrl-e:execute(nvim {+} >/dev/tty)'"
      )
      _command_exists() {
        command -v "''${1}" >/dev/null
      }
      if _command_exists pbcopy; then
        # On macOS, make ^Y yank the selection to the system clipboard. On Linux you can alias pbcopy to `xclip -selection clipboard` or corresponding tool.
        fzf_default_opts+=("--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'")
      fi
      export FZF_DEFAULT_OPTS=$(printf '%s\n' "''${fzf_default_opts[@]}")

      if command -v rg > /dev/null ; then
        FZF_DEFAULT_COMMAND='rg --files --hidden --follow'
        for ignore in "*.pyc" "idl/*" "go-build/*" "vendor/*" ; do
          FZF_DEFAULT_COMMAND+=" --glob \"!''${ignore}\""
        done

        export FZF_DEFAULT_COMMAND
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      elif command -v ag > /dev/null ; then
        export FZF_DEFAULT_COMMAND='ag -g ""'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      fi

      # https://github.com/larkery/zsh-histdb?tab=readme-ov-file#integration-with-zsh-autosuggestions
      _zsh_autosuggest_strategy_histdb_top() {
          local query="
              select commands.argv from history
              left join commands on history.command_id = commands.rowid
              left join places on history.place_id = places.rowid
              where commands.argv LIKE '$(sql_escape $1)%'
              group by commands.argv, places.dir
              order by places.dir != '$(sql_escape $PWD)', count(*) desc
              limit 1
          "
          suggestion=$(_histdb_query "$query")
      }

      ZSH_AUTOSUGGEST_STRATEGY=histdb_top


      # Workaround for zsh-histdb on macos
      if [[ $(uname) == "Darwin" ]] ; then
        export HISTDB_TABULATE_CMD=(sed -e $'s/\x1f/\t/g')
      fi
    '';

    envExtra = ''
      [[ -f $HOME/.zshrc.local ]] && . "$HOME/.zshrc.local"
    '';

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-completions"; }
        { name = "zsh-users/zsh-history-substring-search"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "Tarrasch/zsh-autoenv"; }
        # { name = "Tarrasch/zsh-command-not-found"; }
        # {
        #   name = "zimfw/git-info";
        #   tags = [ "lazy:true" ];
        # }
        # {
        #   name = "zimfw/eriner";
        #   tags = [ "as:theme" ];
        # }
        # { name = "mafredri/zsh-async"; } # for pure
        # {
        #   name = "sindresorhus/pure";
        #   tags = [
        #     "as:theme"
        #     "use:pure.zsh"
        #   ];
        # }
        { name = "zimfw/input"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "larkery/zsh-histdb"; }
        { name = "hlissner/zsh-autopair"; }
      ];
    };
  };

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      package.disabled = true;
      aws.disabled = true;
      docker_context.disabled = true;
      nodejs.disabled = true;
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };
  
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
