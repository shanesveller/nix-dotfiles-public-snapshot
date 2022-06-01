{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "kubeseal-${version}";
  version = "0.12.5";

  # nix-prefetch-url --unpack https://github.com/bitnami-labs/sealed-secrets/archive/v0.12.5.tar.gz
  src = fetchFromGitHub {
    owner = "bitnami-labs";
    repo = "sealed-secrets";
    rev = "v${version}";
    sha256 = "135ls3ngdz43qx6a49faczs2vdmccalsgak2hg0rairpy2jxym37";
  };

  vendorSha256 = null;

  subPackages = [ "cmd/kubeseal" ];

  meta = {
    description = "Simple command-line snippet manager, written in Go";
    homepage = "https://github.com/bitnami-labs/sealed-secrets";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
