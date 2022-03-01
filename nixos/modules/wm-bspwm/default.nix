{ pkgs, ... }:

{
  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
  };

  services.xserver.windowManager.bspwm.enable = true;
}
