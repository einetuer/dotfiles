{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  disko.devices = {
    disk = {
      main = lib.xfaf.disko.mkGPT "/dev/sdb" {
        ESP = lib.xfaf.disko.mkBootPartition "2G";
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes =
              let
                mountOptions = [ "noatime" ];
              in
              {
                "/root" = {
                  mountpoint = "/";
                  inherit mountOptions;
                };
                "/nix" = {
                  mountpoint = "/nix";
                  inherit mountOptions;
                };
                "/swap" = {
                  mountpoint = "/.swap";
                  swap.swapfile.size = "16G";
                };
              };
          };
        };
      };
      games = lib.xfaf.disko.mkGPT "/dev/sdd" {
        games = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            mountpoint = "/mnt/games";
            mountOptions = [ "noatime" ];
          };
        };
      };
    };
  };

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
