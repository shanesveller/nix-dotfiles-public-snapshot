{ ... }:

{
  programs.bash.enableCompletion = true;
  programs.fish.enable = true;

  programs.tmux = {
    aggressiveResize = true;
    enable = true;
    shortcut = "a";
  };

  programs.zsh.enable = false;

}
