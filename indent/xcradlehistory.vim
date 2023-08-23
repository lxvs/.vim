" Vim indent file
" Language:     Xcradle Change History
" Maintainer:   Liu Zhao-hui <liuzhaohui@ieisystem.com>
" Last Change:  2021-05-27
"

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=IhIndent(v:lnum)
setlocal indentkeys+=<:>
setlocal textwidth=74
setlocal expandtab

let b:undo_indent = "setl ai< tw< et<"

if exists('*IhIndent')
  finish
endif

function! IhIndent(lnum)
  let l:prevlnum = prevnonblank(a:lnum-1)
  if l:prevlnum == 0
    " top of file
    return 0
  endif

  " grab the previous and current line, stripping comments.
  let l:prevl = getline(l:prevlnum)
  let l:thisl = getline(a:lnum)
  let l:previ = indent(l:prevlnum)

  let l:ind = l:previ

  if l:prevl =~? '^Symptom:\s\w\+'
    if l:prevl !~? '\<\(None\|N\/A\|NA\)$'
      let l:ind = 9
    endif
  elseif l:prevl =~? '^RootCause:\s\w\+'
    if l:prevl !~? '\<\(None\|N\/A\|NA\)$'
      let l:ind = 11
    endif
  elseif l:prevl =~? '^Solution:\s\w\+'
    if l:prevl !~? '\<\(None\|N\/A\|NA\)$'
      let l:ind = 10
    endif
  elseif l:prevl =~? '^SolutionDependency:\s\w\+'
    if l:prevl !~? '\<\(None\|N\/A\|NA\)$'
      let l:ind = 20
    endif
  endif

  if l:thisl =~? '\(RootCause\|Solution\|SolutionDependency\|RelatedFiles\):'
    let l:ind = 0
  endif

  return l:ind
endfunction

" vim: sw=2 sts=2 et
