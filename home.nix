{ config, pkgs, vim-jjdescription, ... }:
let
  vim-jjdescription-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-jjdescription";
    src = vim-jjdescription;
  };
in
{
  nixpkgs.config.allowUnfree = true;

  home.username = "scott";
  home.homeDirectory = "/home/scott";

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:escape"];
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    anki
    bat
    difftastic
    fd
    fzf
    jq
    jujutsu
    megasync
    ripgrep
    signal-desktop
    spotify
    vscode
    zoom-us
  ];

  xdg.configFile = {
    "jj/config.toml".source = ./jjconfig.toml;
  };

  home.file = {};

  home.sessionVariables = {};

  programs = {
    alacritty = {
      enable = true;
      settings = {
        shell = "${pkgs.fish}/bin/fish";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
        warn_timeout = "0s"; # Disable warning
      };
    };

    fish = {
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
        vimdiff = "nvim -d $argv";
      };
    };

    git = {
      enable = true;
      userName = "Scott Taylor";
      userEmail = "scott11x8@gmail.com";
    };

    home-manager.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        papercolor-theme
        vim-argumentative
        vim-commentary
        vim-indent-object
        vim-javascript
        vim-jjdescription-plugin
        vim-jsx-pretty
        vim-nix
        vim-repeat
        vim-surround
      ];
      extraConfig = ''
        source ${./vimrc.vim}

        " Wait to enable theme until plugins loaded
        augroup nixinitgroup
          autocmd!
          autocmd VimEnter * colorscheme PaperColor
        augroup END
      '';
      viAlias = true;
      vimAlias = true;
    };
  };
}