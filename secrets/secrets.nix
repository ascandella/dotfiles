let
  pubkeys = import ../data/pubkeys.nix;
  baymaxKeys = pubkeys.aispace.ageHostKeys "baymax";
in
{
  "baymax-borg.age".publicKeys = baymaxKeys;
  "baymax-ntfy-token.age".publicKeys = baymaxKeys;
  "baymax-vpn.age".publicKeys = baymaxKeys;
  "frigate-secrets.age".publicKeys = baymaxKeys;
  "gitea-db-pass.age".publicKeys = baymaxKeys;
  "mosquitto-frigate.age".publicKeys = baymaxKeys;
  "mosquitto-homeassistant.age".publicKeys = baymaxKeys;
  "nextcloud-db-pass.age".publicKeys = baymaxKeys;
  "nutuser.age".publicKeys = baymaxKeys;
  "sponsorblocktv.age".publicKeys = baymaxKeys;
  "truenas-nixos.age".publicKeys = baymaxKeys;
}
