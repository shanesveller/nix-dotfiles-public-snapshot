{ pkgs, ... }:

{
  boot.plymouth.enable = true;

  services.picom = {
    enable = true;
    # blurExclude = [ "class_i = 'polybar'" ];
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

  services.redshift.enable = true;
  # services.redshift.tray = true;

  systemd.user.services."dunst" = {
    enable = true;
    description = "";
    wantedBy = [ "graphical.target" ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
  };
}
