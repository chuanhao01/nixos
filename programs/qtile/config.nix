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
    # virtualglLib
  ];

  # Ports to allow VNC traffic through
  networking.firewall.allowedTCPPorts = [ 5900 ];
  # systemd.services.headless-x11vnc = {
  #   description = "Headless x11vnc 1920x1080";
  #   after = [ "network.target" ]; # Adjust as needed
  #   wantedBy = [ "multi-user.target" ];
  #   path = [
  #     pkgs.x11vnc
  #   ];

  #   serviceConfig = {
  #     Type = "simple";
  #     User = "chuanhao01";
  #     Group = "users";
  #     Environment = [ "FD_GEOM=1920x1080" ]; # Set the display resolution
  #     ExecStart = ''
  #       ${pkgs.x11vnc}/bin/x11vnc -create -forever
  #     '';
  #     Restart = "on-failure";
  #     RestartSec = 5;
  #   };
  # };

}
