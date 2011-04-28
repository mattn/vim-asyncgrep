function! asyncgrep#add(n,qf)
  let nr = bufnr(a:n)
  if nr == -1
    exe 'badd '.escape(a:n, ' ')
    let nr = bufnr('$')
  endif
  let a:qf['bufnr'] = nr
  call setqflist(add(getqflist(), a:qf))
  redraw
  return ""
endfunction
