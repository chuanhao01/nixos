{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    # With git installed, gpg is also automatically installed for gpg to work in git
    gnupg
  ];
}
