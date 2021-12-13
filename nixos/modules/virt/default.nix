{ config, pkgs, ... }:

{
  imports = [ ./docker.nix ./k3s.nix ];

  environment.systemPackages = with pkgs; [ virt-manager xfsprogs ];

  # breaks k3d
  systemd = if (config.systemd ? enableUnifiedCgroupHierarchy) then {
    enableUnifiedCgroupHierarchy = false;
  } else
    { };

  users.extraUsers.shane = { extraGroups = [ "libvirtd" ]; };

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.onShutdown = "shutdown";

  virtualisation.virtualbox.host.enable = false;
}
