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

    # Other Kitty settings, like theme:
    # theme = "Catppuccin-Macchiato"; # If you're using a theme
  };


}
