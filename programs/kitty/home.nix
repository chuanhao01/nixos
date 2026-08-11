{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    # Basic font settings
    font = {
      name = "MesloLGS NF";

      # Set font size
      size = 10; # Adjust to your preference
    };

    settings = {
      enable_audio_bell = false;
    };
  };
}
