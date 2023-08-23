if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal nolisp
setlocal noautoindent
setlocal nosmartindent
setlocal indentexpr=NshIndent(v:lnum)
setlocal indentkeys=!^F,o,O,0=else,0=elseif,0=endif,0=endfor

if exists('*NshIndent')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function! NshIndent(lnum)
  let l:prevlnum = prevnonblank(a:lnum-1)
  if l:prevlnum == 0
    " top of file
    return 0
  endif

  let l:prevl = substitute(getline(l:prevlnum), '#.*$', '', '')
  let l:thisl = substitute(getline(a:lnum), '#.*$', '', '')
  let l:previ = indent(l:prevlnum)

  let l:ind = l:previ

  if l:prevl =~ '^\s*@\?if\>.*then\s*$' ||
        \ l:prevl =~ '\<else\>\s*$' ||
        \ l:prevl =~ '^\s*@\?for\s\+%\a\s\+'
    let l:ind += shiftwidth()
  endif

  if l:thisl =~ '\s\+endif' ||
        \ l:thisl =~ '\s\+else' ||
        \ l:thisl =~ '\s\+endfor'
    let l:ind -= shiftwidth()
  endif

  return l:ind
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 sts=2 et
