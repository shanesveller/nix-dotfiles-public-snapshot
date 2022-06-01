{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.shanesveller.postgresql;

  majorVersion = pkg: builtins.head (builtins.splitVersion pkg.version);
in {
  options = {
    shanesveller.postgresql = {
      enable = mkEnableOption "PostgreSQL";

      enablePostGis = mkEnableOption "PostGIS";

      dataDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        defaultText = "null";
        example = literalExample "/var/lib/postgresql/11";
        description = "The path to store PostgreSQL data.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.postgresql_11;
        defaultText = "pkgs.postgresql_11";
        example = literalExample "pkgs.postgresql_10";
        description = "The PostgreSQL package to use.";
      };

      postgisPackage = mkOption {
        type = types.package;
        default = pkgs.postgis;
        defaultText = "pkgs.postggis";
        example = literalExample "some-other-pkgs.postgis";
        description = "The PostGIS package to use.";
      };
    };
  };
  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;
      dataDir = if cfg.dataDir != null then
        cfg.dataDir
      else
        "/var/lib/postgresql/${majorVersion cfg.package}";
      extraPlugins = mkIf cfg.enablePostGis
        [ (cfg.postgisPackage.override { postgresql = cfg.package; }) ];
    };
  };
}
