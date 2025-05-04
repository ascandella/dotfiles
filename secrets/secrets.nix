let
  pubkeys = import ../data/pubkeys.nix;
  keysByHost = {
    baymax = [
      "baymax-borg"
      "baymax-ntfy-token"
      "baymax-vpn"
      "frigate-secrets"
      "gitea-db-pass"
      "gitea-fastmail-app-password"
      "mosquitto-frigate"
      "mosquitto-homeassistant"
      "mosquitto-opensprinkler"
      "nextcloud-db-pass"
      "nutuser"
      "sponsorblocktv"
      "truenas-nixos"
      "zwavejs-env"
    ];
  };
  buildSecret =
    host: keys:
    map (key: {
      name = "${key}.age";
      value = {
        publicKeys = pubkeys.aispace.ageHostKeys host;
      };
    }) keys;
in
builtins.listToAttrs (
  builtins.concatLists (builtins.attrValues (builtins.mapAttrs buildSecret keysByHost))
)
