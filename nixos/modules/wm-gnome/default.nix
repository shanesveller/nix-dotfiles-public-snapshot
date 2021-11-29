{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    evince
    gnome3.adwaita-icon-theme
    gnome3.gnome-tweak-tool
    gnomeExtensions.appindicator
    gnome38Extensions."dash-to-dock@micxgx.gmail.com"
    gnome38Extensions."emoji-selector@maestroschan.fr"
    gnome40Extensions."sound-output-device-chooser@kgshank.net"
    gnomeExtensions.system-monitor
  ];
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
}
