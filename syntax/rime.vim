if exists("b:current_syntax")
    finish
endif

syntax case ignore

syn match	rimePhrase	'^[^\t]\+\t\a\+\(\t\d\+$\)\=$' contains=rimeCode
syn match	rimeCode	contained '\t\a\+\(\t\d\+$\)\=$'ms=s+1 contains=rimeWeight
syn match	rimeWeight	contained '\(\t\a\+\)\@<=\t\d\+$'ms=s+1
syn region	rimeComment	start="#"  end="$"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
command -nargs=+ Hi	hi def <args>

hi def link rimePhrase		String
hi def link rimeCode		Special
hi def link rimeWeight		String
hi def link rimeComment		Comment

delcommand Hi

let b:current_syntax = "rime"

" vim: ts=8
