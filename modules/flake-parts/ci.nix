{
  self,
  lib,
  inputs,
  ...
}:
let
  flakeRef = "github:\${{ github.repository }}/\${{ github.sha }}";

  nixConf = builtins.concatStringsSep "\n" [
    "accept-flake-config = true"
    "always-allow-substitutes = true"
    "builders-use-substitutes = true"
    "max-jobs = auto"
  ];

  # Platform to GitHub Actions runner mapping
  platforms = {
    x86_64-linux.os = "ubuntu-latest";
    aarch64-darwin.os = "macos-latest";
  };

  # Auto-discover hosts from flake configurations
  mkHostInfo = type: name: cfg:
    let
      system = cfg.pkgs.stdenv.hostPlatform.system;
      platformInfo = platforms.${system} or null;
      attr =
        {
          nixos = "nixosConfigurations.${name}.config.system.build.toplevel";
          darwin = "darwinConfigurations.${name}.system";
        }
        .${type};
    in
    if platformInfo == null
    then {}
    else {
      inherit name system attr;
      runsOn = platformInfo.os;
    };

  nixosHosts = lib.filter (h: h != {}) (
    lib.mapAttrsToList (mkHostInfo "nixos") (self.nixosConfigurations or {})
  );

  darwinHosts = lib.filter (h: h != {}) (
    lib.mapAttrsToList (mkHostInfo "darwin") (self.darwinConfigurations or {})
  );

  allHosts = nixosHosts ++ darwinHosts;

  # DevShell entries — one per unique platform
  devShellEntries = let
    seen = lib.unique (map (h: h.system) allHosts);
  in
    map (system: {
      name = "devShell-${system}";
      inherit system;
      runsOn = platforms.${system}.os;
      attr = "devShells.${system}.default.inputDerivation";
    }) seen;

  # Pinned GitHub Actions — update hashes when bumping versions
  actions = {
    checkout = "actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd"; # v6.0.2
    nix-installer = "DeterminateSystems/nix-installer-action@90bb610b90bf290cad97484ba341453bd1cbefea"; # v19
    nothing-but-nix = "wimpysworld/nothing-but-nix@687c797a730352432950c707ab493fcc951818d7"; # v10
    alls-green = "re-actors/alls-green@05ac9388f0aebcb5727afa17fcccfecd6f8ec5fe"; # v1.2.2
  };

  setupSteps = [
    {
      name = "Clear out space for Nix (not on macOS)";
      uses = actions.nothing-but-nix;
      "if" = "\${{ runner.os != 'macOS' }}";
    }
    {
      uses = actions.nix-installer;
      "with".extra-conf = nixConf;
    }
  ];

  nix-fast-build-step = flakeAttr: {
    name = "nix-fast-build";
    run = "nix run '${flakeRef}#nix-fast-build' -- --no-nom --skip-cached --retries=3 --option accept-flake-config true --flake='${flakeRef}#${flakeAttr}'";
  };
in
{
  imports = [inputs.actions-nix.flakeModules.default];

  flake.actions-nix = {
    pre-commit.enable = true;

    workflows.".github/workflows/ci.yaml" = {
      name = "ci";

      "on" = {
        push.branches = ["main"];
        pull_request = {};
      };

      permissions = {};

      env = {
        ENABLE_SECRETS = "false";
      };

      jobs = {
        flake-check = {
          runs-on = "ubuntu-latest";
          timeout-minutes = 30;
          steps =
            setupSteps
            ++ [
              {
                name = "nix flake show";
                run = "nix flake show '${flakeRef}'";
              }
            ];
        };

        build = {
          name = "build \${{ matrix.attrs.name }}";
          runs-on = "\${{ matrix.attrs.runsOn }}";
          needs = ["flake-check"];
          timeout-minutes = 60;
          strategy = {
            fail-fast = false;
            matrix.attrs = map (entry: {
              inherit (entry) name runsOn attr;
            }) (allHosts ++ devShellEntries);
          };
          steps =
            setupSteps
            ++ [
              (nix-fast-build-step "\${{ matrix.attrs.attr }}")
            ];
        };

        check = {
          runs-on = "ubuntu-latest";
          needs = ["flake-check" "build"];
          "if" = "always()";
          timeout-minutes = 5;
          steps = [
            {
              uses = actions.alls-green;
              "with".jobs = "\${{ toJSON(needs) }}";
            }
          ];
        };
      };
    };
  };
}
