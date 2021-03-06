call plug#begin()
Plug 'derekwyatt/vim-fswitch'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-operator-user'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'preservim/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'rhysd/vim-clang-format'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
call plug#end()

" gc: comment operator
" gs: grep operator

let g:airline#extensions#tabline#enabled = 1
let g:gutentags_cache_dir = expand('~/.vim/ctags/')
let g:clang_format#code_style = "mozilla"
let g:plug_window = 'noautocmd vertical topleft new'
let g:fzf_history_dir = '~/.vim/.fzf-history'

sy enable
filetype on
color koehler
hi Normal guibg=NONE ctermbg=NONE
hi Statement cterm=bold
hi Type cterm=bold

set nocompatible
set hlsearch
set number
set cursorline
set expandtab
set autoindent
set smartindent
set cindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set wildmenu
set wildmode=longest:full
set completeopt=longest,menuone

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
au Filetype h,hpp,c,cc,cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
au FileType h,hpp,c,cc,cpp map <buffer> = <Plug>(operator-clang-format)
au FileType h,hpp,c,cc,cpp setlocal commentstring=//\ %s

command DeleteTrailingWhitespace %s/\s\+$//e

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" nmap <BS> X
vmap <BS> "_d<ESC>
vmap <DEL> "_d

nmap <C-x>t <ESC>:NERDTreeFocus<CR>
nmap <C-x><Left> :bp<CR>
imap <C-x><left> <ESC>:bp<CR>i
nmap <C-x><Right> :bn<CR>
imap <C-x><Right> <ESC>:bn<CR>i
nmap <C-x>0 :hide<CR>
imap <C-x>0 <ESC>:hide<CR>i
nmap <C-x>1 :only<CR>
imap <C-x>1 <ESC>:only<CR>i
nmap <C-x>2 :split<CR>
imap <C-x>2 <ESC>:split<CR>i
nmap <C-x>3 :vsplit<CR>
imap <C-x>3 <ESC>:vsplit<CR>i

vmap <C-Left> b
nmap <C-Left> b
imap <C-Left> <ESC>bi
vmap <C-Right> w
nmap <C-Right> w
imap <C-Right> <ESC>lwi
vmap <C-Up> {
nmap <C-Up> {
imap <C-Up> <ESC>{i
vmap <C-Down> }
nmap <C-Down> }
imap <C-Down> <ESC>}i
vmap <PageUp> <C-u>
nmap <PageUp> <C-u>
imap <PageUp> <ESC><C-u>i
vmap <PageDown> <C-d>
nmap <PageDown> <C-d>
imap <PageDown> <ESC><C-d>i

nmap <C-o> :GFiles<CR>
imap <C-o> <ESC>:GFiles<CR>
vmap <C-o> <ESC>:GFiles<CR>
nmap <C-f> :Lines<CR>
imap <C-f> <ESC>:Lines<CR>
vmap <C-f> <ESC>:Lines<CR>

let mapleader = " "
nmap <silent> <leader>b :Buffers<cr>
nmap <silent> <leader>fs :FSHere<cr>

let g:clang_format#style_options = {
            \ "DerivePointerAlignment" : "false",
            \ "PointerAlignment" : "Right",
            \ }

let g:gutentags_ctags_exclude = [
            \ '*/.ccls-cache/*', '*/Debug/*',
            \ '*.git', '*.svg', '*.hg',
            \ '*/tests/*',
            \ 'build',
            \ 'dist',
            \ '*sites/*/files/*',
            \ 'bin',
            \ 'node_modules',
            \ 'bower_components',
            \ 'cache',
            \ 'compiled',
            \ 'docs',
            \ 'example',
            \ 'bundle',
            \ 'vendor',
            \ '*.md',
            \ '*-lock.json',
            \ '*.lock',
            \ '*bundle*.js',
            \ '*build*.js',
            \ '.*rc*',
            \ '*.json',
            \ '*.min.*',
            \ '*.map',
            \ '*.bak',
            \ '*.zip',
            \ '*.pyc',
            \ '*.class',
            \ '*.sln',
            \ '*.Master',
            \ '*.csproj',
            \ '*.tmp',
            \ '*.csproj.user',
            \ '*.cache',
            \ '*.pdb',
            \ 'tags*',
            \ 'cscope.*',
            \ '*.css',
            \ '*.less',
            \ '*.scss',
            \ '*.exe', '*.dll',
            \ '*.mp3', '*.ogg', '*.flac',
            \ '*.swp', '*.swo',
            \ '*.bmp', '*.gif', '*.ico', '*.jpg', '*.png',
            \ '*.rar', '*.zip', '*.tar', '*.tar.gz', '*.tar.xz', '*.tar.bz2',
            \ '*.pdf', '*.doc', '*.docx', '*.ppt', '*.pptx',
            \ ]
