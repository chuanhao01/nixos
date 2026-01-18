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
        ];

        # Hostname
        networking.hostName = "nixos-yoga-730"; # Define your hostname.

        #Enable wifi hardware firmware
        hardware.enableRedistributableFirmware = true;

        # Enable touchpad support (enabled default in most desktopManager).
        services.libinput.enable = true;

        # Tailscale to allow for subnet routing and exit nodes
        services.tailscale.useRoutingFeatures = "both";

      }
    )

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.chuanhao01 = {
        imports = [
          "${usersRoot}/chuanhao01/home.nix"
        ];
      };
    }
  ];
}
