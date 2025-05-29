{ config, pkgs, ... }:

let
  programsRoot = ../../programs;
in
{

  imports = [
    "${programsRoot}/git/home.nix"
    "${programsRoot}/nvim/home.nix"
    "${programsRoot}/zsh/home.nix"
  ];

  home.username = "chuanhao01";
  home.homeDirectory = "/home/chuanhao01";

  # Building off git imported from programs
  programs.git = {
    userName = "chuanhao01";
    userEmail = "34702921+chuanhao01@users.noreply.github.com";
    extraConfig = {
      core = {
        editor = "nvim";
      };
      diff = {
        tool = "vimdiff";
      };
      difftool = {
        prompt = false;
        trustExitCode = true;
      };
      difftool."vimdiff" = {
        path = "nvim";
      };
    };
    includes = [
      { path = "~/.machine-dotfiles/git/gitconfig"; }
    ];
  };

  programs.zsh.oh-my-zsh = {
    custom = "$HOME/.machine-dotfiles/zsh";
    theme = "powerlevel10k/powerlevel10k";
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  services.ssh-agent.enable = true;
  programs.ssh = {
    enable = true;
    addKeysToAgent = "1h"; # or "ask" for confirmation
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
