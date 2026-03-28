{
  flake.modules = let
    aspellConfig = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.es
      ];
      environment.etc."aspell.conf".text = ''
        master en_US
        add-extra-dicts en-computers.rws
        add-extra-dicts es.rws
      '';
    };
  in {
    nixos.base = aspellConfig;
    darwin.base = aspellConfig;
  };
}
