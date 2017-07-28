fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

"""

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set updatetime=250

"colorscheme solarized8_dark

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
highlight SpecialKey ctermbg=0 ctermfg=4

syntax on

set cc=81

set hls
noh
highlight Search ctermbg=4 ctermfg=15

noremap <F5> :noh<CR>
noremap <F9> :ene<CR>

set ignorecase

noremap <F3> :GitGutterToggle<CR>
noremap <F4> :GitGutterSignsToggle<CR>
"noremap <F5> :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_max_signs = 5000
"let g:gitgutter_max_signs = 500  " default value
let g:gitgutter_diff_args = '`git log --pretty=oneline --author=git5 | head -1 | cut -f1 -d" "`'

set diffopt=horizontal,filler

set wildmenu
set wildmode=longest:full,full

set path=.,/usr/include,**,,~,~/utils/**

set noequalalways

set t_Co=256

let &colorcolumn=join(range(81,999),",")
highlight ColorColumn ctermbg=0

set cursorcolumn
set cursorline

highlight CursorColumn ctermbg=17
highlight CursorLine cterm=NONE ctermbg=17

"highlight CursorColumn ctermbg=234
"highlight CursorLine cterm=NONE ctermbg=234

highlight CursorLineNr ctermbg=0 ctermfg=6
highlight LineNr ctermbg=0 ctermfg=5

set showbreak=>>>\ 
highlight NonText ctermbg=233 ctermfg=2

highlight StatusLine ctermbg=0 ctermfg=6

highlight Visual ctermbg=18

set fillchars=vert:\ 

call SetupCommandAlias('F', 'find')
call SetupCommandAlias('S', 'sfind')
call SetupCommandAlias('W', 'w')

"set mouse=nicr
"noremap <LeftDrag> <NOP>
"noremap! <LeftDrag> <NOP>

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

syntax keyword pyNiceOperator all conceal cchar=∀
syntax keyword pyNiceOperator any conceal cchar=∃

set shortmess+=A  " Ignore swapfile warnings.
