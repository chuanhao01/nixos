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
    xrandr

    xclip # to allow manipulating the xclipboard
    feh # to view images and video
    imagemagick # for image and import
  ];

  # Ports to allow VNC traffic through
  networking.firewall.allowedTCPPorts = [ 5900 ];
}
