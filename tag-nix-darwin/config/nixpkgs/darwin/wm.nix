{ pkgs, ... }:
let shouldEnable = pkgs ? chunkwm;
in {
  services.chunkwm = { enable = shouldEnable; };

  services.skhd = { enable = shouldEnable; };
}
