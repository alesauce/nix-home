{pkgs, ...}: {
  services.mako = {
    enable = true;
    settings = {
      icons = true;
    };
  };

  systemd.user.services.mako = {
    Unit = {
      Description = "mako";
      Documentation = ["man:mako(1)"];
      PartOf = ["sway-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.mako}/bin/mako";
      RestartSec = 3;
      Restart = "always";
    };
    Install = {
      WantedBy = ["sway-session.target"];
    };
  };
}
