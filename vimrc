call plug#begin()
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-tags.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
if executable('clangd') || executable('pyright')
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
endif
if has('python3')
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-operator-user'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mechatroner/rainbow_csv', { 'for': 'csv' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'preservim/nerdtree', { 'on': ['NERDTreeFocus', 'NERDTreeToggle'] }
" Plug 'preservim/tagbar', { 'on': 'TagbarOpen' }
Plug 'preservim/tagbar'
Plug 'rhysd/vim-clang-format'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'AndrewRadev/linediff.vim'
call plug#end()

" gc: comment operator
" gs: grep operator
" cs: parentheses change operator
" ds: parentheses deletion operator
" ys: parentheses insertion operator
" yswf: function parentheses insertion operator
" S: parentheses insertion operator in virsual mode

let g:airline#extensions#tagbar#flags = 'f'
let g:airline#extensions#default#layout = [ [ 'a', 'b', 'c', 'x' ], [ 'y', 'z', 'warning' ] ]
let g:grepper = {}
let g:grepper.dir = 'repo,file' " grep from repo root; try current file dir if fails
let g:gutentags_cache_dir = expand('~/.vim/ctags/')
let g:clang_format#code_style = "mozilla"
let g:clang_format#enable_fallback_style = 1
let g:plug_window = 'noautocmd vertical topleft new'
let g:fzf_history_dir = expand('~/.vim/.fzf-history')
if has_key(g:plugs, 'vim-lsp')
    let g:lsp_diagnostics_echo_cursor = 1
    let g:lsp_diagnostics_virtual_text_enabled = 0
    let g:lsp_settings_filetype_python = [ 'pyright-langserver' ]
endif
let g:VM_default_mappings = 0 " disable all key mappings except for <C-n> in multi cursor
let g:NERDTreeChDirMode = 2 " fix NERDTree cannot close tree root
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]

sy enable
filetype on
color koehler
hi Normal guibg=NONE ctermbg=NONE
hi Statement cterm=bold
hi Type cterm=bold
hi Pmenu ctermbg=blue

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
set completeopt=menuone,noinsert,preview " select 1st item in the menu, do not insert into buffer but show preview
set autochdir
" keep pwd, highlight, background settings, etc.
set viewoptions-=options
set sessionoptions-=options
set shortmess-=S
set incsearch
set smartcase

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
au Filetype h,hpp,c,cc,cpp,cuda setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
if executable(g:clang_format#command)
    au FileType h,hpp,c,cc,cpp,cuda map <buffer> = <Plug>(operator-clang-format)
endif
au FileType h,hpp,c,cc,cpp,cuda setlocal commentstring=//\ %s
if exists(':RainbowAlign')
    au FileType csv nnoremap <buffer> <C-a> :RainbowAlign<CR>
    au FileType csv vnoremap <buffer> <C-a> :RainbowAlign<CR>
endif

command DeleteTrailingWhitespace %s/\s\+$//e

nmap _ :TagbarJumpPrev<CR>
nmap + :TagbarJumpNext<CR>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" nmap <BS> X
vmap <BS> "_d<ESC>
vmap <DEL> "_d
set backspace=indent,eol,start

nmap <C-o> :GFiles<CR>
imap <C-o> <ESC>:GFiles<CR>
vmap <C-o> <ESC>:GFiles<CR>
if executable('rg')
    command! -bang -nargs=* Rg
                \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
                \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
    nmap <C-f> :Rg<CR>
    imap <C-f> <ESC>:Rg<CR>
    vmap <C-f> <ESC>:Rg<CR>
else
    nmap <C-f> :Grepper<CR>
    imap <C-f> <ESC>:Grepper<CR>
    vmap <C-f> <ESC>:Grepper<CR>
endif

let mapleader = " "
nmap <silent> <leader><TAB> :Buffers<CR>
nmap <silent> <leader>grep :Grepper<CR>
nmap <silent> <leader>tag :TagbarOpen f<CR>
nmap <silent> <leader>ls :NERDTreeFocus<CR>
nmap <silent> <leader>bc :tabnew<CR>
nmap <silent> <leader>bn :tabnext<CR>
nmap <silent> <leader>bp :tabnext<CR>
nmap <silent> <leader>b<left> <C-w><left>
nmap <silent> <leader>b<right> <C-w><right>
nmap <silent> <leader>b<up> <C-w><up>
nmap <silent> <leader>b<down> <C-w><down>

for vimfile in split(globpath('~/.vim', '*.vim'), '\n')
    execute('source ' . vimfile)
endfor

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
" tmux setups:
" set-window-option -g xterm-keys on
" set-option -g default-shell /bin/bash
" set -g default-terminal screen-256color
" bind b   select-pane -t :.+
" bind C-b select-pane -t :.+

nnoremap <silent> <C-]> :let g:current_buf = map(filter(getbufinfo(), 'v:val.listed'), 'v:val.bufnr')<CR><C-]>:if index(g:current_buf,bufnr('%')) == -1 <bar> setlocal bufhidden=delete <bar> endif<CR>
