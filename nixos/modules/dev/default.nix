{ pkgs, ... }: {
  imports = [
    ./bpf.nix
    ./database.nix
    ./desktop.nix
    ./editor.nix
    ./fonts.nix
    ./gamedev.nix
    ./git.nix
    ./internet.nix
    ./kube.nix
    # ./media.nix
    ./security.nix
    ./shell.nix
    ../emacs
  ];

  environment.systemPackages = with pkgs; [ gcc gnumake ];
}
