let
  pubkeys = import ../data/pubkeys.nix;
  baymaxKeys = pubkeys.aispace.ageHostKeys "baymax";
in
{
  "baymax-vpn.age".publicKeys = baymaxKeys;
  "sponsorblocktv.age".publicKeys = baymaxKeys;
  "nextcloud-db-pass.age".publicKeys = baymaxKeys;
  "gitea-db-pass.age".publicKeys = baymaxKeys;
  "baymax-borg.age".publicKeys = baymaxKeys;
}
