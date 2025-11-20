# Graphical user module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nix-home.user.graphical;
in {
  options.nix-home.user.graphical = import ./graphical-options.nix {inherit lib;};

  config = lib.mkIf cfg.enable {
    # Graphical packages
    home.packages =
      (with pkgs; [
        xdg-utils
        rbw
      ])
      ++ (lib.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (with pkgs; [
        discord
        signal-desktop
      ]))
      ++ (lib.optionals (pkgs.stdenv.hostPlatform.system == "x86_64-linux") (with pkgs; [
        beeper
        brave
        spotify
        obsidian
        todoist-electron
      ]));

    # Ghostty terminal
    programs.ghostty = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      installBatSyntax = !pkgs.stdenv.hostPlatform.isDarwin;
      # FIXME: Remove this hack when the nixpkgs pkg works again
      package =
        if pkgs.stdenv.hostPlatform.isDarwin
        then pkgs.hello
        else pkgs.ghostty;
      settings = {
        quit-after-last-window-closed = true;
      };
    };

    # Stylix fonts for graphical applications
    stylix.fonts = {
      sansSerif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Sans";
      };
      serif = {
        package = pkgs.ibm-plex;
        name = "IBM Plex Serif";
      };
      monospace = {
        package = pkgs.nerd-fonts.hack;
        name = "Hack Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 15;
        desktop = 15;
        popups = 15;
        terminal = 17;
      };
    };

    # Firefox configuration
    programs.firefox = lib.mkIf cfg.firefox.enable {
      enable = true;
      package =
        if lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.firefox-bin
        then pkgs.firefox-bin
        else pkgs.firefox;
      profiles.default = {
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ghostery
          tampermonkey
          tree-style-tab
          untrap-for-youtube
        ];
        search = {
          engines = {
            perplexity = {
              name = "Perplexity";
              urls = [
                {
                  template = "https://www.perplexity.ai/";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            nix-packages = {
              name = "Nix Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@np"];
            };
            google.metaData.alias = "@g";
          };
          force = true;
        };
        settings = {
          "browser.newtabpage.pinned" = [
            {
              title = "Perplexity";
              url = "https://perplexity.ai";
            }
          ];
          "browser.urlbar.perplexity.hasBeenInSearchMode" = true;
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
          "services.sync.declinedEngines" = ["passwords" "creditcards" "addresses"];
          "sidebar.verticalTabs" = true;
          "signon.rememberSignons" = false;
        };
      };
    };

    # Stylix target for Firefox
    stylix.targets.firefox.profileNames = lib.mkIf cfg.firefox.enable ["default"];

    # XDG MIME associations for Firefox
    xdg.mimeApps.defaultApplications = lib.mkIf (cfg.firefox.enable && pkgs.stdenv.isLinux) {
      "application/x-extension-htm" = "firefox.desktop";
      "application/x-extension-html" = "firefox.desktop";
      "application/x-extension-shtml" = "firefox.desktop";
      "application/x-extension-xht" = "firefox.desktop";
      "application/x-extension-xhtml" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/chrome" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };

    # Linux-specific graphical settings
    dconf.enable = lib.mkIf (cfg.dconf.enable && pkgs.stdenv.isLinux) (lib.mkForce true);
    home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
      qt5.qtwayland
      qt6.qtwayland
    ]);
    qt.enable = lib.mkIf pkgs.stdenv.isLinux true;
  };
}
