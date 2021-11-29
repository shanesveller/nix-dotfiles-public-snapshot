{ pkgs, ... }:

{
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  services.xserver.windowManager.i3.extraSessionCommands = "";

  services.xserver.xautolock = {
    enable = true;
    enableNotifier = true;
    killer = "/run/current-system/systemd/bin/systemctl suspend";
    killtime = 20;
    locker = "${pkgs.i3lock}/bin/i3lock";
    notifier = ''
      ${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"
    '';
    nowlocker = "${pkgs.i3lock}/bin/i3lock";
    time = 1;
  };
}
