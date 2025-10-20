{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.xfaf.ssh.enable = lib.mkEnableOption "install 0x5a4s ssh config";

  config = lib.mkIf config.xfaf.ssh.enable {
    programs.ssh = {
      enable = true;

      package = pkgs.openssh;
      enableDefaultConfig = false;

      matchBlocks =
        let
        in
        {
          teefax = "teefax.hhu-fscs.de";
          verleihnix = "verleihnix.hhu-fscs.de";
          sebigbos = "sebigbos.hhu-fscs.de";

          vps = {
            hostname = "0x5a4.de";
            forwardAgent = true;
          };

          "*" = {
            addKeysToAgent = "yes";
          };
        };
    };
  };
}
