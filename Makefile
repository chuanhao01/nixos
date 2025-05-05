.PHONY: default
default: help

.PHONY: rebuild
rebuild:
	sudo nixos-rebuild switch 


.PHONY: help
help:
	@echo 'Help'
