# treefmt.nix
{ _ }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    # Nix
    nixfmt.enable = true;
    deadnix.enable = true;
    # Lua
    stylua.enable = true;
    # Markdomwn
    mdformat.enable = true;
  };

  settings.on-unmatched = "debug";
}
