{ config, pkgs, ... }:

{
  # we copy the file over to then link to it in the gitconfig
  xdg.configFile."git/gitcommitmessage".source = ./configs/gitcommitmessage;
  programs.git = {
    enable = true;
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
      core = {
        pager = "less -X";
      };
      pull = {
        rebase = false;
      };
      gpg = {
        program = "gpg";
      };
      commit = {
        template = "~/.config/git/gitcommitmessage";
      };
    };
  };
}
