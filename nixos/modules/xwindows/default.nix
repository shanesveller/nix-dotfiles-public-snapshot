{ ... }:

{
  services.xserver.enable = true;
  services.xserver.enableCtrlAltBackspace = true;

  services.xserver.desktopManager.xterm.enable = true;

  services.xserver.displayManager = {
    # see also: gnome, none+i3
    defaultSession = "none+home-manager";
    # GDM is required for Gnome Screen Locking
    # gdm.enable = true;
    lightdm.enable = true;
    lightdm.greeters.enso.enable = true;

    session = [{
      manage = "window";
      name = "home-manager";
      start = ''
        exec $HOME/.xsession-hm
      '';
    }];
  };
}
