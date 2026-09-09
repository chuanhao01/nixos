# For nvidia to work on the yoga-730 specifically
{
  config,
  pkgs,
  programsRoot,
  ...
}:
{

  imports = [
    "${programsRoot}/nvidia/config.nix"
  ];

  hardware = {
    graphics = {
      enable = true;
    };

    enableRedistributableFirmware = true;

    nvidia = {
      # Modesetting is required for PRIME offload
      modesetting.enable = true;

      # MUST be false for GTX 1050 (Pascal series does not support the open driver)
      open = false;
      # MUST be false for GTX 1050 (Turing or newer required for fine-grained PM)
      powerManagement.finegrained = false;
      powerManagement.enable = true;
      nvidiaSettings = true;
      # Select standard proprietary driver package
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
      # package = config.boot.kernelPackages.nvidiaPackages.beta;
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;

      # --- CRITICAL FOR LAPTOPS: PRIME Configuration ---
      # Replace these Bus IDs with the ones obtained from `lspci | grep -E 'VGA|3D'`
      prime = {
        # Or if you want NVIDIA-only mode (muxless/discrete mode):
        sync.enable = true;

        intelBusId = "PCI:0:2:0"; # Change to your Intel/AMD integrated GPU bus ID
        nvidiaBusId = "PCI:58:0:0"; # Change to your NVIDIA GPU bus ID
      };

    };
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  services.xserver.config = ''
  Section "Device"
      Identifier "Integrated Graphics"
      Driver     "modesetting"
      Option     "PrimaryGPU" "yes"
  EndSection
  '';

  boot.blacklistedKernelModules = [ "nouveau" ];

}
