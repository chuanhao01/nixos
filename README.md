# NixOS Config?

Very WIP and TODO
Stuff is not organized and could change at anytime
Not all commits can be built
Also some run-time/stateful configs are needed as well

## Before building
In the `users/chuanhao01`
- chuanhao01's passwd
  - `mkpasswd > chuanhao01.passwd`
- ssh key to be used by github
  - Stored on the system and not tracked
  - `ssh-keygen -t ed25519 

sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage

