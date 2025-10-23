{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.xfaf.shell.fish.enable = lib.mkEnableOption "install 0x5a4s fish config";

  config = lib.mkIf config.xfaf.shell.fish.enable {
    programs.fzf.enable = true;

    stylix.targets.fish.enable = false;

    home.packages =
      with pkgs.fishPlugins;
      [
        autopair
        colored-man-pages
        puffer
        sponge
        foreign-env
        grc
      ]
      ++ [
        pkgs.grc
      ];

    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        # grc ulimit is broken
        set -U grc_plugin_ignore_execs ulimit

        set sponge_purge_only_on_exit true
        set sponge_allow_previously_successful true

        # dont greet me
        set fish_greeting
      '';

      functions = {
        ccd = {
          description = "cd into a directory and create it";
          wraps = "cd";
          body = builtins.readFile ./functions/ccd.fish;
        };

        cdg = {
          description = "change working directory to the git root";
          body = builtins.readFile ./functions/cdg.fish;
        };

        disowned = {
          description = "Start a job and immediatly disown it";
          wraps = "exec";
          body = builtins.readFile ./functions/disowned.fish;
        };

        pastebinget = {
          description = "download a pastebin";
          body = builtins.readFile ./functions/pastebinget.fish;
        };

        wcat = {
          description = "cat an executable";
          wraps = "command -v";
          body = builtins.readFile ./functions/wcat.fish;
        };

        distort = {
          description = "alternates capitalization for the given string";
          body = builtins.readFile ./functions/distort.fish;
        };
      };
    };
  };
}
