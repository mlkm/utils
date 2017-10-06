fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

"""

let g:pathogen_disabled = ['vim-gitgutter']
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set updatetime=250

set ruler
set ai
set nu
set relativenumber

set tabstop=2
set expandtab
noremap <F6> :set expandtab<CR>
noremap <F7> :set noexpandtab<CR>
set shiftwidth=2
set softtabstop=2
set scrolloff=1000000000

set list
set listchars=tab:\|\ ,trail:X,nbsp:.
highlight SpecialKey ctermbg=9 ctermfg=0

syntax on

set cc=81

set hls
noh
highlight Search ctermbg=8

noremap <F5> :noh<CR>
noremap <F9> :ene<CR>

set ignorecase

set diffopt=horizontal,filler

set wildmenu
set wildmode=longest:full,full

set path=.,**,

set noequalalways

set t_Co=256

"let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=6

set cursorcolumn
set cursorline

highlight CursorColumn ctermbg=234
highlight CursorLine cterm=NONE ctermbg=234

highlight CursorLineNr ctermbg=235 ctermfg=6
highlight LineNr ctermbg=232 ctermfg=5

set showbreak=>>>
highlight NonText ctermbg=8 ctermfg=0

highlight StatusLine ctermbg=0 ctermfg=6

highlight Visual ctermbg=18

highlight Todo ctermbg=3 ctermfg=2

set fillchars=vert:\ 

call SetupCommandAlias('F', 'find')
call SetupCommandAlias('S', 'sfind')
call SetupCommandAlias('W', 'w')

noremap <Up> <Esc><C-W>k
inoremap <Up> <Esc><C-W>k

noremap <Down> <Esc><C-W>j
inoremap <Down> <Esc><C-W>j

noremap <Left> <Esc><C-W>h
inoremap <Left> <Esc><C-W>h

noremap <Right> <Esc><C-W>l
inoremap <Right> <Esc><C-W>l

nnoremap <Up> <C-W>k
nnoremap <Down> <C-W>j
nnoremap <Left> <C-W>h
nnoremap <Right> <C-W>l

nnoremap <F12> :w<CR>
nnoremap <F10> :q<CR>

nnoremap <F8> <C-W>_

noremap h ;
noremap j h
noremap k j
noremap l k
noremap ; l

if !exists('firstrun') || firstrun
  if !strlen(@%)
    let firstrun=0
    vnew
  endif
endif

set shortmess+=A  " Ignore swapfile warnings.

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
