{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.shanesveller.rust;
  fish_cfg = config.programs.shanesveller.fish;
in {
  options.programs.shanesveller.rust.enable = mkEnableOption "Rust";
  options.programs.shanesveller.rust.sccache = mkEnableOption "SCCache";

  config = mkIf cfg.enable {
    # TODO: Unstable overlay
    home.packages = with pkgs;
      [ cargo-cache cargo-sweep just mdbook pkgs.rust-analyzer rustup ]
      ++ lib.optionals (cfg.sccache) [ sccache ];

    # https://nixos.org/nixpkgs/manual/#sec-generators
    # https://github.com/NixOS/nixpkgs/blob/3645476e861588cec3b8aaa71d06d4b7487abcd4/lib/generators.nix#L111
    # https://doc.rust-lang.org/cargo/guide/build-cache.html
    # https://github.com/mozilla/sccache#usage
    home.file = {
      cargo-config = mkIf (cfg.sccache) {
        target = ".cargo/config";
        text = generators.toINI { } {
          build = { rustc-wrapper = "${pkgs.sccache}/bin/sccache"; };
        };
      };
    };

    programs.fish.functions = mkIf fish_cfg.enable {
      cbr = ''open "https://crates.io/crates/$argv"'';
      cbrl = ''open "https://lib.rs/crates/$argv"'';
      cdo = "cargo doc --all-features --open $argv";
      cdop = "cargo doc --open -p $argv";
      rupd = "rustup doc $argv";
    };
  };
}
