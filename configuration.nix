# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nix.nixPath = [
    "nixos-config=/home/harm/projects/nixos/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    xkbOptions = "ctrl:nocaps";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.harm = {
    isNormalUser = true;
    description = "Harm";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.gnome.gnome-tweaks
    pkgs.gnomeExtensions.workspace-matrix
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.deluge
    pkgs.fragments
    pkgs.vlc
    pkgs.insomnia
    pkgs.discord
    pkgs.slack
    pkgs.whatsapp-for-linux
    pkgs.telegram-desktop
    pkgs.brave
    pkgs.google-chrome
    pkgs.firefox
    pkgs.vivaldi
    # pkgs.asusctl
    # pkgs.supergfxctl

    # developtment
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    docker-compose
    pkgs.zellij
    pkgs.kitty
    pkgs.git
    pkgs.htop
    pkgs.beekeeper-studio
    pkgs.just
    pkgs.sbcl
    pkgs.gnumake
    pkgs.direnv
    pkgs.tree
    poetry
    pkgs.python311Packages.pip

    # LSP & Editor tools
    #
    # pkgs.additions.node-packages.prettier
    # pkgs.additions.node-packages."@prettier/plugin-xml"
    # pkgs.additions.node-packages."@astrojs/language-server"
    pkgs.nodePackages.typescript
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-json-languageserver
    pkgs.nodePackages.dockerfile-language-server-nodejs
    pkgs.nodePackages.yaml-language-server
    pkgs.nodePackages.vls
    pkgs.nodePackages.bash-language-server

    # web
    pkgs.jsbeautifier
    pkgs.html-tidy
    pkgs.stylelint
    # JSON layer
    pkgs.nodePackages.vscode-langservers-extracted
    # Python
    (python311.withPackages(ps: with ps; [
      toml
      python-lsp-server
      pyls-isort
      flake8
      yapf
      autoflake
      tomli
    ]))
    # Nix
    pkgs.rnix-lsp
    pkgs.alejandra
    # Other
    pkgs.sqls
    # Markdown layer
    pkgs.pandoc


    # emacs and doom stuff
    pkgs.emacs
    pkgs.ripgrep
    pkgs.fd
    pkgs.multimarkdown
    pkgs.shellcheck
    
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?


  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  nix.settings.experimental-features = [ "nix-command" "flakes"];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Allow non-sudo use of port 80 and higher
  boot.kernel.sysctl = {"net.ipv4.ip_unprivileged_port_start" = 80;};

  # Enable dnsmasq for .localhost resolving
  services.dnsmasq = {
    enable = true;
    settings = {
      server = ["10.0.20.2"];
      address = ["/.localhost/127.0.0.1" "/.inno/127.0.0.1"];
    };
  };


  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

  home-manager.users.harm = { pkgs, lib, ... }: {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    home.sessionPath = [ "$HOME/.config/emacs/bin" ];

    home.packages = [
      pkgs.rsync
      pkgs.ripgrep
    ];

    programs = {

      bash = {
        enable = true;
        shellAliases = {
          docker-compose = "docker compose";
          cdr = "cd (echo $DIRENV_DIR | string trim -c '-')";
          gpu = "git push --set-upstream origin (git branch --show-current)";
          rcp = "cd ~/work/repos/chatplatform-dev; direnv export fish | source; zellij --layout layout.kdl";
          consulto_start = ''
                   cd ~/projects/chatplatform-dev;
                   just up "$env"-fe;
                   zellij --layout "$layout";
                   docker stop $(docker ps -q);
                   just down
                '';
          spw = "export env='pw' layout='layout.kdl'; consulto_start";
          spv = "export env='pv' layout='layout.kdl'; consulto_start";
          svt = "export env='vt' layout='layout.kdl'; consulto_start";
          sspw = "export env='pw' layout='layout-small.kdl'; consulto_start";
          sspv = "export env='pv' layout='layout-small.kdl'; consulto_start";
          ssvt = "export env='vt' layout='layout-small.kdl'; consulto_start";
          sprod = "cd ~/projects/chatplatform-prod/ && zellij --layout layout.kdl";
          ssprod = "cd ~/projects/chatplatform-prod/ && zellij --layout layout-small.kdl";
          rebuild = "sudo nixos-rebuild switch";
        };
      };

      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };

      git = {
        enable = true;
        userName = "Harm";
        userEmail = "harmvaneekeren@gmail.com";
      };

    };


    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };
      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 4;
      };
      "org/gnome/shell/app-switcher" =  {
        current-workspace-only = true;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-type = "nothing";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///home/harm/projects/nixos/wallpaper.jpg";
        picture-uri-dark = "file:///home/harm/projects/nixos/wallpaper.jpg";
      };
      "org/gnome/desktop/session" = {
        idle-delay = lib.hm.gvariant.mkUint32 0;
      };
      "org/gnome/shell" = {
	      enabled-extensions = ["wsmatrix@martin.zurowietz.de" "dash-to-dock@micxgx.gmail.com"];
        disabled-extensions = [];
      };
      "org.gnome.shell.extensions.dash-to-dock" = {
        isolate-workspaces = true;
      };
    };



  };

}
