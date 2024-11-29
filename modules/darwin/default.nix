{ ... }:

{
  imports = [
    ./system.nix
    ./yabai.nix
  ];

  config = {
    system.stateVersion = 5;
  };
}
