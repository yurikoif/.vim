" codex.vim - simple Codex CLI integration for Vim
"
" Features:
"   - <leader>cx : open / focus Codex terminal
"   - Visual + <leader>cx : send selected code to Codex with a wrapper prompt
"
" Optional user config:
"   let g:codex_command = 'codex'          " CLI command to run (default: 'codex')
"   let g:codex_pane_side = 'left'         " one of: 'bottom', 'top', 'left', 'right'
"   let g:codex_pane_ratio = 0.4           " fraction of screen for Codex pane (height or width)

" Ensure Codex executable exists before loading this plugin
augroup CodexMissingWarning
  autocmd!
if executable(get(g:, 'codex_command', 'codex')) == 0
  autocmd VimEnter * echohl WarningMsg |
          \ echom "codex.vim: 'codex' executable not found in PATH (plugin inactive)" |
          \ echohl None
  finish
endif

if !has('terminal')
  autocmd VimEnter * echohl WarningMsg |
          \ echom "codex.vim: this Vim was built without :terminal support." |
          \ echohl None
  finish
endif
augroup END

if exists('g:loaded_codex_vim')
  finish
endif
let g:loaded_codex_vim = 1

" Helper: get Codex command (user-overrideable)
function! s:CodexCommand() abort
  return get(g:, 'codex_command', 'codex')
endfunction

" Helper: place Codex window on a configured side with a ratio of screen size
function! s:CodexPlacePane() abort
  let l:side  = get(g:, 'codex_pane_side', 'left')
  let l:ratio = get(g:, 'codex_pane_ratio', 0.4)
  if type(l:ratio) != type(0.0)
    let l:ratio = 0.4
  endif
  if l:side ==# 'top'
    wincmd K
  elseif l:side ==# 'bottom'
    wincmd J
  elseif l:side ==# 'left'
    wincmd H
  elseif l:side ==# 'right'
    wincmd L
  else " left by default
    wincmd H
  endif
  if l:side ==# 'left' || l:side ==# 'right'
    if exists('*float2nr')
      let l:w = float2nr(&columns * l:ratio)
    else
      let l:w = &columns * l:ratio / 1
    endif
    if l:w < 10
      let l:w = 10
    endif
    execute 'vertical resize ' . l:w
  else " top or bottom
    if exists('*float2nr')
      let l:h = float2nr(&lines * l:ratio)
    else
      let l:h = &lines * l:ratio / 1
    endif
    if l:h < 3
      let l:h = 3
    endif
    execute 'resize ' . l:h
  endif
endfunction

" Helper: set options + mappings for Codex terminal buffer
function! s:CodexSetupBuffer() abort
  " Make this buffer light-weight and unobtrusive
  setlocal nobuflisted
  setlocal nonumber norelativenumber
  setlocal signcolumn=no
  setlocal bufhidden=hide
  " Terminal-job mode: double Esc -> hide window (Codex keeps running)
  tnoremap <buffer> <Esc><Esc> <C-\><C-n>:hide<CR>
endfunction

" Public: toggle Codex terminal pane
function! CodexToggle() abort
  " If we already have a Codex buffer recorded and it exists, reuse it
  if exists('g:codex_bufnr') && bufexists(g:codex_bufnr)
    let l:winnr = bufwinnr(g:codex_bufnr)

    if l:winnr != -1
      " Codex window is visible: jump there and normalize its position/height
      execute l:winnr . 'wincmd w'
      call s:CodexPlacePane()
    else
      " Codex buffer is hidden: show it in a new bottom split
      botright split
      execute 'buffer ' . g:codex_bufnr
      call s:CodexPlacePane()
      call s:CodexSetupBuffer()
    endif
  else
    " No existing Codex buffer: create a new terminal with ++close so Vim
      " auto-closes it when the job exits.
    execute 'terminal ++close ++kill=term ' . s:CodexCommand()

    let g:codex_bufnr = bufnr('%')

    " Collect the absolute paths of files visible in current Vim windows as contexts
    let l:files = []
    for w in range(1, winnr('$'))
        let l:buf = winbufnr(w)
        if bufloaded(l:buf) && filereadable(expand('#'.l:buf.':p'))
            call add(l:files, expand('#'.l:buf.':p'))
        endif
    endfor

    if !empty(l:files)
        let l:context = "Context: files open in Vim:\n" . join(l:files, "\n") . "\n\n"
        call term_sendkeys(g:codex_bufnr, l:context)
    endif

    call s:CodexPlacePane()
    call s:CodexSetupBuffer()
  endif
  if &buftype ==# 'terminal' && mode() ==# 'n'
    call feedkeys("i", 'n') " return to terminal mode
  endif
endfunction

" Public: send visual selection to Codex with a wrapper prompt
function! CodexSendSelectionWithPrompt() range abort
  " 1. Grab selected text
  let l:lines = getline(a:firstline, a:lastline)
  let l:text  = join(l:lines, "\n")

  if empty(l:text)
    echo "codex.vim: no selection to send"
    return
  endif

  " 2. Build wrapper prompt
  let l:file = expand('%:p')
  let l:ft   = &filetype
  let l:loc  = printf("lines %d-%d", a:firstline, a:lastline)

  " Ask user what they want Codex to do
  let l:task = input('Codex task (empty = just share snippet): ')
  if v:shell_error == 1
    echo "codex.vim: task input cancelled"
    return
  endif

  let l:prompt  = 'You are an AI coding assistant integrated into Vim.' . "\n"
  let l:prompt .= 'I am working on this code snippet at ' . l:file . ' (' . l:loc . '):' . "\n"
  " Add fenced code block for better context
  let l:prompt .= '```' . l:ft . "\n" . l:text . "\n```\n"
  let l:prompt .= 'Look for more context only if it is necessary.' . "\n"

  if !empty(l:task)
    let l:prompt .= 'Task: ' . l:task . "\n"
  else
    let l:prompt .= 'Please read this snippet and wait for my next instruction.' . "\n"
  endif

  " 3. Remember original window so we can return
  let l:orig_win = winnr()

  " 4. Ensure Codex terminal is running and visible (this may jump to Codex)
  call CodexToggle()

  if !exists('g:codex_bufnr') || !bufexists(g:codex_bufnr)
    echoerr "codex.vim: Codex terminal not available."
    execute l:orig_win . 'wincmd w'
    return
  endif

  " 5. Send the prompt into the Codex terminal buffer
  if exists('*term_sendkeys')
    " One big prompt + Enter, behaves like pasting & hitting <CR>
    call term_sendkeys(g:codex_bufnr, l:prompt . "\r")
  elseif exists('*chansend') && exists('*term_getchan')
    let l:chan = term_getchan(g:codex_bufnr)
    call chansend(l:chan, l:prompt . "\n")
  else
    echoerr "codex.vim: term_sendkeys/chansend not available in this Vim."
  endif
endfunction

" -------------------------------------------------------------------------
" Mappings (you can override these in your vimrc if you want other keys)
" -------------------------------------------------------------------------

" Normal mode: open / focus Codex pane
nnoremap <leader>cx :call CodexToggle()<CR>

" Visual mode: send selection to Codex with wrapper prompt
xnoremap <silent> <leader>cx :<C-u>'<,'>call CodexSendSelectionWithPrompt()<CR>

" Reload files modified outside Vim
set autoread

" Trigger autoread when Vim focus changes or buffer is revisited
autocmd FocusGained,BufEnter,CursorHold * checktime
