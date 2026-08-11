{ config, pkgs, ... }:
{
  xdg.configFile."qtile" = {
    source = ./config;
    recursive = true;
  };
  # Use home-manager to configure .xinit for start
  xsession = {
    enable = true;
    scriptPath = ".xinitrc"; # Generates ~/.xinitrc specifically

    # Commands added to your xsession launch
    # xset to prevent monitor from turning off
    initExtra = ''
      blueman-applet &
      xset s off -dpms &
    '';

    windowManager.command = "exec qtile start";
  };

  # Since qtile expects these dirs to exist
  home.activation.createCustomDirs = pkgs.lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p $HOME/Development
    $DRY_RUN_CMD mkdir -p $HOME/Pictures/Screenshots
  '';
}
