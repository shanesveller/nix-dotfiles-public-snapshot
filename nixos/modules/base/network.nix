{ ... }:

{
  programs.mtr.enable = true;

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "prohibit-password";
}
