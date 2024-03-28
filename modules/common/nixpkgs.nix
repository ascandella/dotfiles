{ pkgs, ... }:

{
  nix = {
    package = pkgs.nix;
    # Enable features in Nix commands
    settings.experimental-features = "nix-command flakes";
    extraOptions = ''
      warn-dirty = false
    '';
  };

  nixpkgs.overlays = [
    (final: prev: import ../../pkgs { inherit pkgs; })
  ];
}
