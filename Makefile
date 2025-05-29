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

.PHONY: help
help:
	@echo 'Help'
