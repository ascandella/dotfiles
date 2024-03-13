{ ... }:
{
  nix = {
    # Enable features in Nix commands
    settings.experimental-features = "nix-command flakes";
    extraOptions = ''
      warn-dirty = false
    '';
  };
}
