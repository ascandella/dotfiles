{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    zsh-autopair
  ];

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
      enableCompletion = true;
      completionInit = "";
      dotDir = ".config/zsh";

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
          kb = "kubectl --context baymax";
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

      initExtra = ''
        setopt correct
        # Allow c-w to backwards word but stop at e.g. path separators
        WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
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
        export FPATH="${pkgs.eza}/completions/zsh:$FPATH"
        source "${pkgs.awscli2}/bin/aws_zsh_completer.sh"
        source "${config.xdg.configHome}/zsh/custom-init.zsh"
        source "${config.xdg.configHome}/zsh/plugins/zsh-autoenv/init.zsh"
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
