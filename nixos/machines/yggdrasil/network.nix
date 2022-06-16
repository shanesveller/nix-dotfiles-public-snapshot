{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.tailscale ];
  networking.dhcpcd.enable = false;
  networking.domain = "asgard.local";
  networking.enableIPv6 = false;
  # Recommended with Tailscale on NixOS 22.05
  networking.firewall.checkReversePath = "loose";
  networking.hostName = "yggdrasil";
  networking.networkmanager.enable = false;
  networking.wireless.enable = false;
  networking.firewall.allowedTCPPorts = [ 25565 ];
  services.tailscale.enable = true;
}
