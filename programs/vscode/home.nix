{ config, pkgs, ... }:
{

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    profiles =
      let
        profileBaseDir = "${config.home.homeDirectory}/.machine-dotfiles/vscode/profiles";
      in
      {
        default = {
          extensions = with pkgs.vscode-extensions; [
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh

            vscodevim.vim
            yzhang.markdown-all-in-one
            pkief.material-icon-theme
            esbenp.prettier-vscode

            mkhl.direnv
            eamodio.gitlens
          ];
          # ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          #   {
          #     name = "oceanic-plus";
          #     publisher = "marcoms";
          #     version = "	1.4.0";
          #     # sha256 = "sha256-ajvZ6rH/j5P5yDKvLWPHrDLx1D2d9Gp7oKfQRCzEcuw=";
          #   }
          # ];
          # TODO: Fix so this gets downloaded

          # I don't really like this, but oh well it works
          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/keybindings.json";
        };
        work-pi = {
          extensions = with pkgs.vscode-extensions; [
            ms-azuretools.vscode-docker
            ms-vscode-remote.remote-ssh

            vscodevim.vim
            yzhang.markdown-all-in-one
            pkief.material-icon-theme
            esbenp.prettier-vscode
          ];
          userSettings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/settings.json";
          keybindings = config.lib.file.mkOutOfStoreSymlink "${profileBaseDir}/default/keybindings.json";
        };
      };
  };
}
