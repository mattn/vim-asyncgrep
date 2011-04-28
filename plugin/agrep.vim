function! Agrep(arg)
  if len(v:servername) == 0
    echohl Error
    echo "Your vim don't support client/server"
    echohl None
    return
  endif
  if len(globpath(&rtp, 'script/vimremote'.(has('win32')||has('win64')?'.exe':''))) == 0
    echohl Error
    echo "You don't have vimremote"
    echo "Please install: https://github.com/ynkdir/vim-remote"
    echohl None
    return
  endif
  call setqflist([])
  let grep = escape(globpath(&rtp, 'script/asyncgrep.pl'), '\\')
  if has('win32') || has('win64')
    silent exe '!start /min perl "'.grep.'" '.v:servername.' '.a:arg
  else
    silent exe '!perl "'.grep.'" '.v:servername.' '.a:arg.' 2>&1 /dev/null &'
  endif
endfunction


command! -nargs=* Agrep call Agrep(<q-args>)
