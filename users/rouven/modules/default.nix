{ config, pkgs, ... }:

{
  imports =
    [
      ./vifm
      ./alacritty
    ];
  home.username = "rouven";
  home.homeDirectory = "/home/rouven";

  home.packages = with pkgs; [
    # essentials
    alacritty
    networkmanagerapplet
    pcmanfm
    # vifm
    xsel
    lightlocker
    vlc

    # graphics
    lxappearance
    feh
    flameshot
    picom
    okular
    gimp

    # editing
    fzf
    powerline-fonts

    # sound
    pavucontrol

    # bluetooth
    blueman

    # internet
    thunderbird
    discord
    google-chrome
    nextcloud-client
    zoom-us

    # messaging
    tdesktop
    element-desktop
    whatsapp-for-linux

    # games
    minecraft
    superTuxKart
    extremetuxracer
    wine

    # yubikey and password stuff
    yubikey-manager
    yubikey-manager-qt
    yubioath-desktop
    pass

    # misc
    fzf
    neofetch
    trash-cli
    spotify
    plover.dev
    nixpkgs-fmt
    virt-manager

    # libs
    libyubikey
    libfido2
  ];

  # programs.light.enable = true; # display brightness manager
  # programs.kdeconnect.enable = true;
  programs.git = {
    enable = true;
    userName = "Rouven Seifert";
    userEmail = "rouven@rfive.de";
    extraConfig = {
      user.signingkey = "B95E8FE6B11C4D09";
      pull.rebase = false;
      init.defaultBranch = "main";
      commit.gpgsign = true;
    };

  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      rm = "trash";
      vifm = "vifm .";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    oh-my-zsh = {
      enable = true;
      # plugins = [ "zsh-autosuggestions" "fzf-tab"  ];
      theme = "agnoster";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "14f66e4d3d0b366552c0412eb08ca9e0f7c797bd";
          sha256 = "YkfHPSuSKParz7JidR924CJSuXO6Rk0RZTlxPOBwLJk=";
        };
      }
    ];

    localVariables = {
      COMPLETION_WAITING_DOTS = "true";
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=#00bbbb,bold";
      # ZSH_AUTOSUGGEST_STRATEGY="(history completion)";
    };

    initExtra =
      ''
        function c() {
            cd
            if [ $# -eq 0 ]; then
                cd $(find -maxdepth 4 -not -path '*[cC]ache*' -not -path '*[tT]rash*' -type d | fzf --preview 'tree -C {}')
            else
                $1 $(find -maxdepth 5 -not -path '*[cC]ache*' -not -path '*[tT]rash*' | fzf --preview 'tree -C {}')
            fi
        }
 
        function sn() {
            nmcli connection up $(nmcli connection show | tail -n +2 | cut -d " " -f1 | fzf --preview 'nmcli connection show {}')
        }
 
        prompt_dir() {
            prompt_segment blue $CURRENT_FG '%c'
        }
      '';
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    clock24 = true;
    extraConfig =
      ''
        set -g default-shell /etc/profiles/per-user/rouven/bin/zsh
        bind P display-popup
      '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-fahrenheit false
          set -g @dracula-plugins "weather time"
          set -g @dracula-show-left-icon session
          set -g @dracula-show-powerline true
        '';
      }
    ];
  };

  programs.neovim = {
    enable = true;
    # defaultEditor = true; why the hell doesn't this work :(
    # vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      nerdcommenter
      fugitive-gitlab-vim
      vim-repeat
      vim-airline
      fzf-vim
      dracula-vim
      vim-nix # this destroys my tab settings, ffs
    ];
    extraConfig =
      ''
        " basic commands bound to uppercase key
        command Q q
        command W w
        command Wq wq
        command WQ wq

        set shiftwidth=4
        set noexpandtab
        set preserveindent
        set number relativenumber
        set tabstop=4
        set smartcase
        set colorcolumn=120
        set nowrap
        highlight ColorColumn ctermbg=darkgray


        " beautify indents
        :set list lcs=tab:\|\ 

        nnoremap ; :
        nnoremap : ;
        vnoremap ; :
        vnoremap : ;

        " set space as leader
        nnoremap <SPACE> <Nop>
        let mapleader = " "

        " air-line
        let g:airline_powerline_fonts = 1

        " NERDTree
        nnoremap <leader>n :NERDTreeFocus<CR> :NERDTreeRefreshRoot<CR>
        " NERDTree autostart"
        autocmd VimEnter * NERDTree | wincmd p

        " Close the tab if NERDTree is the only window remaining in it.
        autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

        "remove ex-mode shortcut
        nmap Q <Nop>

        " trigger the fuzzy finder (fzf)
        nnoremap <leader>f :Files<CR>
        nnoremap <leader>g :GFiles<CR>
        nnoremap <leader>b :Buffers<CR>
        nnoremap <leader>r :Rg<CR>

        " keybinds for coc
        nnoremap <leader>d :CocDiagnostics<CR>

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

        " coloring stuff
        let g:dracula_colorterm = 0
        colorscheme dracula
 
        " better autocompletion menu colors
        highlight Pmenu ctermbg=darkgray ctermfg=black
        highlight PmenuSel ctermbg=gray ctermfg=black

      '';
  };

  services.picom = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
