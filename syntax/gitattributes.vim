if exists("b:current_syntax")
    finish
endif

syntax case ignore

syn match	gitaPattern	'^\s*\S\+\s\+.*$' contains=gitaAttr
syn match	gitaAttr	contained '\(^\s*\S\+\s\+\)\@<=.*$'
syn region	gitaComment	start="#"  end="$"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
command -nargs=+ Hi	hi def <args>

hi def link gitaPattern		String
hi def link gitaAttr		Statement
hi def link gitaComment		Comment

delcommand Hi

let b:current_syntax = "gitattributes"

" vim: ts=8
