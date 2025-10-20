{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./locale.nix
  ];

  xfaf.bootconfig.enable = true;
  xfaf.nixconfig = {
    enable = true;
  };

  xfaf.sudo.enable = true;

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

  programs.fish.enable = true;
  users = {
    defaultUserShell = pkgs.fish;
    mutableUsers = false;
  };

  security.pam.services.swaylock = { };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = true;
  };

  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    echo UPDATESTARTUPTTY | gpg-connect-agent &> /dev/null
  '';

  environment.variables = {
    NIXOS_OZONE_WL = 1;
  };

  networking.nameservers = lib.mkAfter [
    "9.9.9.9"
  ];
}
