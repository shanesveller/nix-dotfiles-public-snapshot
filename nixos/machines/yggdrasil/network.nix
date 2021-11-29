{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.tailscale ];
  networking.dhcpcd.enable = false;
  networking.domain = "asgard.local";
  networking.enableIPv6 = false;
  networking.hostName = "yggdrasil";
  networking.networkmanager.enable = false;
  networking.wireless.enable = false;
  networking.firewall.allowedTCPPorts = [ 25565 ];
  services.tailscale.enable = true;
}
