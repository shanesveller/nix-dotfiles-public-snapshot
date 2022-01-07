{ ... }:

{
  services.gitea = {
    enable = true;
    disableRegistration = true;
    dump = {
      backupDir = "/srv/backups/gitea";
      enable = true;
      interval = "hourly";
    };
    httpAddress = "127.0.0.1";
    httpPort = 3100;
    repositoryRoot = "/srv/git/repositories";
    rootUrl = "http://localhost:3100";
    stateDir = "/srv/git";
    ssh.enable = true;
  };
}
