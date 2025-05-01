
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

let s:job_output = []

function! s:RawCallback(ch, msg)
    if !empty(a:msg)
        call add(s:job_output, a:msg)
    endif
endfunction

function! s:ExitCallback(silent_call, git_dir, remote_dir, ch, status)
    if !a:silent_call || a:status != 0
        for line in s:job_output
            echom line
        endfor
    endif
    if a:status == 0
        echom 'rsync successful | ' . a:git_dir . ' --> ' . a:remote_dir
    else
        let lines = s:job_output
        let line = lines[len(lines) - 1]
        if len(lines) > 100
            let line = line[0 : 100 - 1] . '...'
        endif
        echom line . ' | ' . a:git_dir . ' --> ' . a:remote_dir
    endif
    let s:job_output = []  " Clear for next use
endfunction

fu! RsyncProjRaw(silent_call, git_dir, remote_dir)
    let cmd = ['rsync', '--exclude=\".*.swp\"', '--exclude=\"*build*\"', '--exclude=\"*install*\"',
                \ '-avxhz', a:git_dir . '/', a:remote_dir . '/']
    let job = job_start(cmd, {
                \ 'out_mode': 'nl',
                \ 'err_mode': 'nl',
                \ 'out_cb': function('s:RawCallback'),
                \ 'err_cb': function('s:RawCallback'),
                \ 'exit_cb': function('s:ExitCallback', [a:silent_call, a:git_dir, a:remote_dir]) })
endfunction

fu! RsyncProj(silent_call)
    let git_dir = substitute(system('git rev-parse --show-toplevel 2>&1 | grep -v fatal:'),'\n','','g')
    if !has_key(g:rsync_proj_conf_list, git_dir)
        echom 'not in a registered rsync project directory:' fnamemodify('%', ':p:h')
        for [l:key, l:value] in items(g:rsync_proj_conf_list)
            echom 'registered:' l:key '-->' l:value
        endfor
        return ''
    endif
    return RsyncProjRaw(a:silent_call, git_dir, g:rsync_proj_conf_list[git_dir])
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
    echom RsyncProjRaw(0, git_dir, l:remote_dir)
    let g:rsync_proj_conf_list[git_dir] = l:remote_dir
endfunction


au VimLeave * call RsyncProjConfSave()
" au VimEnter * nested if argc() == 0 | call RsyncProjConfLoad() | endif
au VimEnter * call RsyncProjConfLoad()
au BufWritePost * if g:rsync_proj_after_save_buffer | silent call RsyncProj(1) | endif

command RsyncProj call RsyncProj(0)
command -nargs=1 RsyncProjAdd call RsyncProjAdd('<args>')
command RsyncProjToggle let g:rsync_proj_after_save_buffer = !g:rsync_proj_after_save_buffer
