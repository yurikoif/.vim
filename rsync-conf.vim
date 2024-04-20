
fu! RsyncProjConfSave()
    let l:rsync_proj_conf = fnamemodify('~', ':p') . '.vim/sessions/rsync.proj.conf'
    if !isdirectory(rsync_proj_conf)
        let l:write_list = []
        for [l:key, l:value] in items(g:rsync_proj_conf_list)
            echom 'add:' l:key l:value
            call add(l:write_list, l:key . ' ' . l:value)
        endfor
        echom l:write_list
        call writefile(l:write_list, l:rsync_proj_conf)
    endif
endfunction

fu! RsyncProjConfLoad()
    let g:rsync_proj_conf_list = {}
    let l:rsync_proj_conf = fnamemodify('~', ':p') . '.vim/sessions/rsync.proj.conf'
    if filereadable(l:rsync_proj_conf)
        for l:line in readfile(l:rsync_proj_conf)
            let l:pair = split(l:line)
            let g:rsync_proj_conf_list[l:pair[0]] = l:pair[1]
        endfor
    endif
endfunction

fu! RsyncProjRaw(git_dir, remote_dir)
    let output = system("rsync --exclude='.*.swp' -avxhz " . a:git_dir . '/ ' . a:remote_dir . '/')
    let lines = split(output, '\n')
    if len(lines) > 10
        let lines = lines[0 : 4] + ['...'] + lines[len(lines) - 5 : len(lines) - 1]
    endif
    for line in lines
       echom line
    endfor
    if v:shell_error == 0
        echom 'rsync successful:' a:git_dir '-->' a:remote_dir
    else
        echom 'rsync failed:' a:git_dir '-->' a:remote_dir
    endif
    return v:shell_error
endfunction

fu! RsyncProj()
    let git_dir = substitute(system('git rev-parse --show-toplevel 2>&1 | grep -v fatal:'),'\n','','g')
    if !has_key(g:rsync_proj_conf_list, git_dir)
        echom 'not in a rsync project directory:' fnamemodify('%', ':p:h')
        for [l:key, l:value] in items(g:rsync_proj_conf_list)
            echom l:key '-->' l:value
        endfor
        return
    endif
    let code = RsyncProjRaw(git_dir, g:rsync_proj_conf_list[git_dir])
endfunction

fu! RsyncProjAdd(remote_dir)
    let git_dir = substitute(system('git rev-parse --show-toplevel 2>&1 | grep -v fatal:'),'\n','','g')
    if !isdirectory(git_dir)
        echom 'not in a git directory; abort'
        return
    endif
    if a:remote_dir[len(a:remote_dir) - 1] == '/'
        let l:remote_dir = a:remote_dir[0:len(a:remote_dir) - 2]
    else
        let l:remote_dir = a:remote_dir
    endif
    if fnamemodify(git_dir, ':t') != fnamemodify(l:remote_dir, ':t')
        echom 'project directory names do not match:' fnamemodify(git_dir, ':t') '|' fnamemodify(l:remote_dir, ':t') '; abort'
        return
    endif
    let code = RsyncProjRaw(git_dir, l:remote_dir)
    let g:rsync_proj_conf_list[git_dir] = l:remote_dir
endfunction

au VimLeave * call RsyncProjConfSave()
" au VimEnter * nested if argc() == 0 | call RsyncProjConfLoad() | endif
au VimEnter * call RsyncProjConfLoad()

command RsyncProj call RsyncProj()
command -nargs=1 RsyncProjAdd call RsyncProjAdd('<args>')
