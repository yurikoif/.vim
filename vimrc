call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'lifepillar/vim-mucomplete'
Plug 'jacoborus/tender.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'will133/vim-dirdiff'
call plug#end()

let g:airline#extensions#tabline#enabled = 1
let g:gutentags_cache_dir = expand('~/.vim/ctags/')
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#minimum_prefix_length = 2
let g:DirDiffExcludes = "CVS,*.class,*.exe,.*.swp,.git*,.*cache"

sy enable
filetype on
color tender
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
set autochdir
set browsedir=current " Make the file browser always open the current directory.
set wildmenu
set wildmode=longest:full
set completeopt=longest,menuone

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
au Filetype h,hpp,c,cc,cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

vmap <BS> "_d<ESC>
vmap <DEL> "_d

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

nmap <C-s> :update<CR>
imap <C-s> <ESC>:update<CR>
vmap <C-s> <ESC>:update<CR>
nmap <C-o> :GFiles<CR>
imap <C-o> <ESC>:GFiles<CR>
vmap <C-o> <ESC>:GFiles<CR>
nmap <F12> :Buffers<CR>
imap <F12> <ESC>:Buffers<CR>
vmap <F12> <ESC>:Buffers<CR>
nmap <C-f> :Lines<CR>
imap <C-f> <ESC>:Lines<CR>
vmap <C-f> <ESC>:Lines<CR>

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
