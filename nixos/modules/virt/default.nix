{ pkgs, ... }:

{
  imports = [ ./docker.nix ./k3s.nix ];

  environment.systemPackages = with pkgs; [
    firecracker
    firectl
    ignite
    virt-manager
    xfsprogs
  ];

  users.extraUsers.shane = { extraGroups = [ "libvirtd" ]; };

  virtualisation.libvirtd.enable = false;
  virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm;
  virtualisation.libvirtd.onShutdown = "shutdown";

  virtualisation.virtualbox.host.enable = false;
}
