{ lib }:
pkg:
let
  allowed = builtins.elem name allowedUnfree;
  allowedUnfree = [
    "1password"
    "1password-cli"
    "aseprite"
    "datagrip"
    "discord"
    "dropbox"
    "firefox-bin"
    "firefox-release-bin-unwrapped"
    "google-chrome"
    "memtest86-efi"
    "nvidia-settings"
    "nvidia-x11"
    "slack"
    "steam"
    "steamcmd"
    "steam-original"
    "steam-runtime"
    # TODO: why-depends on these
    "vscode"
  ];
  name = lib.getName pkg;
in lib.traceIf (!allowed) "failed unfree: ${name}" allowed
