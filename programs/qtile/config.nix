{ config, pkgs, ... }:
{
  services.xserver.windowManager.qtile.enable = true;
  services.xserver = {
    enable = true;
    # Because I don't really need a displaymanager
    displayManager = {
      startx.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    /**
      Using any vnc solution kinda sucks, better to use vscode over ssh
      But its better to have it than nothing
    */
    turbovnc
    x11vnc
    /**
      If I ever need a better remote vnc solution with internet access ig
    */
    # anydesk
    # xorg.xvfb
    xorg.xrandr
  ];

  # Ports to allow VNC traffic through
  networking.firewall.allowedTCPPorts = [ 5900 ];
}
