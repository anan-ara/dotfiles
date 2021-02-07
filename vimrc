" Automatically get Vim Plug if you don't already have it
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-sleuth'

" For colors
" Plug 'arcticicestudio/nord-vim'
" Plug 'junegunn/seoul256.vim'
" Plug 'altercation/vim-colors-solarized'
" Plug 'tomasr/molokai'
Plug 'dracula/vim'

" For airline
Plug 'vim-airline/vim-airline'

" Vim as a programmer's text editor
" Plug 'vim-syntastic/syntastic'
Plug 'dense-analysis/ale'

" For EasyMotion
" Plug 'easymotion/vim-easymotion'
Plug 'unblevable/quick-scope'

" For NerdTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }

" For split screen navigation
Plug 'christoomey/vim-tmux-navigator'
" Plug 'edkolev/tmuxline.vim' " gives vim a nice tmux-like status bar

" For commenting
Plug 'preservim/nerdcommenter'

" For surrounding
" in visual mode, S + char -> surround the selected with the character
" use cs<char><char'> to change surrounding of char to char'
" use ysiw<char> to surround a word with a char
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat' "use dot on surround commands

" --- Working with Git ---
" shows signs next to changes
" see list of commands (:Gwrite, ...)
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-fugitive'

" For more icons
" Plug 'ryanoasis/vim-devicons'

call plug#end()

" Automatically get all plugins that you do not already have
autocmd VimEnter *
	    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	    \|   PlugInstall --sync | q
	    \| endif

" --- General settings ---
set number                     " Show current line number
set relativenumber             " Show relative line number
set showcmd
set hlsearch
set splitright
set splitbelow
set ignorecase " case insensitive searching (specify lower with \c)
set smartcase " if upper case in string, case sensitive
set mouse=a
set hidden " make buffers work normally
set scrolloff=2
set linebreak
set encoding=utf-8

" autocompletion
set wildignorecase
" set wildmode=list:longest,full

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set noswapfile
set nowritebackup

" cleaning home folder
set viminfo+=n~/.vim/viminfo
" toggle invisible characters
set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" Enable folding
set foldmethod=indent
set foldlevel=99

" we already have airline so this is redundant
set noshowmode

" --- Tab Settings ---
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

" --- REMAPS ---

" Remap leader to be easier to reach
let mapleader = ' '
" let maplocalleader = ' '

" make Y effect to end of line instead of whole line
noremap Y y$

" Auto Indent the entire file with =
" nnoremap = gg=G<C-o><C-o>

" Most controversial change in this whole vimrc file
" But it makes sense visually
" I'll try turning this off for a bit and see how this goes
" inoremap <silent> <Esc> <C-O>:stopinsert<CR>

" Make navigating wrapped lines the same as normal
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> gk k
noremap <silent> gj j
noremap <silent> ^ g^
noremap <silent> _ g_
noremap <silent> g^ ^
noremap <silent> g_ _

" Make pasting work like in normal editors
" Actually this was a bad idea I'm gonna turn it off for now
" noremap <silent> p gp
" noremap <silent> gp p
" noremap <silent> P gP
" noremap <silent> gP P

" Cycle through buffers
noremap <silent> gl :bn<CR>
noremap <silent> gh :bp<CR>

" Jump to buffers
noremap <silent> <Leader>b :ls<CR>:b<space>

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR>

" shortcut to save
nmap <leader>w :w<cr>

" Make vim open where left off
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
		\| exe "normal! g'\"" | endif
endif

" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre * :call CleanExtraSpaces()
endif

" --- Plugin Specific Settings ---
"
" ----- Vim-GitGutter -----
" highlight clear SignColumn
" Make things update faster
set updatetime=100
" Highlight the SignColumn
highlight! link SignColumn LineNr

" Set the colorscheme
colorscheme dracula

" Makes transparentcy work idk how but it does
highlight Normal guibg=NONE ctermbg=NONE

" Unified color scheme (default: dark)
" let g:seoul256_background = 235
" colo seoul256

" Toggle this to "light" for light colorscheme
"set background=light
"
" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line

" Currently turned off to make vimrc more portable
" let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Show airline for Syntastic
" let g:airline#extensions#syntastic#enabled = 1

" Show airline for ALE
let g:airline#extensions#ale#enabled = 1
"
" Use theme for the Airline status bar
" let g:airline_theme='nord'

" ----- Syntastic Settings -----
" let g:syntastic_mode_map = { \ "mode": "passive",
	    " \ "active_filetypes": [],
	    " \ "passive_filetypes": [] }

" " close location list with :lclose
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0

" " press \g to automatically check for errors
" nnoremap <Leader>g :SyntasticCheck<CR>
"
" ----- ALE -----
let g:ale_linters = { 'python': ['flake8'] }
let g:ale_fixers = { 'python': ['black'] }
let g:ale_fix_on_save = 0

" Fix!
nnoremap <Leader>g :ALEFix<CR>

" ----- NerdTree -----
"  " Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
let g:NERDTreeQuitOnOpen = 1

" --- nerdcommenter ---
" Turn off default mappings
let g:NERDCreateDefaultMappings = 1
" Create space between the comment mark for prettier commenting
let g:NERDSpaceDelims = 1
" + to comment, - to uncomment
map + <plug>NERDCommenterComment
map - <plug>NERDCommenterUncomment
