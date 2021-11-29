{ pkgs, ... }:

{
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  # programs.gnupg.agent.extraConfig = ''
  #   allow-emacs-pinentry
  #   allow-loopback-pinentry
  # '';
  programs.gnupg.agent.pinentryFlavor = "gnome3";
  programs.seahorse.enable = true;
  programs.ssh.startAgent = false;

  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  services.kbfs.enable = false;
  services.keybase.enable = false;

  users.users.shane = {
    packages = with pkgs; [
      aws-vault
      awscli
      discord
      dnsutils
      element-desktop
      keybase
      slack
    ];
  };

}
