{ lib, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/uefi
    ../../modules/base
    ../../modules/zfs
    ./znapzend.nix
    ../../modules/users
    ../../networks/asgard
    ./network.nix
    # Not available to flakes
    # <nixpkgs/nixos/modules/profiles/graphical.nix>
    ../../modules/xwindows
    ../../profiles/desktop
    ../../modules/dev
    ./dev.nix
    ../../modules/fancy-xwindows
    ../../modules/gaming
    # ../../modules/git-server
    ../../modules/wm-bspwm
    # ../../modules/wm-gnome
    # ../../modules/wm-kde
    ../../modules/wm-i3
    ../../modules/virt
  ];

  environment.systemPackages = [ ];

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.persistent = true;
  nix.gc.randomizedDelaySec = "30min";

  nix.nixPath = [ ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

  time.timeZone = lib.mkDefault "America/Chicago";
}
