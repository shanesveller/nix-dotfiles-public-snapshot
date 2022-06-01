{ pkgs, ... }:

{
  imports = [
    ./docker.nix
    # ./k3s.nix
    ./libvirt.nix
    ./microvms.nix
  ];
}
