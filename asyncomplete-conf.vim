" let g:asyncomplete_min_chars=2

inoremap <silent><expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<CR>"

" register asyncomplete.vim sources
if has('python3')
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \ 'name': 'ultisnips',
        \ 'allowlist': ['*'],
        \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
        \ 'priority': 8,
        \ }))
endif
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'priority': 4,
    \ }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \ 'name': 'tags',
    \ 'allowlist': ['*'],
    \ 'completor': function('asyncomplete#sources#tags#completor'),
    \ 'priority': 2,
    \ }))

function! s:sort_by_priority_preprocessor(options, matches) abort
    let l:priorities = {}
    for l:source_name in keys(a:matches)
        let l:priorities[l:source_name] = get(asyncomplete#get_source_info(l:source_name), 'priority', 0)
    endfor
    let l:source_names = sort(keys(l:priorities), {a, b -> l:priorities[b] - l:priorities[a]})
    let l:items = []
    for l:source_name in l:source_names
        for l:item in a:matches[l:source_name]['items']
            if stridx(l:item['word'], a:options['base']) == 0
                call add(l:items, l:item)
            endif
        endfor
    endfor

    call asyncomplete#preprocess_complete(a:options, l:items)
endfunction
let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]
