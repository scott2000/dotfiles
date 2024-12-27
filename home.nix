{
  config,
  pkgs,
  self,
  jujutsu-latest,
  ghostty,
  vim-jjdescription,
  ...
}:
let
  vim-jjdescription-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "vim-jjdescription";
    src = vim-jjdescription;
  };
  gnome-extensions = with pkgs.gnomeExtensions; [ appindicator ];
  # Use new fish completions
  jujutsu-override = jujutsu-latest.packages.${pkgs.system}.jujutsu.overrideAttrs (
    { postInstall, ... }:
    {
      postInstall =
        postInstall
        + ''
          installShellCompletion --cmd jj \
            --bash <(echo 'source <(COMPLETE=bash jj)') \
            --fish <(echo 'source (COMPLETE=fish jj | psub)')
        '';
    }
  );
in
{
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
      fd
      fzf
      gcc
      ghc
      ghostty.packages.${pkgs.system}.ghostty
      gnumake
      inkscape
      jq
      jujutsu-override
      libreoffice
      megasync
      mergiraf
      nixd
      nodejs_22
      python3
      ripgrep
      rustup
      self.packages.${pkgs.system}.zoom-us-old
      signal-desktop
      spotify
      vscode
      xclip # Required for neovim clipboard
      zip
    ])
    ++ gnome-extensions;

  xdg.configFile = {
    "ghostty/config".source = ./config/ghostty/config;
    "jj/config.toml".source = ./config/jj/config.toml;
  };

  home.file = {
    # Required to have correct cursor in Alacritty
    ".icons/default/index.theme".text = ''
      [icon theme]
      Inherits=Adwaita
    '';
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        terminal.shell = "${pkgs.fish}/bin/fish";
        env = {
          SHLVL = "0";
        };
        window = {
          dimensions.columns = 120;
          dimensions.lines = 36;
          padding.x = 3;
          padding.y = 3;
        };
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
          set_color normal
          echo -n ' $ '
        '';
        dotfiles-update = ''
          cd ~/dotfiles
          echo "Updating channel..."
          sudo nix-channel --update
          echo "Updating flake..."
          nix flake update
          os-switch
          hm-switch
          echo "Showing status..."
          jj st
          echo "Remember to commit these changes!"
        '';
        os-switch = ''
          echo "Switching NixOS..."
          sudo nixos-rebuild switch --flake ~/dotfiles
        '';
        hm-switch = ''
          echo "Removing old profiles..."
          nix profile wipe-history --older-than 7d
          echo "Switching home-manager..."
          home-manager switch --flake ~/dotfiles
        '';
        vimdiff = "nvim -d $argv";
      };
    };

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
