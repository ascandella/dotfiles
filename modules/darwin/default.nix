{
  username,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    (import ./system.nix { inherit username lib pkgs; })
    ./yabai.nix
  ];

  config = {
    system.stateVersion = 5;
  };
}
