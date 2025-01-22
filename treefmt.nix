# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # Nix
  programs.nixfmt.enable = true;
  # Lua
  programs.stylua.enable = true;
  # Markdomwn
  programs.mdformat.enable = true;

  settings.on-unmatched = "debug";
}
