{ pkgs, ... }:

{
  boot.blacklistedKernelModules = [ "bcma" "wl" ];

  environment.systemPackages = [ pkgs.tailscale ];

  networking.defaultGateway = {
    address = "10.86.0.1";
    interface = "enp5s0";
  };
  networking.dhcpcd.enable = false;
  networking.domain = "asgard.local";
  # Recommended with Tailscale on NixOS 22.05
  networking.firewall.checkReversePath = "loose";
  networking.hostId = "5fe1b1f0";
  networking.hostName = "heimdall";
  networking.interfaces = {
    enp5s0 = {
      ipv4.addresses = [{
        address = "10.86.1.97";
        prefixLength = 23;
      }];
      useDHCP = false;
    };
  };
  networking.nameservers = [ "10.86.0.1" "1.1.1.1" "1.0.0.1" ];
  networking.networkmanager.enable = false;
  networking.useDHCP = false;
  networking.useNetworkd = false;
  networking.wireless.enable = false;

  services.connman.enable = false;

  services.tailscale.enable = true;

  # systemd.services.systemd-networkd-wait-online.enable = false;

  # See Mic92/dotfiles/nixos/vms/modules/networkd.nix
  # systemd.services.systemd-udev-settle.serviceConfig.ExecStart = ["" "${pkgs.coreutils}/bin/true"];
}
