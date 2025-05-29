{ config, pkgs, ... }:

let
  programsRoot = ../../programs;
in
{

  imports = [
    "${programsRoot}/base-config.nix"
    "${programsRoot}/git/config.nix"
    "${programsRoot}/nvim/config.nix"
    "${programsRoot}/vifm/config.nix"
    "${programsRoot}/tmux/config.nix"
    "${programsRoot}/vscode/config.nix"
    "${programsRoot}/zsh/config.nix"
  ];

  environment.systemPackages = with pkgs; [
    # --- zsh ---
    # General font used for anything terminal related
    meslo-lgs-nf
  ];

  # user account
  users.users.chuanhao01 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    # read from /etc that is symlinked, so no issues
    hashedPasswordFile = "/etc/nixos/users/chuanhao01/chuanhao01.passwd";
    shell = pkgs.zsh;
  };

}
