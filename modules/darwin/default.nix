{ ... }:

{
  imports = [
    ./system.nix
    ./homebrew.nix
    ./yabai.nix
  ];

  config = {
    system.stateVersion = 5;
  };
}
