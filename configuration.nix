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
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    pkgs.gnomeExtensions.workspace-matrix
    pkgs.gnomeExtensions.dash-to-dock
    docker-compose
    (python311.withPackages(ps: with ps; [
      toml
      python-lsp-server
      pyls-isort
      flake8
      yapf
      autoflake
      tomli
    ]))
    pkgs.telegram-desktop
    pkgs.zellij
    pkgs.kitty
    poetry
    pkgs.python311Packages.pip
    pkgs.deluge
    pkgs.vlc
    pkgs.insomnia
    pkgs.discord
    pkgs.just
    pkgs.sbcl
    pkgs.slack
    pkgs.gnumake
    pkgs.direnv
    pkgs.whatsapp-for-linux
    pkgs.fragments
    pkgs.brave
    pkgs.google-chrome

    # emacs and doom stuff
    pkgs.emacs
    pkgs.ripgrep
    pkgs.fd
    pkgs.multimarkdown
    pkgs.shellcheck
    
    pkgs.firefox
    pkgs.vivaldi
    pkgs.git
    pkgs.htop
    pkgs.gnome.gnome-tweaks
    pkgs.beekeeper-studio
    # pkgs.asusctl
    # pkgs.supergfxctl
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

  home-manager.users.harm = { pkgs, ... }: {
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    home.packages = [
      pkgs.atool
      pkgs.httpie
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
          rebuild-switch = "sudo nixos-rebuild switch -I ~/projects/nixos/configuration.nix";
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
    };
  };

}
