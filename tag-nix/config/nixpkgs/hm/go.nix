{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.shanesveller.go;
in {
  options.programs.shanesveller.go = {
    enable = mkEnableOption "Golang";
    packager = mkEnableOption "Golang Nix Packager";

    package = mkOption {
      type = types.package;
      default = pkgs.go;
      defaultText = "pkgs.go";
      example = pkgs.go_1_12;
      description = "The Go package to use.";
    };
  };

  config = mkIf cfg.enable {
    # TODO: option for overlay, or extract overlay
    home.packages = with pkgs;
      [
        dep

        # spacemacs layer
        # fillstruct # does not exist in nix
        gocode
        godef
        # godoc # does not exist in nix
        # godoctor # does not exist in nix
        # gopls # does not exist in nix
        gogetdoc
        goimports
        golangci-lint
        gomodifytags
        gopkgs
        # gorename # does not exist in nix
        gotests
        # guru # does not exist in nix
        impl
      ] ++ pkgs.lib.optionals (cfg.packager) [ dep2nix go2nix vgo2nix ];

    programs.go = {
      enable = true;
      goPath = "src/go";
      package = cfg.package;
    };
  };
}
