let
  pubkeys = import ../data/pubkeys.nix;
  keysByHost = {
    baymax = [
      "baymax-borg.age"
      "baymax-ntfy-token.age"
      "baymax-vpn.age"
      "frigate-secrets.age"
      "gitea-db-pass.age"
      "gitea-fastmail-app-password.age"
      "mosquitto-frigate.age"
      "mosquitto-homeassistant.age"
      "nextcloud-db-pass.age"
      "nutuser.age"
      "sponsorblocktv.age"
      "truenas-nixos.age"
      "zwavejs-env.age"
    ];
  };
in
builtins.listToAttrs (
  builtins.concatLists (
    builtins.attrValues (
      builtins.mapAttrs (
        host: keys:
        map (key: {
          name = key;
          value = {
            publicKeys = pubkeys.aispace.ageHostKeys host;
          };
        }) keys
      ) keysByHost
    )
  )
)
