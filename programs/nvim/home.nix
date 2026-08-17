{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set shiftwidth=2 smarttab
      set expandtab
      set tabstop=4 softtabstop=0
      set nu rnu
    '';
    withRuby = true;
    withPython3 = true;
  };
  # EDITOR env var
  home.sessionVariables.EDITOR = "nvim";
}
