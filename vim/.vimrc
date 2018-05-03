set ts=2
set sw=2
set expandtab
set cursorline

" Make searching better
set ignorecase
set gdefault
set showmatch

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" <c-h> is interpreted as <bs> in neovim
" This is a bandaid fix until the team decides how
" they want to handle fixing it...(https://github.com/neovim/neovim/issues/2048)
nnoremap <silent> <bs> :TmuxNavigateLeft<cr>

"Toggle relative numbering, and set to absolute on loss of focus or insert mode
set nu rnu
function! ToggleNumbersOn()
  set nu!
  set nu rnu
endfunction
function! ToggleRelativeOn()
  set nu rnu!
  set nu
endfunction
autocmd InsertEnter * call ToggleRelativeOn()
autocmd InsertLeave * call ToggleNumbersOn()

set clipboard+=unnamedplus

call plug#begin('~/.local/share/nvim/plugged')
Plug 'pangloss/vim-javascript' | Plug 'mxw/vim-jsx'
Plug 'powerline/powerline'
Plug 'w0rp/ale'
Plug 'prettier/vim-prettier'
Plug 'floobits/floobits-neovim'
Plug 'scrooloose/nerdtree'
Plug 'endel/vim-github-colorscheme'
Plug 'tpope/vim-fugitive' | Plug 'bling/vim-airline'
Plug 'vim-scripts/tComment'
call plug#end()
