{ ... }:
{
  imports = [
    ./bash.nix
    ./nixpkgs.nix
  ];

  programs.zsh.enable = true;
}
