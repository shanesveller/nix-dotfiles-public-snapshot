{ pkgs, ... }:

{

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  nixpkgs.config.pulseaudio = true;

  sound.enable = true;
  sound.mediaKeys.enable = true;

  users.users.shane = {
    extraGroups = [ "audio" ];
    packages = with pkgs; [ pavucontrol ];
  };
}
