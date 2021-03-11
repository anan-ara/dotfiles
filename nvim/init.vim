" Automatically get Vim Plug if you don't already have it
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
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
" Plug 'vim-airline/vim-airline-themes'

" Plug 'Raimondi/delimitMate'

" Vim as a programmer's text editor
Plug 'vim-syntastic/syntastic'

" For Motion
" Plug 'easymotion/vim-easymotion'
Plug 'unblevable/quick-scope'

" For NerdTree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeTabsToggle' }
Plug 'jistr/vim-nerdtree-tabs', { 'on': 'NERDTreeTabsToggle' }

" For fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

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

" To move around faster
" Plug 'takac/vim-hardtime'

" Language Specific Plugins
" Python
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }
" LaTeX
Plug 'lervag/vimtex', { 'for': 'latex' }
" WebDev
Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
Plug 'ap/vim-css-color'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" For more icons
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Automatically get all plugins that you do not already have
autocmd VimEnter *
	    \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	    \|   PlugInstall --sync | q
	    \| endif

" --- General settings ---
set number                     " Show current line number
" set relativenumber             " Show relative line number
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
set noswapfile
set nowritebackup

" stop netrwhist from getting generated
let g:netrw_dirhistmax=0

" toggle invisible characters
set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

set clipboard=unnamedplus " use clipboard instead of vim's buffer

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

au BufNewFile,BufRead *.js,*.html,*.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2


" --- REMAPS ---

" Remap leader to be easier to reach
let mapleader = ' '
let maplocalleader = ' '

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

" Jump to matching element faster, % is hard to reach
noremap <silent> <Tab> %

" Save some time when doing LaTeX
noremap <silent> g1 i\begin{align*}<CR>

"This unsets the "last search pattern" register by hitting return
nnoremap <silent> <CR> :noh<CR>

" "split navigations
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

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

" Toggle signcolumn. Works only on vim>=8.0 or NeoVim
" https://stackoverflow.com/questions/18319284/vim-sign-column-toggle/18322752#18322752
function! ToggleSignColumn()
    if !exists("b:signcolumn_on") || b:signcolumn_on
        set signcolumn=no
        let b:signcolumn_on=0
    else
        set signcolumn=auto
        let b:signcolumn_on=1
    endif
endfunction

noremap <Leader>k :call ToggleSignColumn()<CR>

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
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1

" Show airline for Syntastic
let g:airline#extensions#syntastic#enabled = 1

" Use theme for the Airline status bar
" let g:airline_theme='nord'

" --- vimtex settings ---
let g:vimex_quickfix_latexlog= {
	    \ 'default' : 1,
	    \ 'underfull' : 0,
	    \}

let g:vimtex_view_method='zathura'

" close quickfix window
noremap <Leader>c :cclose<CR>

aug QFClose
    au!
    au WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
aug END

" ----- Raimondi/delimitMate settings -----
" let delimitMate_expand_cr = 1
" augroup mydelimitMate
    " au!
    " au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
    " au FileType tex let b:delimitMate_quotes = ""
    " au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
    " au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
" augroup END

" ----- Syntastic Settings -----
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }

let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"

" close location list with :lclose
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" press \g to automatically check for errors
nnoremap <Leader>g :SyntasticCheck<CR>
" nnoremap <Leader>g :SyntasticToggleMode<CR>

" ----- NerdTree -----
"  " Open/close NERDTree Tabs with \t
nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
let g:NERDTreeQuitOnOpen = 1

" --- Emmet ---
let g:user_emmet_leader_key='<C-E>'

" --- EasyMotion ---
" The only easymotion I use
" map <Leader>s <Plug>(easymotion-s)
" Turn on case-insensitive feature
" let g:EasyMotion_smartcase = 1

" But in case I need to use anything else, only press leader once
" map <Leader> <Plug>(easymotion-prefix)

" --- nerdcommenter ---
" Turn off default mappings
let g:NERDCreateDefaultMappings = 1
" Create space between the comment mark for prettier commenting
let g:NERDSpaceDelims = 1
" + to comment, - to uncomment
map + <plug>NERDCommenterComment
map - <plug>NERDCommenterUncomment

" --- FZF ---
" Search and switch buffers
nmap <leader>b :Buffers<cr>
" Find files by name under the current directory
nmap <leader>f :Files<cr>
" Find files by name under the home directory
nmap <leader>h :Files ~/<cr>

" --- vim-hardtime ---
"  Automatically timeout inefficient keys
let g:hardtime_default_on = 1
let g:list_of_normal_keys = ["h","l"]
let g:list_of_visual_keys = ["h","l"]
let g:hardtime_allow_different_key = 1
