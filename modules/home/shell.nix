{ pkgs, ... }:

{
  home.packages = with pkgs; [ zsh-autopair ];

  programs = {
    zsh = {
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
        j = "z"; # jump
        ji = "zi"; # interactive jump
        cat = "bat";
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
        krp = "kubectl get pods --field-selector=status.phase=Running";
        less = "most";
      };

      initExtra = ''
        setopt correct
        # Allow c-w to backwards word but stop at e.g. path separators
        WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
        # Postfix alias, syntax not supported in nix?
        alias -g G=' | grep '
        # Allow git commit -m and auto-quote arguments
        gcm () {
          git commit -m "$*"
        }

        ag() {
          if [ -n "$1" ]; then
            local args=""
            if [[ -n "$2" && -z "$3" ]]; then
              args="-C $2"
            fi
            # https://github.com/dandavison/delta/issues/1588#issuecomment-e898999756
            rg --json "$1" ''${=args} | delta --tabs=1
          else
            rg
          fi
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

        [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

        eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd)"
        SPACESHIP_PROMPT_ORDER=(
          time
          user dir host git
          exec_time
          async
          line_sep
          jobs
          exit_code sudo char
        )
        source "${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh"
      '';

      envExtra = ''
        [[ -f $HOME/.zshrc.local ]] && . "$HOME/.zshrc.local"
      '';

      plugins = [
        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "8dd05bfcc12b0cd1ee9ea64be725b3d9f713cf64";
            sha256 = "houujb1CrRTjhCc+dp3PRHALvres1YylgxXwjjK6VZA=";
          };
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
            sha256 = "4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
          };
        }
        {
          name = "zsh-histdb";
          src = pkgs.fetchFromGitHub {
            owner = "larkery";
            repo = "zsh-histdb";
            rev = "30797f0c50c31c8d8de32386970c5d480e5ab35d";
            sha256 = "PQIFF8kz+baqmZWiSr+wc4EleZ/KD8Y+lxW2NT35/bg=";
          };
        }
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
          };
        }
        {
          name = "zsh-autopair";
          src = pkgs.fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "2ec3fd3c9b950c01dbffbb2a4d191e1d34b8c58a";
            sha256 = "Y7fkpvCOC/lC2CHYui+6vOdNO8dNHGrVYTGGNf9qgdg=";
          };
        }
      ];
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    bat = {
      enable = true;
      config = {
        theme = "Coldark-Dark";
        style = "plain";
      };
    };
  };
}
