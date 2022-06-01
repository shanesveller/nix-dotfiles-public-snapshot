{ pkgs, ... }:

{
  imports = [ ../jre ];

  boot.kernel.sysctl."vm.swappiness" = 1;

  environment.systemPackages = [ pkgs.steamcmd ];

  powerManagement.cpuFreqGovernor = "performance";

  users.users.shane = { packages = [ pkgs.unstable.steam-run ]; };
}
