let
  studioKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8n0CileVU4jKA43cCTD/zHeg2Ozp+JX0qW80P/7iau aiden@ai-studio";
  user = [
    studioKey
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM4ODzK94AfFpbIsx2I+s3TsrDX6LcQTDcxPfX037k6DUANnNNcUtP1Gl7l9WTm9P59l2iQL9R9hXIfGi6nmHOg= Personal@secretive.Aiden’s-MacBook-Pro.local"
  ];
  age = {
    studio = studioKey;
    workbook = "age1luaq2rfyylnp93950l4u0rsfd0kv4dh2xagr47kuc7jr3640z96q04f5ga";
  };
  hosts = {
    baymax = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvV4lf5yReZHdlE2qVnc7gVrigfx2ged272S5kBy+D3";
  };
  ageCompatibleKeys = builtins.filter (key: builtins.match "^ssh-ed25519.*" key != null) user;
in
{
  aispace = {
    inherit user hosts age;
    ageHostKeys = host: ageCompatibleKeys ++ [ hosts.${host} ];
  };
}
