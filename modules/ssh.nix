{ config, lib, ... }:

with lib;
let cfg = config.programs.shanesveller.ssh;
in {
  options.programs.shanesveller.ssh.enable = mkEnableOption "SSH";
  options.programs.shanesveller.ssh.work = mkEnableOption "Work-specific SSH";

  config = mkIf cfg.enable (mkMerge [
    {
      programs.ssh = {
        enable = true;

        compression = true;
        controlMaster = "auto";
        hashKnownHosts = true;
        serverAliveInterval = 60;

        matchBlocks = {
          munin = {
            hostname = "10.86.0.2";
            user = "admin";
          };

          hugin = {
            hostname = "10.86.0.4";
            user = "shane";
          };

          # Nerves training
          # "nerves.local" = {
          #   extraOptions = {
          #     IdentityFile = "~/.ssh/nerves_training_id_rsa";
          #     StrictHostKeyChecking = "no";
          #     UserKnownHostsFile  = "/dev/null";
          #   };
          # };

          heimdall = {
            hostname = "10.86.1.97";
            user = "shane";
          };

          ygg = {
            hostname = "10.86.0.3";
            user = "shane";
          };
        };
      };
    }
    (mkIf cfg.work { programs.ssh = { matchBlocks = { }; }; })
  ]);
}
