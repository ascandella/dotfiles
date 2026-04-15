{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Pre-generate static zsh init scripts as nix derivations.
  # At shell startup this becomes a plain `source /nix/store/…` with no
  # subprocess overhead. Each derivation is keyed by the package content-hash,
  # so it auto-regenerates whenever the package is upgraded.
  fzfZshInit = pkgs.runCommand "fzf-zsh-init.zsh" { } ''
    ${pkgs.fzf}/bin/fzf --zsh > $out
  '';
  direnvZshHook = pkgs.runCommand "direnv-zsh-hook.zsh" { } ''
    ${pkgs.direnv}/bin/direnv hook zsh > $out
  '';
  zoxideZshInit = pkgs.runCommand "zoxide-zsh-init.zsh" { } ''
    ${pkgs.zoxide}/bin/zoxide init zsh > $out
  '';
  starshipZshInit = pkgs.runCommand "starship-zsh-init.zsh" { } ''
    ${pkgs.starship}/bin/starship init zsh > $out
  '';

  # mise activation: full version for first shell, nested version that skips the
  # initial hook-env call (15ms) and PATH override for zellij child shells
  # (tool versions + PATH already inherited from the parent shell).
  miseZshInit = pkgs.runCommand "mise-zsh-init.zsh" { } ''
    ${pkgs.mise}/bin/mise activate zsh > $out
  '';
  miseZshInitNested = pkgs.runCommand "mise-zsh-init-nested.zsh" { } ''
    ${pkgs.mise}/bin/mise activate zsh \
      | sed '/^export PATH=/d; /^_mise_hook$/d' > $out
  '';

  # Sources for deferred plugins (loaded after first prompt via zsh-defer).
  zshSyntaxHighlightingSrc = pkgs.fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-syntax-highlighting";
    rev = "e0165eaa730dd0fa321a6a6de74f092fe87630b0";
    sha256 = "4rW2N+ankAH4sA6Sa5mr9IKsdAg7WTgrmyqJ2V1vygQ=";
  };
  zshAutopairSrc = pkgs.fetchFromGitHub {
    owner = "hlissner";
    repo = "zsh-autopair";
    rev = "2ec3fd3c9b950c01dbffbb2a4d191e1d34b8c58a";
    sha256 = "Y7fkpvCOC/lC2CHYui+6vOdNO8dNHGrVYTGGNf9qgdg=";
  };
in

{
  home.packages = [ ];

  home.sessionVariables = lib.mkIf config.my.caCert.enable {
    AWS_CA_BUNDLE = config.my.caCert.path;
    NODE_EXTRA_CA_CERTS = config.my.caCert.path;
    CURL_CA_BUNDLE = config.my.caCert.path;
    SSL_CERT_FILE = config.my.caCert.path;
    NIX_SSL_CERT_FILE = config.my.caCert.path;
    REQUESTS_CA_BUNDLE = config.my.caCert.bundle;
  };

  xdg.configFile = {
    "zsh/custom-init.zsh".source = ./files/zsh/custom-init.zsh;
    "zsh/venv-autoenv.zsh".source = ./files/zsh/venv-autoenv.zsh;
  };

  programs = {
    zsh = {
      enable = true;

      autocd = true;
      autosuggestion = {
        enable = true;
      };
      # uncomment to enable profiling if shell init gets slow
      # zprof.enable = true;
      enableCompletion = true;
      # Always skip compaudit (~180ms savings per shell). All completions come
      # from the immutable nix store so the security check is meaningless.
      # The dump is wiped by home.activation.zcompdump on every `just home` so
      # completions stay current after upgrades.
      completionInit = ''
        autoload -Uz compinit
        compinit -C
      '';
      dotDir = "${config.xdg.configHome}/zsh";

      defaultKeymap = "emacs";

      history = {
        size = 100000;
        path = "$HOME/.history";
        ignoreAllDups = true;
        share = true;
      };

      shellAliases = lib.mkMerge [
        {
          j = "z"; # jump
          ji = "zi"; # interactive jump
          cat = "bat";
          e = "eza --icons=auto"; # also aliased as 'l'
          elt = "e -lt modified"; # like `ls -ltr`
          "gimme-aws-creds" = "REQUESTS_CA_BUNDLE='' gimme-aws-creds";
          g = "git";
          gi = "git main";
          gp = "git patch";
          gst = "git status -sb";
          gco = "git checkout";
          gcp = "git cherry-pick";
          gca = "git commit --amend";
          gcn = "git commit --no-edit --no-verify --amend";
          vi = "nvim";
          vim = "nvim";
          k = "kubectl";
          ko = "kubectl --context oracle";
          kb = "kubectl kustomize --enable-helm --load-restrictor=LoadRestrictionsNone";
          kc = "kubectl config use-context";
          krp = "kubectl get pods --field-selector=status.phase=Running";
          kk = "kubectl kustomize --enable-helm";
          less = "most";
          # From https://github.com/zellij-org/zellij/blob/09689eae8b96ddb95713e6612ec17007ced91306/zellij-utils/assets/completions/comp.zsh
          ze = "zellij edit";
          zef = "zellij edit --floating";
          zei = " zellij edit --in-place";
        }
        (lib.mkIf pkgs.stdenv.isLinux {
          # Don't quote directories with spaces in them. This is the default on
          # Darwin, and the option is not available.
          ls = "ls --color=tty -N";
        })
      ];

      initContent = ''
        # zsh-defer: defers non-critical plugins until after first prompt
        source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh

        setopt correct
        # Allow c-w to backwards word but stop at e.g. path separators
        WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
        eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd)"
        source ${starshipZshInit}
        export FPATH="${pkgs.eza}/completions/zsh:$FPATH"
        # Lazy-load aws completion: only sources on first aws<TAB>
        _aws_lazy_completer() {
          unfunction _aws_lazy_completer
          source "${pkgs.awscli2}/bin/aws_zsh_completer.sh"
          _bash_complete aws
        }
        compdef _aws_lazy_completer aws
        source "${config.xdg.configHome}/zsh/custom-init.zsh"
        source "${config.xdg.configHome}/zsh/plugins/zsh-autoenv/init.zsh"
        source "${config.xdg.configHome}/zsh/television/shell/integration.zsh"
        # Static zsh integrations pre-built as nix derivations (no subprocess)
        source ${zoxideZshInit}
        if [[ $options[zle] = on ]]; then
          source ${fzfZshInit}
        fi
        source ${direnvZshHook}
        # mise: full activation in first shell; nested shells (zellij panes)
        # inherit PATH + tool versions from parent -- skip the expensive
        # initial hook-env call and PATH snapshot override.
        if [[ -z $MISE_SHELL ]]; then
          source ${miseZshInit}
        else
          source ${miseZshInitNested}
        fi
        # Defer cosmetic plugins until after first prompt (~30ms saving).
        # zsh-syntax-highlighting must load last anyway (its own docs say so).
        zsh-defer source ${zshSyntaxHighlightingSrc}/zsh-syntax-highlighting.plugin.zsh
        zsh-defer source ${zshAutopairSrc}/zsh-autopair.plugin.zsh
      '';

      envExtra = ''
        [[ -f $HOME/.zshrc.local ]] && . "$HOME/.zshrc.local"
      '';

      plugins = [
        {
          name = "zsh-autoenv";
          src = pkgs.fetchFromGitHub {
            owner = "Tarrasch";
            repo = "zsh-autoenv";
            rev = "f5951dd0cfeb37eb18fd62e14edc902a2c308c1e";
            sha256 = "sha256-8HznSWSBj1baetvDOIZ+H9mWg5gbbzF52nIEG+u9Di8=";
          };
        }
        {
          name = "zsh-npm-scripts-autocomplete";
          src = pkgs.fetchFromGitHub {
            owner = "grigorii-zander";
            repo = "zsh-npm-scripts-autocomplete";
            rev = "5d145e13150acf5dbb01dac6e57e57c357a47a4b";
            sha256 = "sha256-Y34VXOU7b5z+R2SssCmbooVwrlmSxUxkObTV0YtsS50=";
          };
        }
        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "8dd05bfcc12b0cd1ee9ea64be725b3d9f713cf64";
            sha256 = "houujb1CrRTjhCc+dp3PRHALvres1YylgxXwjjK6VZA=";
          };
        }
        # zsh-syntax-highlighting is deferred via zsh-defer in initContent
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
        # zsh-autopair is deferred via zsh-defer in initContent
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "6aced3f35def61c5edf9d790e945e8bb4fe7b305";
            sha256 = "EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=";
          };
        }
      ];
    };
    direnv = {
      enable = true;
      enableZshIntegration = false; # handled manually via pre-built nix derivation
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = false; # handled manually via pre-built nix derivation
    };

    zoxide = {
      enable = true;
      enableZshIntegration = false; # handled via pre-built nix derivation in initContent
    };

    bat = {
      enable = true;
      config = {
        theme = "Coldark-Dark";
        style = "plain";
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = false; # sourced via pre-built nix derivation above
      settings = {
        format = lib.concatStrings [
          "$username"
          "$directory"
          "$hostname"
          "$git_branch"
          "$git_status"
          "$git_state"
          "$cmd_duration"
          "$line_break"
          "$jobs"
          "$sudo"
          "$character"
        ];
        add_newline = true;
        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
        };
        hostname = {
          ssh_only = true;
          format = "[@$hostname]($style) ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
        };
        cmd_duration = {
          min_time = 2000;
          format = "[$duration]($style) ";
        };
        status.disabled = true;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
          vimcmd_symbol = "[➜](bold yellow)";
        };
      };
    };
  };
}
