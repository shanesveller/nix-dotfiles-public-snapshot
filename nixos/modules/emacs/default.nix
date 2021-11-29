{ pkgs, ... }:

{
  services.emacs = {
    defaultEditor = true;
    enable = true;
    install = true;
    # client = {
    #   enable = true;
    #   arguments = [ "-c" ];
    # };
    package = pkgs.emacsPgtkGcc;
    # socketActivation.enable = false;
  };
}
