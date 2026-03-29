{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs) self darwin nixpkgs;
in {
  flake.darwinConfigurations.vonnegut =
    withSystem "aarch64-darwin" ({
      pkgs,
      system,
      ...
    }:
      darwin.lib.darwinSystem {
        inherit pkgs system;
        modules =
          (builtins.attrValues self.modules.darwin)
          ++ [
            ({pkgs, ...}: {
              home-manager.users.alesauce = {config, ...}: {
                home = {
                  sessionPath = [
                    "${config.home.homeDirectory}/.local/bin"
                  ];
                  packages = with pkgs; [
                    python313
                  ];
                };
              };

              homebrew = {
                casks = [
                  {
                    name = "beeper";
                    greedy = true;
                  }
                  {
                    name = "todoist";
                    greedy = true;
                  }
                ];
              };

              nix = {
                gc.automatic = true;
                linux-builder.enable = true;
                settings = {
                  max-substitution-jobs = 20;
                  system-features = ["big-parallel" "gccarch-armv8-a"];
                  trusted-users = ["alesauce"];
                };
              };

              users.users.alesauce = {
                uid = 504;
                gid = 20;
              };
            })
            {
              nix.registry = {
                nixpkgs.flake = nixpkgs;
                p.flake = nixpkgs;
              };
            }
          ];
      });
}
