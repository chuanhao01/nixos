.PHONY: default
default: help

.PHONY: rebuild
rebuild:
	sudo nixos-rebuild switch

.PHONY: link-machine-dotfiles
link-machine-dotfiles:
	ln -s ${PWD}/machine-dotfiles ${HOME}/.machine-dotfiles

.PHONY: link-nixos
link-nixos:
	sudo ln -s ${PWD} /etc/nixos

.PHONY: pull-submodules
pull-submodules:
	git submodules update --init --recursive

.PHONY: help
help:
	@echo 'Help'
