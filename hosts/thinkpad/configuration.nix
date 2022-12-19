{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    checkReversePath = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+awesome";
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks
        vicious
      ];
    };
    libinput.enable = true;
  };

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak-alt-intl";
  services.xserver.displayManager.sessionCommands =
    "${pkgs.xorg.xmodmap}/bin/xmodmap ${pkgs.writeText  "xkb-layout" ''
            keycode 108 = Mode_switch
            keycode  94 = Shift_L NoSymbol Shift_L
            keysym a = a A adiaeresis Adiaeresis
            keysym o = o O odiaeresis Odiaeresis
            keysym u = u U udiaeresis Udiaeresis
            keysym s = s S ssharp
        ''}";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  environment.variables = { EDITOR = "vim"; };

  # enable polkit
  security.polkit.enable = true;


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [ ];
      };
      vimrcConfig.customRC = ''

                    " basic commands bound to uppercase key
                    command Q q
                    command W w
                    command Wq wq
                    command WQ wq
                    
                    set number relativenumber
                    set tabstop=4
                    set shiftwidth=4
                    set smartcase
                    set colorcolumn=120
                    set nowrap
                    syntax on
                    highlight ColorColumn ctermbg=darkgray
                    
                    nnoremap ; :
                    nnoremap : ;
                    vnoremap ; :
                    vnoremap : ;
                    
                    " set space as leader
                    nnoremap <SPACE> <Nop>
                    let mapleader = " "
                    
                    
                    " beautify indents
                    :set list lcs=tab:\|\ 
                    
                    "remove ex-mode shortcut
                    nmap Q <Nop>
                    
                    " quickfixlist binds
                    nnoremap <C-j> :cnext<CR>
                    nnoremap <C-k> :cprev<CR>
                    
                    " locallist binds
                    nnoremap <C-l> :lnext<CR>
                    nnoremap <C-h> :lprev<CR>
                    
                    " split keybinds
                    nnoremap <leader>s :sp<CR>
                    nnoremap <leader>v :vs<CR>
                    
                    nnoremap <leader>h <C-w>h
                    nnoremap <leader>j <C-w>j
                    nnoremap <leader>k <C-w>k
                    nnoremap <leader>l <C-w>l
            '';
    }
    )
    # essentials
    wget
    git
    gcc
    htop
    tmux
    dig
    traceroute
    killall
    xorg.xmodmap
    # dev
    jdk
    maven
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  # List services that you want to enable:
  services.blueman.enable = true;
  services.devmon.enable = true;
  services.pcscd.enable = true; # yubikey and smartcard stuff
  services.printing.enable = true;
  services.fprintd.enable = true;

  # Automatically configure displays
  services.autorandr.enable = true;

  programs.steam.enable = true; # putting steam in here since home manager weirdly complains about it
  programs.kdeconnect.enable = true; # same as above

  services.udev.packages = [ pkgs.yubikey-personalization ];

  virtualisation.libvirtd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

