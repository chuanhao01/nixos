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
            myriad-dreamin.tinymist

            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh

            yzhang.markdown-all-in-one
            redhat.vscode-yaml
            tamasfe.even-better-toml

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
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              charliermarsh.ruff

              ms-python.python
              ms-python.debugpy
              ms-python.vscode-pylance
              ms-python.vscode-python-envs
            ]);
          # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          #   {
          #     name = "vscode-python-envs";
          #     publisher = "ms-python";
          #     version = "1.34.0";
          #     sha256 = "sha256-K8/xr4Oede+W/dvBWzUS/miQrFOHluz3ic6D4AhYurY=";
          #   }
          # ];

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/py/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/py/keybindings.json";
        };
        rust = {
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              rust-lang.rust-analyzer
            ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/rust/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/rust/keybindings.json";
        };
        js = {
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              bradlc.vscode-tailwindcss
            ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/js/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/js/keybindings.json";
        };
        java = {
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              vscjava.vscode-java-pack
              vscjava.vscode-maven
              vscjava.vscode-gradle
              vscjava.vscode-java-debug
              vscjava.vscode-java-test
              redhat.java
              vscjava.vscode-java-dependency
              oracle.oracle-java
            ])
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "vscode-checkstyle";
                publisher = "shengchen";
                version = "1.4.2";
                sha256 = "sha256-IchgQX9CUQ53puLu0ll8zNl6EzSnVDBj7tTUo5NzZjA=";
              }
            ];

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/keybindings.json";
        };
        dendron = {
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              dendron.dendron
            ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/keybindings.json";
        };
        cpp = {
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              # Python as well
              charliermarsh.ruff

              ms-python.python
              ms-python.debugpy
              ms-python.vscode-pylance
              ms-python.vscode-python-envs

              ms-vscode.cpptools
              ms-vscode.cmake-tools
            ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/dendron/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/dendron/keybindings.json";
        };
        rust-tauri = {
          extensions =
            baseExtensions
            ++ (with pkgs.vscode-extensions; [
              rust-lang.rust-analyzer
              tauri-apps.tauri-vscode
              bradlc.vscode-tailwindcss
            ]);

          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/rust/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/rust/keybindings.json";
        };
      };

  };
  programs.zsh.shellAliases = {
    code-py = "code --profile 'python'";
    code-rust = "code --profile 'rust'";
    code-js = "code --profile 'js'";
    code-java = "code --profile 'java'";
    code-dendron = "code --profile 'dendron'";
    code-cpp = "code --profile 'cpp'";
    code-rust-tauri = "code --profile 'rust-tauri'";
  };
}
