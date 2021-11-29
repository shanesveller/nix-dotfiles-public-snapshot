{ pkgs, ... }:

{
  users.users.shane = { packages = with pkgs; [ vscode zeal ]; };

}
