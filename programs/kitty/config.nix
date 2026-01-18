{ config, pkgs, ... }:
{
  environment.systemPackages = [
    # ... other packages
    pkgs.kitty # required for the default Hyprland config
  ];
  fonts = {
    enableDefaultPackages = true; # Includes some common fonts
    packages = with pkgs; [
      # for MesloLGS NF specifically, if you want to be more selective:
      nerd-fonts.meslo-lg
      # It's good to also include a general emoji font if you want good emoji support
      noto-fonts-emoji
    ];
    fontconfig = {
      enable = true;
      # You might want to define default monospace fonts here as well
      defaultFonts = {
        monospace = [ "MesloLGS NF" ]; # This sets it as a default fallback for monospace
      };
    };
  };

}
