{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "gojsontoyaml-${version}";
  version = "unstable-20200602";

  # nix-prefetch-url --unpack https://github.com/brancz/gojsontoyaml/archive/3697ded27e8cfea8e547eb082ebfbde36f1b5ee6.tar.gz
  src = fetchFromGitHub {
    owner = "brancz";
    repo = "gojsontoyaml";
    rev = "3697ded27e8cfea8e547eb082ebfbde36f1b5ee6";
    sha256 = "07sisadpfnzbylzirs5ski8wl9fl18dm7xhbv8imw6ksxq4v467a";
  };

  vendorSha256 = null;

  meta = {
    description = "Simply tool to convert json to yaml written in Go.";
    license = lib.licenses.mit;
    homepage = "https://github.com/brancz/gojsontoyaml";
  };
}
