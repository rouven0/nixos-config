{ config, pkgs, ... }:
{
  environment.variables = { EDITOR = "hx"; }; # we set helix in here to have it shared
  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix ];
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
  ];
}
