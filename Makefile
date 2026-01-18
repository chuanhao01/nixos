.PHONY: default
default: help

.PHONY: yoga-730
yoga-730:
	sudo nixos-rebuild switch --flake "./#nixos-yoga-730"

.PHONY: link-machine-dotfiles
link-machine-dotfiles:
	ln -s ${PWD}/machine-dotfiles ${HOME}/.machine-dotfiles

.PHONY: link-nixos
link-nixos:
	sudo ln -s ${PWD} /etc/nixos

.PHONY: pull-submodule
pull-submodule:
	git submodule update --init --recursive

.PHONY: help
help:
	@echo 'Help'
