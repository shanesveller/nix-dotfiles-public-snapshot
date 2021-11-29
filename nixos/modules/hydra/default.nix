{ ... }:

{
  networking.firewall.allowedTCPPorts = [ 3000 ];
  programs.ssh.knownHosts = [{
    hostNames = [ "github.com" ];
    publicKey =
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
  }];

  # security.sudo.extraRules = [
  #   {
  #     commands = [
  #       { command = "${pkgs.postgresql96}/bin/psql"; options = [ "NOPASSWD" ]; }
  #     ];
  #     groups = [ "postgres" ];
  #     runAs = "postgres";
  #   }
  #   {
  #     commands = [
  #       { command = "${pkgs.postgresql96}/bin/psql"; options = [ "NOPASSWD" ]; }
  #     ];
  #     groups = [ "postgres" ];
  #     runAs = "ALL:ALL";
  #   }
  #   {
  #     commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
  #     groups = [ "postgres" ];
  #     runAs = "ALL:ALL";
  #   }
  #   {
  #     commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
  #     users = [ "postgres" ];
  #     runAs = "ALL:ALL";
  #   }
  # ];

  # security.sudo.extraConfig = ''
  #   Defaults:postgres !requiretty
  # '';

  # services.postgresql = {
  #   enable = true;
  # };

  # users.groups.postgres.groups = [ "wheel" ];

  # systemd.services.postgresql = {
  #   postStart = "";
  # };

  services.hydra = {
    enable = true;
    hydraURL = "http://10.86.0.3:3000"; # externally visible URL
    notificationSender = "hydra@localhost"; # e-mail of hydra service
    # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [ ];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
  };
}
