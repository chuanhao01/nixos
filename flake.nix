{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    usersRoot = "${self}/users";
    programsRoot = "${self}/programs";
  in {
    nixosConfigurations.nixos-dev-vm = nixpkgs.lib.nixosSystem (
      import ./hosts/nixos-dev-vm/flake.nix { inherit usersRoot programsRoot inputs; }
    );
  };
}
