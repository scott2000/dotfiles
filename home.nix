{
  config,
  pkgs,
  self,
  jujutsu-latest,
  vim-jjdescription,
  ...
}:
let
  vim-jjdescription-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-jjdescription";
    src = vim-jjdescription;
  };
  gnome-extensions = with pkgs.gnomeExtensions; [ appindicator ];
in
{
  # TODO: remove when citrix_workspace is updated
  nixpkgs.config.permittedInsecurePackages = [
    "libsoup-2.74.3"
    "libxml2-2.13.8"
  ];

  home.username = "scott";
  home.homeDirectory = "/home/scott";

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:escape" ];
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = builtins.map (ext: ext.extensionUuid) gnome-extensions;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  home.packages =
    (with pkgs; [
      anki-bin
      bat
      citrix_workspace
      difftastic
      discord
      dua
      erlang
      erlang-ls
      fd
      fzf
      gcc
      ghc
      gleam
      gnumake
      inkscape
      jq
      jujutsu-latest.packages.${pkgs.system}.jujutsu
      libreoffice
      megasync
      mergiraf
      nixd
      nodejs_22
      python3
      ripgrep
      rustup
      signal-desktop
      spotify
      vscode
      xclip # Required for neovim clipboard
      zip
      zoom-us
    ])
    ++ gnome-extensions;

  xdg.configFile = {
    "ghostty/config".source = ./config/ghostty/config;
    "jj/config.toml".source = ./config/jj/config.toml;
  };

  home.file = {
    # Required to have correct cursor in some applications
    ".icons/default/index.theme".text = ''
      [icon theme]
      Inherits=Adwaita
    '';
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
        warn_timeout = "0s"; # Disable warning
      };
    };

    firefox.enable = true;

    fish = {
      enable = true;
      functions = {
        fish_greeting = ''
          ${./update-reminder.fish}
        '';
        fish_prompt = ''
          set -l last_status $status
          if test -n "$SHLVL" && test "$SHLVL" -gt 1
            set_color $fish_color_param
            echo -n "[$SHLVL] "
          end
          if test $last_status -eq 0
            set_color green
          else if test $last_status -eq 141
            set_color yellow
          else
            set_color brred
          end
          echo -n (basename $PWD)
          if test -d .jj
            set_color brblack
            jj log --quiet --no-pager --color=never --ignore-working-copy \
              --no-graph -r 'present(@ & (@- & mutable())+)' \
              -T 'parents.map(|p| "/" ++ p.change_id().shortest(3)).join("")'
          end
          set_color normal
          echo -n ' $ '
        '';
        dotfiles-update = ''
          cd ~/dotfiles
          echo "Updating channel..."
          sudo nix-channel --update
          echo "Updating flake..."
          nix flake update
          echo "Switching NixOS..."
          os-switch
          echo "Switching home-manager..."
          hm-switch
          echo "Showing status..."
          jj st
          echo "Remember to commit these changes!"
        '';
        os-switch = "sudo nixos-rebuild switch --flake ~/dotfiles";
        hm-switch = "home-manager switch --flake ~/dotfiles";
        hm-news = "home-manager news --flake ~/dotfiles";
        vimdiff = "nvim -d $argv";
      };
    };

    ghostty.enable = true;

    git = {
      enable = true;
      userName = "Scott Taylor";
      userEmail = "scott11x8@gmail.com";
      ignores = [
        "*~"
        "*.swp"
        ".direnv"
        ".envrc"
        "_i" # Directory for temporary files
      ];
    };

    gpg.enable = true;

    home-manager.enable = true;

    java.enable = true;

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
        source ${./config/nvim/init.vim}

        " Wait to enable theme until plugins loaded
        augroup nixinitgroup
          autocmd!
          autocmd VimEnter * colorscheme PaperColor
        augroup END
      '';
      viAlias = true;
      vimAlias = true;
    };

    zed-editor = {
      enable = true;
      extensions = [
        "erlang"
        "gleam"
        "html"
        "make"
        "nix"
        "proto"
        "toml"
      ];
      userSettings = builtins.fromJSON (builtins.readFile ./config/zed/settings.json);
      userKeymaps = builtins.fromJSON (builtins.readFile ./config/zed/keymap.json);
    };
  };

  # Enable home-manager garbage collection
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
    timestamp = "-10 days";
  };

  # Start megasync automatically
  services.megasync.enable = true;
  systemd.user.services.megasync = {
    # Need to add sleep, otherwise it crashes
    Service.ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
