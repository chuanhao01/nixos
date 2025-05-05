{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "chuanhao01";
  home.homeDirectory = "/home/chuanhao01";

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "chuanhao01";
    userEmail = "34702921+chuanhao01@users.noreply.github.com";
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };
  wayland.windowManager.hyprland.settings = {
    "$mod" = "LALT";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
