{ config, pkgs, ... }:
{

  programs.vscode = {
    enable = true;
    profiles =
      let
        profileBaseDir = "${config.home.homeDirectory}/.machine-dotfiles/vscode/profiles";
        baseExtensions =
          with pkgs.vscode-extensions;
          [
            pkief.material-icon-theme

            vscodevim.vim
            eamodio.gitlens

            mkhl.direnv
            jnoortheen.nix-ide

            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh

            yzhang.markdown-all-in-one

            esbenp.prettier-vscode
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "oceanic-plus";
              publisher = "marcoms";
              version = "2.0.0";
              sha256 = "sha256-ajvZ6rH/j5P5yDKvLWPHrDLx1D2d9Gp7oKfQRCzEcuw=";
            }
          ];
      in
      {
        default = {
          extensions = baseExtensions;

          # I don't really like this, but oh well it works
          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/keybindings.json";
        };
        python = {
          extensions = baseExtensions ++ (with pkgs.vscode-extensions; [
            redhat.vscode-yaml
            charliermarsh.ruff

            ms-python.python
            ms-python.debugpy
            ms-python.vscode-pylance
          ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-python-envs";
              publisher = "ms-python";
              version = "1.10.0";
              sha256 = "sha256-fhrV9sPjgwp1+ZDMu7iU7To2R0hcAF388w99yCMiHQA=";
            }
          ];

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/py/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/py/keybindings.json";
        };
        rust = {
          extensions = baseExtensions ++ (with pkgs.vscode-extensions; [
            rust-lang.rust-analyzer
            tamasfe.even-better-toml
            redhat.vscode-yaml
          ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/rust/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/rust/keybindings.json";
        };
        js = {
          extensions = baseExtensions ++ (with pkgs.vscode-extensions; [
            tamasfe.even-better-toml
            redhat.vscode-yaml
            bradlc.vscode-tailwindcss
          ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/js/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/js/keybindings.json";
        };
      };

  };
}
