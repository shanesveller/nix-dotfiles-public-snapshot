{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs; [ aseprite-unfree blender tiled ];
  };
}
