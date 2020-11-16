call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'sainnhe/edge'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
call plug#end()

let g:airline#extensions#tabline#enabled = 1
let g:gutentags_cache_dir = expand('~/.vim/ctags/')

sy enable
filetype on
set background=dark
color edge
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
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autochdir
set browsedir=current " Make the file browser always open the current directory.
set wildmenu
set wildmode=longest:full

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
au Filetype h,hpp,c,cc,cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

vmap <BS> "_d<ESC>
vmap <DEL> "_d

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
