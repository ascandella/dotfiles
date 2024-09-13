{ ... }:

{
  imports = [
    ./system.nix
    ./homebrew.nix
  ];

  config = {
    system.stateVersion = 5;
  };
}
