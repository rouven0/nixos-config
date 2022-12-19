{ config, pkgs, ... }:
{
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

}
