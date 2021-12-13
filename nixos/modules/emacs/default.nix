{ flake, pkgs, ... }:

{
  services.emacs = {
    defaultEditor = true;
    enable = true;
    install = true;
    # client = {
    #   enable = true;
    #   arguments = [ "-c" ];
    # };
    package = flake.packages.x86_64-linux.emacs;
    # socketActivation.enable = false;
  };
}
