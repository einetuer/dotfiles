{
  pkgs,
  lib,
  outputs,
  ...
}:
{
  imports = [
    outputs.homeModules.xfaf

    ../share/common-home.nix
    ./mute-eduroam.nix
    ./distrobox.nix
  ];

  xfaf.desktop.river.enable = true;
  xfaf.desktop.hyprpaper.enable = true;

  xfaf.desktop.batsignal.enable = true;

  xfaf.desktop.apps = {
    rofi.enable = true;
    tofi = {
      enable = true;
      makeDefault = true;
    };
  };

  xfaf.desktop.monitors =
    let
      externalConfig = {
        workspaces = [ 0 ];
        defaultWorkspace = 0;
        bar = {
          enable = true;
          modules.left = {
            clock = true;
            river-tags = true;
            network = true;
            bluetooth = true;
          };
          modules.right = {
            battery = true;
            river-mode = true;
            volume = true;
          };
        };
      };
    in
    {
      eDP-1 = {
        scale = 1.175;
        workspaces = lib.range 1 9;
        defaultWorkspace = 1;
        bar = {
          enable = true;
          modules.left = {
            clock = true;
            river-tags = true;
            system-load = true;
            network = true;
            bluetooth = true;
          };
          modules.right = {
            uptime = true;
            battery = true;
            volume = true;
            brightness = true;
            idle-inhibit = true;
            river-mode = true;
            tray = true;
          };
        };
      };
      DP-1 = externalConfig;
      DP-2 = externalConfig;
      DP-3 = externalConfig;
      DP-4 = externalConfig;
    };

  home.packages = with pkgs; [
    chromium
    element-desktop
    jetbrains.idea-ultimate
    libreoffice
    prismlauncher
    pwvucontrol
    spotify
    thunderbird
    yubikey-manager
  ];

  home.stateVersion = "23.11";
}
