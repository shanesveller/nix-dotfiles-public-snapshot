{ pkgs, ... }:

{
  imports = [
    ./home.nix
    ./bash.nix
    ./data.nix
    ./fish.nix
    ./zsh.nix

    ./git.nix
    ./ssh.nix
    ./tmux.nix

    ../../../../modules/emacs
    ../../../../modules/vim
    ./vscode.nix

    ./email.nix
    ./local-packages.nix
    ./lorri.nix
    ../../../../modules/media
    ./utilities.nix
    ./wakatime.nix
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
      ../../../../modules/bspwm
    ]
  else
    [ ]);
}
