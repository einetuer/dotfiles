{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.betterfox.homeModules.betterfox
  ];

  options.xfaf.desktop.apps.firefox = {
    enable = lib.mkEnableOption "install 0x5a4s firefox config";
    makeDefault = lib.mkEnableOption "make firefox the default browser";
  };

  config =
    let
      opts = config.xfaf.desktop.apps.firefox;
    in
    lib.mkIf opts.enable {
      stylix.targets.firefox.enable = false;

      xfaf.desktop.browserCommand = lib.mkIf opts.makeDefault "firefox";

      home.sessionVariables.BROWSER = lib.mkIf opts.makeDefault "firefox";
        
      xdg.mimeApps = {
        enable = true;

        associations.added = {
          "x-scheme-handler/http" = "firefox.desktop;";
          "x-scheme-handler/https" = "firefox.desktop;";
          "x-scheme-handler/chrome" = "firefox.desktop;";
          "text/html" = "firefox.desktop;";
          "application/x-extension-htm" = "firefox.desktop;";
          "application/x-extension-html" = "firefox.desktop;";
          "application/x-extension-shtml" = "firefox.desktop;";
          "application/xhtml+xml" = "firefox.desktop;";
          "application/x-extension-xhtml" = "firefox.desktop;";
          "application/x-extension-xht" = "firefox.desktop;";
        };

        defaultApplications = lib.mkIf opts.makeDefault {
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/chrome" = "firefox.desktop";
          "text/html" = "firefox.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
        };
      };

      programs.firefox = {
        enable = true;

        betterfox = {
          enable = true;

          profiles.main.enableAllSections = true; 
        };

        policies = {
          "DisableFormHistory" = true;
          "DisableFirefoxAccounts" = true;
          "DontCheckDefaultBrowser" = true;
          "NetworkPrediction" = false;
          "CaptivePortal" = false;
          "DNSOverHTTPS" = {
            "Enabled" = false;
          };
          "DisableFirefoxStudies" = true;
          "DisableTelemetry" = true;
          "DisablePocket" = true;
          "OfferToSaveLogins" = false;
          "HttpsOnlyMode" = "enabled";
          "SanitizeOnShutdown" = {
            "History" = true;
            "Cookies" = true;
          };
          "Cookies" = {
            "Allow" = [
              "https://adventofcode.com"
              "https://astahhu.de"
              "https://disneyplus.com"
              "https://github.com"
              "https://hhu-fscs.de"
              "https://hhu.de"
              "https://inphima.de"
              "https://phynix-hhu.de"
              "https://tech.lgbt"
              "https://wienstroer.net"
              "https://youtube.com"
            ];
            "Behaviour" = "reject";
          };
          "Extensions" = {
            "Uninstall" = [
              "google@search.mozilla.org"
              "bing@search.mozilla.org"
              "amazondotcom@search.mozilla.org"
              "ebay@search.mozilla.org"
              "twitter@search.mozilla.org"
            ];
          };
        };

        profiles.main = {
          id = 0;

          bookmarks.force = true;
          bookmarks.settings =
            let
              defineNamed = name: url: {
                inherit name;
                url = "https://${url}";
              };
              define = url: defineNamed "" url;
              folder = name: bookmarks: { inherit name bookmarks; };
            in
            [
              {
                name = "toolbar";
                toolbar = true;
                bookmarks = [
                  (define "youtube.com")
                  (define "disneyplus.com/en-de")
                  (define "ardmediathek.de/tatort")
                  (define "wiki.gentoo.org")
                  (define "nixos.wiki")
                  (define "github.com")
                  (define "crates.io")
                  (define "tech.lgbt")
                  (folder "tools" [
                    (defineNamed "craiyon" "craiyon.com")
                    (defineNamed "hex to dec" "www.rapidtables.com/convert/number/hex-to-decimal.html")
                    (defineNamed "goodname" "kampersanda.github.io/goodname")
                    (defineNamed "plotz" "www.plotz.co.uk")
                    (defineNamed "toml validator" "www.toml-lint.com")
                    (defineNamed "click" "clickclickclick.click/#4a955f9cf0bbe3854fa9ede6935d540c")
                    (defineNamed "mems" "imgflip.com")
                    (defineNamed "noogle" "noogle.dev")
                    (defineNamed "nüschtos" "nüschtos.de")
                    (defineNamed "sign2mint" "sign2mint.de")
                  ])
                  (folder "uni" [
                    (defineNamed "ilias" "ilias.hhu.de/login.php?client_id=UniRZ&cmd=force_login&lang=de")
                    (defineNamed "lsf" "lsf.hhu.de")
                    (defineNamed "fscs" "fscs.hhu.de")
                    (defineNamed "phynix nextcloud" "nextcloud.phynix-hhu.de")
                    (defineNamed "mete" "metesecure.hhu-fscs.de")
                    (defineNamed "tickets" "tickets.astahhu.de/mailbox/4")
                    (defineNamed "propra2" "github.com/hhu-propra2-ws24/Organisation")
                    (defineNamed "sysprog" "coconucos.cs.uni-duesseldorf.de/lehre/home/lectures/bsusp/overview/")
                    (defineNamed "sciebo" "uni-duesseldorf.sciebo.de/")
                    (defineNamed "ordnungen" "hhu-ordnungen.github.io/ordnungen/")
                  ])
                  (folder "doc" [
                    (defineNamed "lua 5.4 reference" "www.lua.org/manual/5.4")
                    (defineNamed "zig langref" "ziglang.org/documentation/master")
                    (defineNamed "zig stdref" "ziglang.org/documentation/master/std")
                    (defineNamed "hyprland wiki" "wiki.hyprland.org")
                    (defineNamed "opencomputers" "ocdoc.cil.li")
                    (defineNamed "hugo" "gohugo.io/documentation")
                    (defineNamed "bootstrap" "getbootstrap.com/docs/")
                    (defineNamed "nixpkgs doc" "ryantm.github.io/nixpkgs/")
                    (defineNamed "nixvim" "nix-community.github.io/nixvim/")
                  ])
                ];
              }
            ];

          search = {
            default = "ddg";
            force = true;
            engines =
              let
                define = alias: url: iconURL: {
                  urls = [ { template = "https://${url}"; } ];
                  icon = "https://${iconURL}";
                  updateInterval = 24 * 60 * 60 * 1000;
                  definedAliases = [ "@${alias}" ];
                };

                nixosIcon = "nixos.wiki/favico.png";
              in
              {
                "Ard Mediathek" = define "ard" "ardmediathek.de/suche/{searchTerms}" "ardmediathek.de/favicon.ico";
                "Youtube" =
                  define "yt" "youtube.com/results?search_query={searchTerms}"
                    "www.youtube.com/favicon.ico";
                "Nix Packages" =
                  define "nixpkgs" "search.nixos.org/packages?channel=unstable&query={searchTerms}"
                    nixosIcon;
                "Nix Package Versions" =
                  define "nixhist" "lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package={searchTerms}"
                    nixosIcon;
                "Nix Options" =
                  define "nixopts" "search.nixos.org/options?channel=unstable&query={searchTerms}"
                    nixosIcon;
                "Noogle" = define "noogle" "noogle.dev/q?term={searchTerms}" nixosIcon;
                "Home Manager" =
                  define "homeopts" "home-manager-options.extranix.com/?query={searchTerms}&release=master"
                    nixosIcon;
                "Crates.io" = define "crates" "crates.io/search?q={searchTerms}" "crates.io/favicon.ico";
                "Github" =
                  define "gh" "github.com/search?q={searchTerms}&type=repositories"
                    "github.com/favicon.ico";
                "Instant Gaming" =
                  define "ig" "www.instant-gaming.com/en/search/?q={searchTerms}"
                    "www.instant-gaming.com/favicon.ico";
                "ProtonDB" =
                  define "protondb" "www.protondb.com/search?q={searchTerms}"
                    "www.protondb.com/favicon.ico";
                "Modrinth" =
                  define "modrinth" "www.modrinth.com/mods?q={searchTerms}"
                    "www.modrinth.com/favicon.ico";
                "Arch" =
                  define "arch" "wiki.archlinux.org/index.php?search={searchTerms}"
                    "wiki.archlinux.org/favicon.ico";
                "Gentoo" =
                  define "gentoo" "wiki.gentoo.org/index.php?search={searchTerms}"
                    "wiki.gentoo.org/favicon.ico";
                "Portage" =
                  define "portage" "packages.gentoo.org/packages/search?q={searchTerms}"
                    "packages.gentoo.org/favicon.ico";
                "Sign Dict" =
                  define "signdict" "signdict.org/search?q={searchTerms}"
                    "https://signdict.org/favicon.ico";
                "google".metaData.hidden = true;
                "bing".metaData.hidden = true;
                "Amazon.de".metaData.hidden = true;
                "ebay".metaData.hidden = true;
                "Twitter".metaData.hidden = true;
              };
          };

          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            boring-rss
            clearurls
            close-tabs-shortcuts
            darkreader
            decentraleyes
            don-t-fuck-with-paste
            enhanced-github
            enhanced-h264ify
            github-file-icons
            gnome-shell-integration
            istilldontcareaboutcookies
            modrinthify
            multi-account-containers
            no-pdf-download
            privacy-possum
            return-youtube-dislikes
            smart-referer
            sponsorblock
            ublock-origin
            user-agent-string-switcher
          ];

          settings = {
            "extensions.autoDisableScopes" = 0;
            "browser.translations.automaticallyPopup" = false;
            "media.rdd-ffmpeg.enabled" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "media.navigator.mediadatadecoder_vpx_enabled" = true;
            "dom.input.fallbackUploadDir" = config.home.homeDirectory;
            "browser.fixup.domainsuffixwhitelist.lan" = true;

            "browser.newtabpage.activity-stream.feeds.topsites" = false;
              
            "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "dark-panda";

            "browser.ml.linkPreview.enabled" = false;
            "browser.ml.chat.enabled" = false;
            "browser.ml.enable" = false;
            "browser.tabs.groups.smart.enabled" = false;
            "browser.tabs.groups.smart.userEnabled" = false;
            "extensions.ml.enabled" = false;
            "sidebar.revamp" = false;
          };
        };

        profiles.empty = {
          id = 1;

          search = {
            default = "ddg";
            force = true;
          };
        };
      };
    };
}
