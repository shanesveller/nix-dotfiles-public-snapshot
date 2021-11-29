{ ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = false;
  services.zfs.trim.enable = true;
}
