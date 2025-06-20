{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.services.aispace.buildkite;
in
with lib;
{
  options.services.aispace.buildkite = {
    enable = mkEnableOption "Enable Buildkite agent";
    token = mkOption {
      type = types.str;
      default = "";
      description = "Buildkite agent token";
    };
  };

  config = mkIf cfg.enable {
    age.secrets = {
      buildkite-agent-token = {
        file = ../../../secrets/buildkite-agent-token.age;
        owner = "buildkite-agent-ai-cloud";
      };
      buildkite-agent-token-ff = {
        file = ../../../secrets/buildkite-agent-token.age;
        owner = "buildkite-agent-ff";
      };
      buildkite-ai-cloud-ssh-key = {
        file = ../../../secrets/buildkite-ai-cloud-ssh-key.age;
        owner = "buildkite-agent-ai-cloud";
      };
    };

    services.buildkite-agents =
      let
        runtimePackages = with pkgs; [
          bash
          gnutar
          gzip
          git
          nix
          docker
        ];
        extraConfig = name: ''
          plugins-path="/var/lib/buildkite-agent-${name}/plugins"
        '';
      in
      {
        ai-cloud = {
          tokenPath = config.age.secrets.buildkite-agent-token.path;
          privateSshKeyPath = config.age.secrets.buildkite-ai-cloud-ssh-key.path;
          tags = {
            "docker" = "true";
            "queue" = "ai-cloud";
          };
          extraConfig = extraConfig "ai-cloud";
          inherit runtimePackages;
        };

        ff = {
          tokenPath = config.age.secrets.buildkite-agent-token-ff.path;
          privateSshKeyPath = config.age.secrets.buildkite-ai-cloud-ssh-key.path;
          tags = {
            "docker" = "true";
            "queue" = "ai-cloud";
          };
          extraConfig = extraConfig "ff";
          inherit runtimePackages;
        };
      };
  };
}
