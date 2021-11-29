{ pkgs, ... }:

{

  imports = [ ./internet.nix ./sound.nix ];

  # boot.plymouth.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.enable = true;

  users.users.shane = {
    packages = with pkgs; [
      lshw
      # lsusb
      usbutils
    ];
  };
}
