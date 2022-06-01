{ lib, fetchFromGitHub, rustPlatform, stdenv, installShellFiles, pkg-config
, DiskArbitration, Foundation, libiconv, openssl, zellij, testVersion }:

let
  pname = "zellij";
  # https://github.com/zellij-org/zellij/releases/latest
  version = "0.29.1";
in rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    sha256 = "sha256-KuelmMQdCazwTlolH5xvvNXZfzHQDUV6rrlk037GFb8=";
  };

  cargoSha256 = "sha256-He8rMY8n15ZSF/GcbuYTx2JfZgqQnsZLfqP+lUYxnzw=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ DiskArbitration Foundation libiconv ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  passthru.tests.version = testVersion { package = zellij; };

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog =
      "https://github.com/zellij-org/zellij/blob/v${version}/Changelog.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F ];
  };
}
