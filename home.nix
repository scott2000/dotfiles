{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  home.username = "scott";
  home.homeDirectory = "/home/scott";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.megasync

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  xdg.configFile = {
    "jj/config.toml".source = ./jjconfig.toml;
  };

  home.file = {};

  home.sessionVariables = {};

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -g fish_greeting
    '';
    interactiveShellInit = ''
      jj util completion fish | source
    '';
    functions = {
      fish_prompt = ''
        set_color $fish_color_cwd
        echo -n (basename $PWD)
        set_color normal
        echo -n ' $ '
      '';
      hm-switch = "home-manager switch --flake ~/dotfiles";
      vim = "nvim $argv";
      vimdiff = "nvim -d $argv";
    };
  };

  programs.git = {
    enable = true;
    userName = "Scott Taylor";
    userEmail = "scott11x8@gmail.com";
  };

  programs.jujutsu.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      shell = "${pkgs.fish}/bin/fish";
    };
  };
}
