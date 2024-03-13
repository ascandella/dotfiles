{ ... }:
{
  nix = {
    # Enable features in Nix commands
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
  };
}
