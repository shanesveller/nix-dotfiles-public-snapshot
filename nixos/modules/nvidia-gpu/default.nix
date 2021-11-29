{ ... }:

{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  services.xserver.displayManager.gdm.wayland = false;
  services.xserver.videoDrivers = [ "nvidia" ];
}
