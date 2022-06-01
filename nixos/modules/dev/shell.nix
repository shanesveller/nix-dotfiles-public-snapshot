{ pkgs, ... }: {
  users.users.shane = { packages = with pkgs; [ direnv ripgrep ]; };
}
