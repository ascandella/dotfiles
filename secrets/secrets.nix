let pubkeys = import ../data/pubkeys.nix;
in { "baymax-vpn.age".publicKeys = pubkeys.aispace.ageHostKeys "baymax"; }

