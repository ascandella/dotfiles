let
  studioKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8n0CileVU4jKA43cCTD/zHeg2Ozp+JX0qW80P/7iau aiden@ai-studio";
  workbookKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJv4kmti8JLFIEWbvazw8bTPx0iCVwe5YbHi6UXgujuz ascandella@sofi";
  ipadTermius = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKK7uWUFIxf1luIpp+RP3AmwOTbbW+1IvE+016cY3UcA4hNpUC7rjBjB7KAUNIJHrErcTBvFq9xG/c9s4hMbbnM= aiden@termius";
  user = [
    studioKey
    workbookKey
    ipadTermius
  ];
  age = {
    studio = studioKey;
    workbook = workbookKey;
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
    gpgPublicKey = builtins.readFile ./gpg-pubkey.asc;
  };
}
