{ pkgs, ... }:

{
  users.users.shane = {
    packages = with pkgs; [ unstable.aseprite-unfree blender unstable.tiled ];
  };
}
