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
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-operator-user'
Plug 'ludovicchabant/vim-gutentags'
Plug 'mechatroner/rainbow_csv', { 'for': 'csv' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'preservim/nerdtree', { 'on': ['NERDTreeFocus', 'NERDTreeToggle'] }
Plug 'preservim/tagbar', { 'on': 'TagbarOpen' }
Plug 'rhysd/vim-clang-format'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
call plug#end()

" gc: comment operator
" gs: grep operator
" cs: parentheses change operator
" ds: parentheses deletion operator
" ys: parentheses insertion operator
" yswf: function parentheses insertion operator
" S: parentheses insertion operator in virsual mode

let g:airline#extensions#tabline#enabled = 1
let g:gutentags_cache_dir = expand('~/.vim/ctags/')
let g:clang_format#code_style = "mozilla"
let g:clang_format#enable_fallback_style = 1
let g:plug_window = 'noautocmd vertical topleft new'
let g:fzf_history_dir = '~/.vim/.fzf-history'
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_settings_filetype_python = [ 'pyright-langserver' ]
let g:VM_default_mappings = 0 " disable all key mappings except for <C-n> in multi cursor

" tab complete & enter snippet
inoremap <silent><expr> <TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
let g:UltiSnipsExpandTrigger="<CR>"

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
set autochdir
" keep pwd, highlight, background settings, etc.
set viewoptions-=options
set sessionoptions-=options
set shortmess-=S

au BufWinLeave *.* mkview
au BufWinEnter *.* silent loadview
au Filetype h,hpp,c,cc,cpp setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
if executable(g:clang_format#command)
    au FileType h,hpp,c,cc,cpp map <buffer> = <Plug>(operator-clang-format)
endif
au FileType h,hpp,c,cc,cpp setlocal commentstring=//\ %s
if exists(':RainbowAlign')
    au FileType csv nnoremap <buffer> <C-a> :RainbowAlign<CR>
    au FileType csv vnoremap <buffer> <C-a> :RainbowAlign<CR>
endif

command DeleteTrailingWhitespace %s/\s\+$//e

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
    nmap <C-f> :Lines<CR>
    imap <C-f> <ESC>:Lines<CR>
    vmap <C-f> <ESC>:Lines<CR>
endif

let mapleader = " "
nmap <silent> <leader><TAB> :Buffers<CR>
nmap <silent> <leader>grep :Grepper<CR>
nmap <silent> <leader>ls :TagbarOpen f<CR>
nmap <silent> <leader>tree :NERDTreeFocus<CR>

for vimfile in split(globpath('~/.vim', '*.vim'), '\n')
    execute('source ' . vimfile)
endfor
