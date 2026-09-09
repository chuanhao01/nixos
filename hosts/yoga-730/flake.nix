{
  usersRoot,
  programsRoot,
  inputs,
}:

let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
{
  inherit system;

  # To allow for passing down args
  specialArgs = {
    inherit usersRoot programsRoot inputs;
  };

  modules = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          ./hardware-configuration.nix
          # base configuration to be extended by all hosts
          ../base_configuration.nix
          # users
          "${usersRoot}/chuanhao01/config.nix"
          # programs
          "${programsRoot}/docker/config.nix"
          "${programsRoot}/tailscale/config.nix"

          "${programsRoot}/qtile/config.nix"
          "${programsRoot}/kitty/config.nix"
          "${programsRoot}/rofi/config.nix"
          "${programsRoot}/kanata/config.nix"

          "${programsRoot}/hyprland/config.nix"

          ./config.nix
          ./nvidia.nix
          ./pi.nix
        ];

        # Hostname
        networking.hostName = "nixos-yoga-730"; # Define your hostname.

        #Enable wifi hardware firmware
        hardware.enableRedistributableFirmware = true;

        # Enable touchpad support (enabled default in most desktopManager).
        services.libinput.enable = true;

        # Tailscale to allow for subnet routing and exit nodes
        services.tailscale.useRoutingFeatures = "both";

        # Ignore closing the lid of the laptop to do anything
        services.logind.settings = {
          Login = {
            IdleAction = "ignore";
            HandleLidSwitch = "ignore";
            HandleLidSwitchExternalPower = "ignore";
          };
        };

        users.users.chuanhao01 = {
          extraGroups = [
            "wheel"
            "video"
            "input"
            "render"
          ];
        };
      }
    )

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.chuanhao01 = {
        imports = [
          "${usersRoot}/chuanhao01/home.nix"

          "${programsRoot}/qtile/home.nix"
          "${programsRoot}/kitty/home.nix"
          "${programsRoot}/rofi/home.nix"

          "${programsRoot}/hyprland/home.nix"
        ];
      };
    }
  ];
}
