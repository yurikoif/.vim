
let g:rsync_proj_after_save_buffer = 1

fu! RsyncProjConfSave()
    if !isdirectory(g:rsync_proj_conf)
        let l:write_list = []
        for [l:key, l:value] in items(g:rsync_proj_conf_list)
            " echom 'add:' l:key l:value
            call add(l:write_list, l:key . ' ' . l:value)
        endfor
        " echom l:write_list
        call writefile(l:write_list, g:rsync_proj_conf)
    endif
endfunction

fu! RsyncProjConfLoad()
    let g:rsync_proj_conf_list = {}
    let g:rsync_proj_conf = fnamemodify('~', ':p') . '.vim/sessions/rsync.proj.conf'
    if filereadable(g:rsync_proj_conf)
        for l:line in readfile(g:rsync_proj_conf)
            let l:pair = split(l:line)
            let g:rsync_proj_conf_list[l:pair[0]] = l:pair[1]
        endfor
    endif
endfunction

fu! RsyncProjRaw(git_dir, remote_dir)
    let output = system("rsync --exclude='.*.swp --exclude=*build* --exclude=*install*' -avxhz " . a:git_dir . '/ ' . a:remote_dir . '/')
    let lines = split(output, '\n')
    " if len(lines) > 10
    "     let lines = lines[0 : 3] + ['...'] + lines[len(lines) - 4 : len(lines) - 1]
    " endif
    " echom output
    for line in lines
       echom line
    endfor
    if v:shell_error == 0
        return 'rsync successful | ' . a:git_dir . ' --> ' . a:remote_dir
    else
        let line = lines[len(lines) - 1]
        if len(lines) > 100
            let line = line[0 : 100 - 1] . '...'
        endif
        return line . ' | ' . a:git_dir . ' --> ' . a:remote_dir
    endif
endfunction

fu! RsyncProj()
    let git_dir = substitute(system('git rev-parse --show-toplevel 2>&1 | grep -v fatal:'),'\n','','g')
    if !has_key(g:rsync_proj_conf_list, git_dir)
        echom 'not in a registered rsync project directory:' fnamemodify('%', ':p:h')
        for [l:key, l:value] in items(g:rsync_proj_conf_list)
            echom 'registered:' l:key '-->' l:value
        endfor
        return ''
    endif
    return RsyncProjRaw(git_dir, g:rsync_proj_conf_list[git_dir])
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
    echom RsyncProjRaw(git_dir, l:remote_dir)
    let g:rsync_proj_conf_list[git_dir] = l:remote_dir
endfunction


fu! RsyncProjSilent()
    silent let g:rsync_proj_silent_res = RsyncProj()
    if g:rsync_proj_silent_res != ''
        if version >= 800
            fu! Logger(timer)
                " redraw!
                echom g:rsync_proj_silent_res
            endfunction
            let timer = timer_start(1000, 'Logger', {})
        else
            echom g:rsync_proj_silent_res
        endif
    endif
endfunction

au VimLeave * call RsyncProjConfSave()
" au VimEnter * nested if argc() == 0 | call RsyncProjConfLoad() | endif
au VimEnter * call RsyncProjConfLoad()
au BufWritePost * if g:rsync_proj_after_save_buffer | call RsyncProjSilent() | endif

command RsyncProj echo RsyncProj()
command -nargs=1 RsyncProjAdd call RsyncProjAdd('<args>')
command RsyncProjToggle let g:rsync_proj_after_save_buffer = !g:rsync_proj_after_save_buffer
