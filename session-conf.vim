
fu! PathSess()
    let home_dir = fnamemodify('~', ':p')
    execute 'silent !mkdir -p ' . home_dir . '.vim/sessions'
    let git_dir = substitute(system('git rev-parse --show-toplevel 2>&1 | grep -v fatal:'),'\n','','g')
    " echo git_dir
    if isdirectory(git_dir)
        let git_dir_name = substitute(git_dir, '/', '.', 'g')
        " echo git_dir_name
        return home_dir . '.vim/sessions/' . git_dir_name . '.vim'
    else
        return home_dir . '.vim/sessions/.session.vim'
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
