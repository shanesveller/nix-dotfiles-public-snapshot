{ pkgs, ... }:

{

  imports = [ ./internet.nix ./sound.nix ];

  boot.plymouth.enable = true;

  services.xserver.enable = true;

  users.users.shane = {
    packages = with pkgs; [
      lshw
      # lsusb
      xfce.thunar
      xfce.thunar-dropbox-plugin
      usbutils
    ];
  };
}
