{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../share/common.nix
    ../share/wifi.nix

    inputs.hardware.nixosModules.framework-13th-gen-intel
    outputs.nixosModules.xfaf
  ];

  boot.plymouth.enable = true;

  stylix.image = pkgs.fetchurl {
    url = "https://img.itch.zone/aW1hZ2UvOTY3MDg0LzU1MjAyMTIucG5n/794x1000/K13gwE.png";
    sha256 = "sha256-psw6lxfxAcRSNZ/7Y3EQvpukL8HYpr0H96Wld3qL+wU=";
  };

  xfaf.nixconfig.allowUnfree = true;

  sops.secrets = {
    fword-root = {
      sopsFile = ../../sops/secrets/users.yaml;
      neededForUsers = true;
    };
    fword-arthur = {
      sopsFile = ../../sops/secrets/users.yaml;
      neededForUsers = true;
    };
  };

  users.users.root.hashedPasswordFile = config.sops.secrets.fword-root.path;

  xfaf.users.arthur = {
    opts = {
      shell = pkgs.fish;
      extraGroups = [
        "wheel"
        "video"
        "docker"
        "libvirtd"
        "ydotool"
        "dialout"
      ];
      hashedPasswordFile = config.sops.secrets.fword-arthur.path;
    };
    home-manager = {
      enable = true;
      config = ./arthur.nix;
    };
  };

  xfaf.services.tlp.enable = true;
  services.thermald.enable = true;

  xfaf.services.pipewire.enable = true;

  services.printing.enable = true;
  xfaf.services.avahi.enable = true;

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
  };

  xfaf.services.greetd = {
    enable = true;
    command = "river";
    defaultUser = "arthur";
    output = "eDP-1";
  };

  xfaf.services.ssh.enable = true;

  programs.steam.enable = true;

  services.pcscd.enable = true;

  services.udev.extraRules = ''
    ACTION=="remove",\
     ENV{ID_VENDOR_FROM_DATABASE}=="Yubico.com",\
     RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';

  programs.ydotool.enable = true;
  environment.variables = {
    YDOTOOL_SOCKET = "/run/ydotoold/socket";
  };

  programs.yubikey-touch-detector.enable = true;

  networking.hostName = "fword";
  
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    autoPrune.enable = true;
  };

  networking.dhcpcd.extraConfig = ''
    interface enp0s13f0u4u3u2 
    nogateway
    interface enp0s13f0u1u3u2
    nogateway
  '';

  system.stateVersion = "24.11";
}
