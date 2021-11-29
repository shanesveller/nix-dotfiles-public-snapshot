{ pkgs, ... }:

{
  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
    fira-mono
    (nerdfonts.override {
      fonts =
        [ "FiraCode" "FiraMono" "Iosevka" "JetBrainsMono" "SourceCodePro" ];
    })
    powerline-fonts
    source-code-pro
  ];
}
