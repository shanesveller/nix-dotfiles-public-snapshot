{ pkgs, ... }:

{
  imports = [ ../jre ];

  boot.kernel.sysctl."vm.swappiness" = 1;

  powerManagement.cpuFreqGovernor = "performance";

  programs.steam.enable = true;

  users.users.shane = {
    packages = [ pkgs.mudlet pkgs.unstable.multimc pkgs.unstable.steam-run ];
  };
}
