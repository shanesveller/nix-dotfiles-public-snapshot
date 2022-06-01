cachix_name := "shanesveller"

host_short := lowercase(`hostname -s`)
home_package := ".#home-" + host_short

nix_flags := "--print-build-logs --show-trace --verbose"
nix_build_flags := "--keep-going"
darwin_flags := "--flake ."
nixos_flags := "--flake . --use-remote-sudo"

os_command := if os() == "macos" {
  "darwin-rebuild"
} else if os() == "linux" {
  "nixos-rebuild"
} else {
  "unknown"
}
os_config := if os() == "macos" {
  ".#darwinConfigurations.\"" + host_short + "\".config.system.build.toplevel"
} else if os() == "linux" {
  ".#nixosConfigurations.\"" + host_short + "\".config.system.build.toplevel"
} else {
  ".#unknown"
}

default: build

boot: (switch-nixos "boot")

build: build-all

build-all:
	nix {{ nix_flags }} build {{ nix_build_flags }} {{ os_config }} {{ home_package }}

build-os:
	nix {{ nix_flags }} build {{ nix_build_flags }} --out-link result-os {{ os_config }}

build-home:
	nix {{ nix_flags }} build {{ nix_build_flags }} --out-link result-home {{ home_package }}

build-local:
  nix {{ nix_flags }} build {{ nix_build_flags }} --out-link result-local .#localPackages

cache: build-local
  cachix --verbose push {{ cachix_name }} ./result-local
  rm result-local

clean:
	rm -v ./result*

gcroot:
	nix {{ nix_flags }} build {{ nix_build_flags }} --out-link result-gcroot ".#gcroot"

repl:
	nix repl ./repl.nix

switch-darwin: build-os
	{{ os_command }} switch {{ darwin_flags }}

switch-home: build-home
	./result-home/activate

switch-nixos subcommand *flags: build-os
	{{ os_command }} {{subcommand }} {{ nixos_flags }} {{ flags }}

tree: gcroot
  nix-tree ./result-gcroot
