HOST_SHORT:=$(shell hostname | cut -f 1 -d '.' | tr '[:upper:]' '[:lower:]')
HOME_PACKAGE=home-$(HOST_SHORT)
NIX_FLAGS=--print-build-logs --show-trace --verbose
NIXOS_NAME=$(HOST_SHORT)

.PHONY: build
build: build/nixos build/home

.PHONY: build/darwin
build/darwin: HOSTNAME=$(shell hostname | tr '[:upper:]' '[:lower:]')
build/darwin:
	nix $(NIX_FLAGS) build ".#darwinConfigurations.\"${HOSTNAME}\".config.system.build.toplevel"

.PHONY: build/nixos
build/nixos:
	nix $(NIX_FLAGS) build ".#nixosConfigurations.$(NIXOS_NAME).config.system.build.toplevel"

.PHONY: build/home
build/home:
	nix $(NIX_FLAGS) build --keep-going ".#${HOME_PACKAGE}"

.PHONY: nixos/%
nixos/%: SUBCOMMAND=$(@F)
nixos/%: build/nixos
	sudo nixos-rebuild $(SUBCOMMAND) --flake . --verbose --keep-going --show-trace

.PHONY: switch/home
switch/home: build/home
	./result/activate

.PHONY: gcroot
gcroot:
	nix $(NIX_FLAGS) build ".#gcroot"

.PHONY: repl
repl:
	nix repl ./repl.nix
