{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ virt-manager xfsprogs ];

  users.extraUsers.shane = { extraGroups = [ "libvirtd" ]; };

  virtualisation.libvirtd.enable = false;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.onShutdown = "shutdown";

  virtualisation.virtualbox.host.enable = false;
}
