function! s:grepadd(ch, line)
  exe 'caddexpr' string(a:line)
endfunction

function! Agrep(arg)
  let grepprg = substitute(&grepprg, '\\$*', a:arg, '')
  if grepprg ==# &grepprg
    let grepprg .= ' ' . a:arg
  endif
  let s:job = job_start([&shell, &shellcmdflag, grepprg], {'in_mode': 'nl', 'out_cb': function('s:grepadd')})
endfunction


command! -nargs=* Agrep call Agrep(<q-args>)
