{ pkgs, ... }:

{
  imports = [ ../jre ];

  boot.kernel.sysctl."vm.swappiness" = 1;

  powerManagement.cpuFreqGovernor = "performance";

  users.users.shane = { packages = [ pkgs.unstable.steam-run ]; };
}
