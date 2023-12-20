
fu! PathSess()
    let session_dir = fnamemodify('~', ':p') . '.vim/sessions/'
    if !isdirectory(session_dir)
        call mkdir(session_dir, 'p')
    endif
    let git_dir = substitute(system('git rev-parse --show-toplevel 2>&1 | grep -v fatal:'),'\n','','g')
    " echo git_dir
    if isdirectory(git_dir)
        let git_dir_name = substitute(git_dir, '/', '.', 'g')
        " echo git_dir_name
        return session_dir . git_dir_name . '.vim'
    else
        return session_dir . '.session.vim'
    endif
endfunction

fu! SaveSess()
    let path_sess = PathSess()
    execute 'mksession! ' . path_sess
endfunction

fu! RestoreSess()
    let path_sess = PathSess()
    if filereadable(path_sess)
        execute 'so ' . path_sess
        " if bufexists(1)
        "     for l in range(1, bufnr('$'))
        "         if bufwinnr(l) == -1
        "             exec 'sbuffer ' . l
        "         endif
        "     endfor
        " endif
    endif
endfunction

au VimLeave * call SaveSess()
au VimEnter * nested if argc() == 0 | call RestoreSess() | endif
