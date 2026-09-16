{
  pkgs,
  lib,
  config,
  ...
}: {
  options.languages.scala = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Scala language support in neovim.";
    };
    jdk = lib.mkOption {
      type = lib.types.package;
      default = pkgs.jdk17;
      description = "JDK sbt runs on (Metals bundles its own JDK and ignores this). sbt has no JDK of its own — resolves plain `java` via PATH, not JAVA_HOME. Override per-project needs.";
    };
  };

  config = lib.mkIf config.languages.scala.enable {
    extraPackages = [pkgs.sbt config.languages.scala.jdk];
    plugins.lsp.servers.metals.enable = true;
  };
}
