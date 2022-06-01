{ pkgs, ... }:

{
  imports = [
    ./nix.nix

    ./home.nix
    ./bash.nix
    ./data.nix
    ./fish
    ./zsh.nix

    ./git.nix
    ./ssh.nix
    ./tmux.nix

    ./emacs
    ./vim
    ./vscode.nix

    ./local-packages.nix
    ./media
    ./utilities.nix
    ./work.nix

    ./elixir.nix
    ./go.nix
    ./kube.nix
    ./lisp.nix
    ./node.nix
    ./python.nix
    ./rust.nix
  ] ++ (if pkgs.stdenv.isLinux then
    [
      # NixOS only
      ./bspwm
    ]
  else
    [ ]);
}
