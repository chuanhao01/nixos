# NixOS Config?

Very WIP and TODO  
Stuff is not organized and could change at anytime  
Not all commits can be built  
Also some run-time/stateful configs are needed as well  

If you are using the hosts config and users  
You should get a working system with my dotfiles installed (mostly beside host customized configs)  

## Before building

In the `users/chuanhao01`

- chuanhao01's passwd
  - `mkpasswd > chuanhao01.passwd`
- pulling all submodules
  - `make pull-submodules`
- machine-dotfiles linking
  - `make link-machine-dotfiles`
- ssh keys to be used by github
  - Stored on the system and not tracked
  - `ssh-keygen -t ed25519`

## Helpful Commands

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system # Listing gens
sudo nix-collect-garbage # Removing unused store links
sudo nix-collect-garbage -d # Removing unused generations
```
