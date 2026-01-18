# Adapted from https://github.com/shyonae/nixos-main-config/blob/main/modules%2Fsystem%2Fnvidia.nix
# From: https://www.reddit.com/r/NixOS/comments/1ep0aid/nvidia_and_cuda_drivers_on_nixos/
# NOTES:
# Seems like this is not that well documented in the nixos ecosystem
# But it looks like you only really need like 3 settings to enable the nvidia drives and use nvidia as the kernal modules
# Also, nvidia-smi should work even without the CUDA installed yet, as that should be done per project
# References:
# https://wiki.nixos.org/wiki/CUDA#Setting_up_CUDA_Binary_Cache
# https://nixos.wiki/wiki/Nvidia#CUDA

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nvidia.enable = lib.mkEnableOption "enables nvidia options";
  };

  config = lib.mkIf config.nvidia.enable {
    # Enable cache for bin and faster for nvidia
    nix.settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.nvidia.acceptLicense = true;

    hardware = {
      graphics = {
        enable = true;
      };

      enableRedistributableFirmware = true;

      nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = true;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [
      "nvidia"
    ];

    boot.blacklistedKernelModules = [ "nouveau" ];
  };
}
