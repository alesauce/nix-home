{
  lib,
  pkgs,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];

  programs.firefox = {
    enable = true;
    package =
      if lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.firefox-bin
      then pkgs.firefox-bin
      else pkgs.firefox;
    profiles.default = {
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          ghostery
          omnisearch
          tampermonkey
          tree-style-tab
          untrap-for-youtube
        ];
      };
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

  xdg.mimeApps.defaultApplications = {
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
}
