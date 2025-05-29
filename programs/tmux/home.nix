{ config, pkgs, ... }:
{
  programs.tmux.enable = true;
  # Copying over oh-my-tmux/.tmux files
  xdg.configFile."tmux/tmux.conf".source = ./.tmux/.tmux.conf;
  xdg.configFile."tmux/tmux.conf.local".source = ./.tmux.conf.local;
}
