{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "docker-show-context-${version}";
  version = "unstable-20210412";

  # nix-prefetch-url --unpack https://github.com/pwaller/docker-show-context/archive/19f133f08f92074bb8a6bb89f482532e5632d18b.tar.gz
  src = fetchFromGitHub {
    owner = "pwaller";
    repo = "docker-show-context";
    rev = "19f133f08f92074bb8a6bb89f482532e5632d18b";
    sha256 = "1anxbsmapz8znc3x3pwlbimqycbripw688vg7a0mcniysaf6ihv8";
  };

  vendorSha256 = "sha256-v/UfZehnahn7CIB7jQDodng+B9v5t/MQDtVYir8j+Hc=";

  meta = {
    description =
      "Show where time is wasted during the context upload of `docker build`";
    homepage = "https://github.com/pwaller/docker-show-context";
    license = lib.licenses.mit;
    maintainers = [ "Shane Sveller <shane@shanesveller.com>" ];
  };
}
