let s:jobs = []

function! s:grep_exit_cb(job, code)
  echomsg index(s:jobs, a:job)
endfunction

function! s:grep_err_cb(ch, line)
  echomsg a:line
endfunction

function! s:grep_out_cb(ch, line)
  let l:line = a:line
  if len(l:line) > 300
    let l:line = l:line[:300]
  endif
  exe 'caddexpr' string(l:line)
endfunction

function! s:grep_start(arg)
  let l:grepprg = substitute(&grepprg, '\\$*', a:arg, '')
  if l:grepprg ==# &grepprg
    let l:grepprg .= ' ' . a:arg
  endif
  let l:job = job_start([&shell, &shellcmdflag, l:grepprg], {
  \ 'out_mode': 'nl',
  \ 'out_cb': function('s:grep_out_cb'),
  \ 'err_cb': function('s:grep_err_cb'),
  \ 'exit_cb': function('s:grep_exit_cb'),
  \})
  call add(s:jobs, l:job)
  copen
  wincmd p
endfunction

function! s:grep_stop()
  for l:job in s:jobs
    call job_stop(l:stop)
  endfor
  let s:jobs = []
endfunction

command! -nargs=* Agrep call s:grep_start(<q-args>)
command! Agrepstop call s:grep_stop()
