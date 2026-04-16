# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    # Nix
    nixfmt = {
      enable = true;
      # treefmt-nix defaults programs.nixfmt.package to
      # `pkgs.nixfmt-rfc-style`, which is an alias that emits a deprecation
      # warning on every eval. Point at `pkgs.nixfmt` directly.
      package = pkgs.nixfmt;
    };
    deadnix.enable = true;
    # Lua
    stylua.enable = true;
    # Markdomwn
    mdformat.enable = true;
  };

  settings.on-unmatched = "debug";
}
