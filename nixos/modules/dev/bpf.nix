{ pkgs, ... }:

let linuxPackageSet = pkgs.linuxPackages;
in { environment.systemPackages = with linuxPackageSet; [ bcc bpftrace perf ]; }
