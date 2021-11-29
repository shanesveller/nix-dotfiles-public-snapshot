{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "docker-show-context-${version}";
  version = "unstable-20191108";

  # nix-prefetch-url --unpack https://github.com/pwaller/docker-show-context/archive/0aad35647cbab6f571486d001bf98d933280f862.tar.gz
  src = fetchFromGitHub {
    owner = "pwaller";
    repo = "docker-show-context";
    rev = "0aad35647cbab6f571486d001bf98d933280f862";
    sha256 = "1zrkhragvmsny799whvhnywvy3s0m9388n8mw7gl8rzp240lqkns";
  };

  vendorSha256 = "0xzq4fzqln6m1q8g7dzrvc3kwy3nx008syw013xijsk7x1jizxdz";

  meta = {
    description =
      "Show where time is wasted during the context upload of `docker build`";
    homepage = "https://github.com/pwaller/docker-show-context";
    license = lib.licenses.mit;
    maintainers = [ "Shane Sveller <shane@shanesveller.com>" ];
  };
}
