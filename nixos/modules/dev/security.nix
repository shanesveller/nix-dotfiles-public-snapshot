{ pkgs, ... }:

{
  users.users.shane = { packages = with pkgs; [ _1password _1password-gui ]; };
}
