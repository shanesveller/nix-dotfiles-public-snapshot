{ pkgs, ... }:

let
  package = pkgs.postgresql_12;
  getMajorVersion = version: builtins.elemAt (builtins.splitVersion version) 0;
  majorVersion = getMajorVersion package.version;
in {
  services.postgresql = {
    enable = true;
    inherit package;

    dataDir = "/srv/postgres/${majorVersion}";

    ensureUsers = [{ name = "shane"; }];

    settings = {
      shared_preload_libraries = "pg_stat_statements";
      "pg_stat_statements.track" = "all";
    };
  };

  users.users.shane = { packages = [ pkgs.jetbrains.datagrip ]; };
}
