{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./power.nix
    ./window.nix
    ./notify.nix
    ./binds.nix
    ./rules.nix
  ];

  options.xfaf.desktop.hyprland = {
    enable = lib.mkEnableOption "install 0x5a4s hyprland config";
    cursor_warps = lib.mkEnableOption "enable cursor warps";
  };

  config = lib.mkIf config.xfaf.desktop.hyprland.enable {
    home.packages = with pkgs; [
      wl-clipboard
      xdg-desktop-portal-hyprland
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor =
          config.xfaf.desktop.monitors
          |> lib.foldlAttrs (
            acc: name: value:
            (
              let
                refreshRate = lib.optionalString (value.refreshRate != null) "@${value.refreshRate}";

                resolution =
                  if value.resolution != null then "${value.resolution}${refreshRate}" else "preferred${refreshRate}";

                position = if value.position != null then value.position else "auto";

                rotationMapped =
                  let
                    map = {
                      "0" = "0";
                      "90" = "1";
                      "180" = "2";
                      "270" = "3";
                    };
                  in
                  assert lib.assertMsg (
                    map ? "${builtins.toString value.rotate}"
                  ) "hyprland only accepts rotations in 90 degree steps";
                  map.${builtins.toString value.rotate};

                rotation = ",transform,${rotationMapped}";
              in
              acc ++ [ "${name},${resolution},${position},${toString value.scale}${rotation}" ]
            )
          ) [ ",preferred,auto,1" ];

        workspace =
          config.xfaf.desktop.monitors
          |> lib.foldlAttrs (
            acc: name: value:
            acc
            ++ (lib.map (
              w:
              "${toString w}, monitor:${name}${lib.optionalString (value ? "defaultWorkspace") ",default:true"}"
            ) value.workspaces)
          ) [ ];

        bezier = [
          "myBezier, 0.05, 0.9, 0.1, 1.05"
        ];

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        general = {
          layout = "dwindle";
          border_size = 1;
          gaps_in = 2;
          gaps_out = 5;
        };

        cursor = {
          no_warps = !config.xfaf.desktop.hyprland.cursor_warps;
          inactive_timeout = 0;
        };

        misc = {
          mouse_move_focuses_monitor = false;
          key_press_enables_dpms = true;
          disable_hyprland_logo = true;
          new_window_takes_over_fullscreen = 1;
        };

        input = {
          kb_layout = "de";
          kb_variant = "nodeadkeys";
          kb_options = "caps:escape";

          follow_mouse = 2;
          sensitivity = 0;
          numlock_by_default = true;

          touchpad = {
            natural_scroll = false;
            drag_lock = true;
          };
        };

        decoration = {
          rounding = 5;

          inactive_opacity = 0.95;

          blur.size = 3;
        };

        animations = {
          enabled = true;
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
            "specialWorkspace, 1, 6, default, slidevert"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
          smart_resizing = false;
        };

        gesture = [
          "3, horizontal, workspace"
        ];

        gestures.workspace_swipe_forever = true;
      };
    };
  };
}
