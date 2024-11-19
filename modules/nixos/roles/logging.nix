{ ... }:

{
  services = {
    vector = {
      enable = true;
      journaldAccess = true;
      settings = {
        sources = {
          journald = {
            type = "journald";
          };
        };
      };
    };
  };
}
