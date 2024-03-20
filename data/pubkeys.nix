let
  aispace =
    let
      user = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG8n0CileVU4jKA43cCTD/zHeg2Ozp+JX0qW80P/7iau aiden@ai-studio"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM4ODzK94AfFpbIsx2I+s3TsrDX6LcQTDcxPfX037k6DUANnNNcUtP1Gl7l9WTm9P59l2iQL9R9hXIfGi6nmHOg= Personal@secretive.Aiden’s-MacBook-Pro.local"
      ];
    in
    {
      inherit user;
    };
in
{
  inherit aispace;
}
