{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ k3s ];

  services.k3s = {
    disableAgent = false;
    docker = true;
    enable = false;
    extraFlags = "--no-deploy traefik";
  };
}
