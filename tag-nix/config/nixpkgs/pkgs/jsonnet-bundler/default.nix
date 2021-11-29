{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "jsonnet-bundler-${version}";
  version = "0.4.0";

  subPackages = [ "cmd/jb" ];

  # nix-prefetch-url --unpack https://github.com/jsonnet-bundler/jsonnet-bundler/archive/v0.4.0.tar.gz
  src = fetchFromGitHub {
    owner = "jsonnet-bundler";
    repo = "jsonnet-bundler";
    rev = "v${version}";
    sha256 = "0pk6nf8r0wy7lnsnzyjd3vgq4b2kb3zl0xxn01ahpaqgmwpzajlk";
  };

  vendorSha256 = null;

  meta = {
    description = "A jsonnet package manager.";
    homepage = "https://github.com/jsonnet-bundler/jsonnet-bundler";
    license = lib.licenses.asl20;
    maintainers = [ "Shane Sveller <shane@shanesveller.com>" ];
  };
}
