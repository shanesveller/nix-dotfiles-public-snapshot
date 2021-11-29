{ config, lib, pkgs, ... }:

with lib;
let
  inherit (builtins) concatStringsSep splitVersion;
  inherit (builtins) getAttr;

  cfg = config.programs.shanesveller.elixir;
  beam = pkgs.callPackage ../pkgs/elixir { };

  slugify_version = version: concatStringsSep "_" (splitVersion version);
  slug = name: version: "${name}_${slugify_version version}";
  lookupSluggedPackage = name: version: getAttr (slug name version);

  lspPackage = if cfg.nixBuild then
    pkgs.unstable.elixir_ls.overrideAttrs
    (_orig: { elixir = cfg.elixirPackage; })
  else
    pkgs.unstable.elixir_ls;
in {
  options.programs.shanesveller.elixir = {
    enable = mkEnableOption "Elixir";
    asdfDeps = mkEnableOption "Install ASDF deps";
    lsp = mkEnableOption "ElixirLS";
    nixBuild = mkEnableOption "Build with Nix";

    erlangVersion = mkOption {
      type = types.strMatching
        "[[:digit:]]+.[[:digit:]]+(.[[:digit:]]+(.[[:digit:]]+)?)?";
      default = "22.2.2";
      defaultText = "22.2.2";
      example = "22.0.7";
      description = "The Erlang version to use.";
    };

    elixirVersion = mkOption {
      type = types.strMatching "[[:digit:]]+.[[:digit:]]+.[[:digit:]]+";
      default = "1.9.4";
      defaultText = "1.9.4";
      example = "1.8.2";
      description = "The Elixir version to use.";
    };

    otpPackageSet = mkOption {
      type = types.attrsOf types.package;
      internal = true;
      readOnly = true;
      visible = false;
    };

    erlangPackage = mkOption {
      type = types.package;
      description = "The Erlang package selected using `erlangVersion`.";
      internal = true;
      readOnly = true;
      visible = false;
    };

    elixirPackage = mkOption {
      type = types.package;
      description =
        "The Elixir package built using the configured Erlang version.";
      internal = true;
      readOnly = true;
      visible = false;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ ] ++ lib.optionals
      # https://github.com/NixOS/nixpkgs/blob/3ac9de55b08fa8b20f8e56dfe0016d51834eb079/pkgs/development/interpreters/erlang/generic-builder.nix
      (cfg.asdfDeps) (with pkgs; [
        autoconf
        automake
        gawk
        gnum4
        gnused
        libxml2
        libxslt
        ncurses
        openssl
        wxGTK
      ]) ++ lib.optional cfg.lsp lspPackage
      ++ lib.optionals cfg.nixBuild (with cfg; [ erlangPackage elixirPackage ])
      ++ lib.optional (pkgs.stdenv.isLinux) pkgs.inotify-tools;

    home.sessionVariables = { ERL_AFLAGS = "-kernel shell_history enabled"; };

    programs.shanesveller.elixir.otpPackageSet =
      lookupSluggedPackage "erlang" cfg.erlangVersion beam;
    programs.shanesveller.elixir.erlangPackage = cfg.otpPackageSet.erlang;
    programs.shanesveller.elixir.elixirPackage =
      lookupSluggedPackage "elixir" cfg.elixirVersion cfg.otpPackageSet;
  };
}
