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

      matchBlocks = {
        teefax.hostname = "teefax.hhu-fscs.de";
        verleihnix.hostname = "verleihnix.hhu-fscs.de";
        sebigbos.hostname = "sebigbos.hhu-fscs.de";

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
