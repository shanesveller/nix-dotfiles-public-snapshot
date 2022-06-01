{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs; [ alacritty calibre heaptrack pinentry xclip ];
  };

}
