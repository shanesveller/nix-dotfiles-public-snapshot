{ pkgs, ... }:

{

  imports = [ ./cachix.nix ./network.nix ./nix.nix ./shell.nix ];

  boot.cleanTmpDir = true;

  environment.systemPackages = with pkgs; [
    efibootmgr
    efivar
    file
    htop
    lsof
    ncdu
    neovim-unwrapped
    pciutils
    pstree
    rsync
    unzip
  ];

  services.prometheus.exporters.node = {
    enable = false;
    # enabledCollectors = [ "systemd" ];
    openFirewall = true;
  };

  time.timeZone = "America/Chicago";
}
