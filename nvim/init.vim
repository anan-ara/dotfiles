" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'

" For colors
Plug 'arcticicestudio/nord-vim'
" Plug 'junegunn/seoul256.vim'
" Plug 'altercation/vim-colors-solarized'
" Plug 'tomasr/molokai'
Plug 'dracula/vim'

" For airline
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Plug 'Raimondi/delimitMate'

" For more icons
Plug 'ryanoasis/vim-devicons'
" Fuzzy Finder
Plug 'junegunn/fzf'

" ----- Vim as a programmer's text editor -----------------------------
Plug 'vim-syntastic/syntastic'

" For TeX
Plug 'lervag/vimtex', { 'for': 'latex' }

" For EasyMotion
Plug 'easymotion/vim-easymotion'
Plug 'unblevable/quick-scope'

" For NerdTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }

" For split screen navigation
" Plug 'christoomey/vim-tmux-navigator'
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
Plug 'tpope/vim-fugitive'

" To move around faster
Plug 'takac/vim-hardtime'

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
set nowb
set noswapfile

" toggle invisible characters
set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

set clipboard=unnamedplus " use clipboard instead of vim's buffer

" --- Tab Settings ---
" set smarttab
" set tabstop=4
" set softtabstop=4
" set shiftwidth=4
" set noexpandtab

" --- Plugin Specific Settings ---
" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
hi clear SignColumn

" ----- altercation/vim-colors-solarized settings -----
" Uncomment the next line if your terminal is not configured for solarized
"let g:solarized_termcolors=256

" Set the colorscheme
colorscheme dracula

" Makes transparentcy work idk how but it does
hi Normal guibg=NONE ctermbg=NONE

" Unified color scheme (default: dark)
" let g:seoul256_background = 235
" colo seoul256

" Toggle this to "light" for light colorscheme
"set background=light

" --- REMAPS ---

"Use enter to create new lines w/o entering insert mode
nnoremap <CR> o<Esc>
""Below is to fix issues with the ABOVE mappings in quickfix window
autocmd CmdwinEnter * nnoremap <CR> <CR>
autocmd BufReadPost quickfix nnoremap <CR> <CR>

" Remap leader to be easier to reach
let mapleader = ' '
let maplocalleader = ' '

" make Y effect to end of line instead of whole line
noremap Y y$

" Auto Indent the entire file with =
nnoremap = gg=G<C-o><C-o>

" Most controversial change in this whole vimrc file
" But it makes sense visually
inoremap <silent> <Esc> <C-O>:stopinsert<CR>

" Make navigating wrapped lines the same as normal
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> gk k
noremap <silent> gj j
noremap <silent> ^ g^
noremap <silent> g^ ^
noremap <silent> _ g_

" Make pasting work like in normal editors
" Actually this was a bad idea I'm gonna turn it off for now
" noremap <silent> p gp
" noremap <silent> gp p
" noremap <silent> P gP
" noremap <silent> gP P

noremap <silent> gt :bn<CR>
noremap <silent> gT :bp<CR>

" Save some time when doing LaTeX
noremap <silent> g1 i\begin{align*}<CR>

" Make <Esc><Esc> clear search highlights in normal mode
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

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

" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Use theme for the Airline status bar
" let g:airline_theme='nord'
" we already have airline so this is redundant
set noshowmode

" --- vimtex settings ---
let g:vimex_quickfix_latexlog= {
	    \ 'default' : 1,
	    \ 'underfull' : 0,
	    \}

let g:vimtex_view_method='skim'
"
" close quickfix window
noremap <Leader>c :cclose<CR>

aug QFClose
    au!
    au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END

" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
    au!
    au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
    au FileType tex let b:delimitMate_quotes = ""
    au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
    au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" ----- Syntastic Settings -----
let g:syntastic_mode_map = {
	    \ "mode": "passive",
	    \ "active_filetypes": [],
	    \ "passive_filetypes": [] }

let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_cpp_compiler = 'g++-9'
let g:syntastic_cpp_compiler_options = ' -std=c++17'

" close location list with :lclose
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" press \g to automatically check for errors
" nnoremap <Leader>g :SyntasticCheck<CR>
nnoremap <Leader>g :SyntasticToggleMode<CR>

" ----- NerdTree -----
"  " Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
let g:NERDTreeQuitOnOpen = 1
" --- EasyMotion ---
" The only easymotion I use
map <Leader>s <Plug>(easymotion-s)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" But in case I need to use anything else, only press leader once
map <Leader> <Plug>(easymotion-prefix)

" --- nerdcommenter ---
" Turn off default mappings
let g:NERDCreateDefaultMappings = 1
" Create space between the comment mark for prettier commenting
let g:NERDSpaceDelims = 1
" + to comment, - to uncomment
nmap + <plug>NERDCommenterComment
nmap - <plug>NERDCommenterUncomment

" --- vim-hardtime ---
"  Automatically timeout inefficient keys
let g:hardtime_default_on = 1