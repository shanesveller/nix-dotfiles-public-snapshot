{ pkgs, ... }:

{

  imports = [ ./internet.nix ./sound.nix ];

  boot.plymouth.enable = false;

  services.xserver.enable = true;

  users.users.shane = {
    packages = with pkgs; [
      lshw
      # lsusb
      mupdf
      xfce.thunar
      xfce.thunar-dropbox-plugin
      usbutils
      zathura
    ];
  };
}
