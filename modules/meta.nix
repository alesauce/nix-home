{lib, ...}: {
  options.flake.meta = lib.mkOption {
    description = "Cross-cutting flake-level identity and config data, contributed to by multiple modules (owner.nix, theme.nix, etc.) and read by wrapped programs and hosts alike.";
    type = lib.types.submodule {
      options = {
        owner = lib.mkOption {
          description = "Identity of the flake's primary owner/user.";
          type = lib.types.submodule {
            options = {
              email = lib.mkOption {
                type = lib.types.str;
                description = "Owner's email address.";
              };
              name = lib.mkOption {
                type = lib.types.str;
                description = "Owner's display name.";
              };
              username = lib.mkOption {
                type = lib.types.str;
                description = "Owner's system/GitHub username.";
              };
            };
          };
        };

        theme = lib.mkOption {
          description = "The flake-wide color theme. Applied directly by stylix, and derived by wrapped programs stylix can't reach.";
          type = lib.types.submodule {
            options = {
              family = lib.mkOption {
                type = lib.types.str;
                description = ''Base16 theme family (e.g. "catppuccin"), matching a tinted-schemes base16/<family>-<flavor>.yaml file.'';
              };
              flavor = lib.mkOption {
                type = lib.types.str;
                description = ''Theme flavor/variant within the family (e.g. "mocha").'';
              };
              palette = lib.mkOption {
                type = lib.types.attrsOf (lib.types.strMatching "[0-9a-fA-F]{6}");
                description = "The 16 base16 colors (base00..base0F), as lowercase hex strings without a leading '#', parsed from the family/flavor's yaml file.";
              };
            };
          };
        };
      };
    };
  };
}
