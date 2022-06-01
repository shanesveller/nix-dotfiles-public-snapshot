{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "dive-${version}";
  version = "0.9.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "wagoodman";
    repo = "dive";
    sha256 = "1v69xbkjmyzm5g4wi9amjk65fs4qgxkqc0dvq55vqjigzrranp22";
  };

  vendorSha256 = "0219q9zjc0i6fbdngqh0wjpmq8wj5bjiz5dls0c1aam0lh4vwkhc";

  meta = {
    description = "A tool for exploring each layer in a docker image";
    license = lib.licenses.mit;
    homepage = "https://github.com/wagoodman/dive";
  };
}
