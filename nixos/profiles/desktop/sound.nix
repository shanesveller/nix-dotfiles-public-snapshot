{ pkgs, ... }:

{

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  nixpkgs.config.pulseaudio = true;

  sound.enable = true;
  sound.mediaKeys.enable = true;

  users.users.shane = {
    extraGroups = [ "audio" ];
    packages = with pkgs; [
      mopidy
      mopidy-spotify
      # TODO: Check for Desktop also
      pavucontrol
      # TODO: Check for Desktop also
      spotify
    ];
  };
}
