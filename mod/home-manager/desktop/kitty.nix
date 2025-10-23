{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.xfaf.desktop.apps.kitty = {
    enable = lib.mkEnableOption "install 0x5a4s kitty config";
    makeDefault = lib.mkEnableOption "make kitty the default terminal";
    openTmux = lib.mkEnableOption "open tmux by default if kitty is run";
  };

  config =
    let
      opts = config.xfaf.desktop.apps.kitty;

    in
    lib.mkIf opts.enable {
      xfaf.desktop.terminalCommand = lib.mkIf opts.makeDefault "kitty -1 ${lib.optionalString opts.openTmux "-e tmux"}";

      # disable stylix kitty support, because it breaks colors
      # i partially inline it
      stylix.targets.kitty.enable = false;

      programs.kitty = {
        enable = true;
        shellIntegration = {
          enableBashIntegration = true;
          enableFishIntegration = true;
        };

        keybindings = {
          "ctrl+plus" = "change_font_size all +1.0";
          "ctrl+minus" = "change_font_size all -1.0";
          "alt+shift+t" = "new_os_window_with_cwd";
        };

        font = {
          inherit (config.stylix.fonts.monospace) package name;
          size = config.stylix.fonts.sizes.terminal;
        };

        settings = {
          background = "#" + config.lib.stylix.colors.base00;
          background_opacity = "${builtins.toString config.stylix.opacity.terminal}";

          update_check_interval = 0;
          confirm_os_window_close = 0;
          mouse_hide_wait = 0;
          notify_on_cmd_finish = "invisible 30";
          touch_scroll_multiplier = 5;

          enable_audio_bell = "yes";
          visual_bell_duration = "0.5";

          disable_ligatures = "always";
          font_features = "MonocraftNerdFontComplete- -liga";
        };
      };
    };
}
