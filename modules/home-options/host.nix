{ hostname, ... }:
if (builtins.pathExists ./${hostname}.nix) then
  (import ./${hostname}.nix { inherit hostname; })
else
  { }

