{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.rust;
  fish_cfg = config.programs.shanesveller.fish;
in {
  options.programs.shanesveller.rust = {
    enable = mkEnableOption "Rust";
    cargoPlugins = mkEnableOption "Extra Cargo plugins";
    rustup = mkEnableOption "Rustup";
    sccache = mkEnableOption "SCCache";
    unstable = mkEnableOption "Unstable";
    utilities = mkEnableOption "Utilities";
  };

  config = let maybeUnstable = if cfg.unstable then pkgs.unstable else pkgs;
  in mkIf cfg.enable {
    home.packages = lib.mkMerge [
      (mkIf cfg.cargoPlugins (with maybeUnstable; [
        bacon
        # local definitions
        pkgs.cargo-hack
        pkgs.cargo-nextest
        # upstream
        cargo-cache
        cargo-bloat
        cargo-cache
        cargo-deny
        cargo-edit
        cargo-expand
        cargo-flamegraph
        cargo-outdated
        cargo-sweep
      ]))
      (mkIf cfg.rustup [ maybeUnstable.rustup ])
      (mkIf cfg.sccache [ maybeUnstable.sccache ])
      (mkIf cfg.utilities (with maybeUnstable; [ just mdbook ]))
    ];

    # https://nixos.org/nixpkgs/manual/#sec-generators
    # https://github.com/NixOS/nixpkgs/blob/3645476e861588cec3b8aaa71d06d4b7487abcd4/lib/generators.nix#L111
    # https://doc.rust-lang.org/cargo/guide/build-cache.html
    # https://github.com/mozilla/sccache#usage
    home.file = {
      cargo-config = mkIf (cfg.sccache) {
        target = ".cargo/config";
        text = generators.toINI { } {
          build = { rustc-wrapper = "${maybeUnstable.sccache}/bin/sccache"; };
        };
      };
    };

    programs.fish.functions = mkIf (fish_cfg.enable) {
      cbr = ''open "https://crates.io/crates/$argv"'';
      cbrl = ''open "https://lib.rs/crates/$argv"'';
      cdo = "cargo doc --all-features --open $argv";
      cdop = "cargo doc --open -p $argv";
      rupd = "rustup doc $argv";
    };
  };
}
