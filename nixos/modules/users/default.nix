{ pkgs, ... }:

{
  nix.trustedUsers = [ "root" "@wheel" ];

  security.sudo.wheelNeedsPassword = false;
  security.sudo.extraConfig = ''
    Defaults:shane !requiretty
  '';

  users.mutableUsers = false;
  users.extraUsers.shane = {
    isNormalUser = true;
    home = "/home/shane";
    createHome = true;
    description = "Shane Sveller";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPassword =
      "$6$6fPFbnmed29ycdF$8x.v.EmbLSQokPUunAmjR9Iu2RxdGTRc0GXYpwP/pnHpqwAyU2Aa4S4.2fMKJbHajL7B0My9sI1Jv0WLndDUN.";
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWDjL7yKUMwQf+dgCB0B/Bm4YYCoQq3uNJz7VLXPv6a shane@Kvasir.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqXac+BmertNSJW/w7/798BpGKUbQ28K+a9XpIMHyJg shane@odin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO5DZDyWmJ5TrbOGSsMj5kDkprfIUutBZmGAUo4VrU2b shane@odin"
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4OWpvfyqC0BneVJWjjPJ0rACHsYj9CNpEsDBc8KrfK shane@Heimdall"
      # 2021-09-05 odin
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO5DZDyWmJ5TrbOGSsMj5kDkprfIUutBZmGAUo4VrU2b shane@odin"
    ];
    shell = pkgs.fish;
  };

  users.users.root = {
    hashedPassword =
      "$6$tnyeuwh6XhhaBKr3$/1YLvEB8staKFD7bdWK9p9zYFp4NBdxMWUH.rNPigy5dY1JXpdxFAd5Ym0tiENrE05ppifaQk5WKPObMeGTE9/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWDjL7yKUMwQf+dgCB0B/Bm4YYCoQq3uNJz7VLXPv6a shane@Kvasir.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEfhf0NNYdW+XARp5XZbUPjWNzc/voWoXADt9SSacucF root@odin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6OtSECnmEkt1i4HNiBtMb2iqZJOr9/P4eR+VEfQ6l+ root@Kvasir.local"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwty2kebNl7XifC+AcShmppMid1yZL3zMsyT8puQ8dP root@odin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO5DZDyWmJ5TrbOGSsMj5kDkprfIUutBZmGAUo4VrU2b shane@odin"
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB4OWpvfyqC0BneVJWjjPJ0rACHsYj9CNpEsDBc8KrfK shane@Heimdall"
      # 2021-09-05 odin shane
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO5DZDyWmJ5TrbOGSsMj5kDkprfIUutBZmGAUo4VrU2b shane@odin"
      # 2021-09-05 odin root
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3nG/nDoKhqoJY1j8HWtES/mblu56uaqzirAW70g+/C root@odin"
    ];
  };
}
