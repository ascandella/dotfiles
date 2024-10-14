let
  pubkeys = import ../data/pubkeys.nix;
  baymaxKeys = pubkeys.aispace.ageHostKeys "baymax";
in
{
  "baymax-vpn.age".publicKeys = baymaxKeys;
  "truenas-nixos.age".publicKeys = baymaxKeys;
  "sponsorblocktv.age".publicKeys = baymaxKeys;
  "nextcloud-db-pass.age".publicKeys = baymaxKeys;
  "gitea-db-pass.age".publicKeys = baymaxKeys;
  "baymax-borg.age".publicKeys = baymaxKeys;
  "baymax-ntfy-token.age".publicKeys = baymaxKeys;
  "mosquitto-homeassistant.age".publicKeys = baymaxKeys;
  "mosquitto-frigate.age".publicKeys = baymaxKeys;
  "nutuser.age".publicKeys = baymaxKeys;
}
