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
    # ../../modules/gitlab-runner
    # ../../modules/hydra
    # ../../modules/plex
    # ../../modules/virt
  ];

  environment.systemPackages = [ ];

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  nix.nixPath = [ ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "21.05"; # Did you read the comment?

  time.timeZone = lib.mkDefault "America/Chicago";
}
