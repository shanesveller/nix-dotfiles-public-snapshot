{ pkgs, ... }: {
  users.users.shane = { packages = with pkgs; [ git gitAndTools.hub ]; };
}
