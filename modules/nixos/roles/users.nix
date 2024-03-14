{ pkgs, ...}:

{
  users.groups.aiden = {
    gid = 1000;
    name = "aiden";
  };

  users.groups.media = {
    gid = 2000;
    name = "media";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aiden = {
    uid = 1000;
    isNormalUser = true;
    description = "Aiden";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "media" ];
    # TODO: put these somewhere central
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8n0CileVU4jKA43cCTD/zHeg2Ozp+JX0qW80P/7iau aiden@ai-studio"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM4ODzK94AfFpbIsx2I+s3TsrDX6LcQTDcxPfX037k6DUANnNNcUtP1Gl7l9WTm9P59l2iQL9R9hXIfGi6nmHOg= Personal@secretive.Aiden’s-MacBook-Pro.local"
    ];
  };
}
