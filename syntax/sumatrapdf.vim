if exists("b:current_syntax")
	finish
endif

syn match  sumatrapdfComment	'^#.*$'

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
command -nargs=+ Hi	hi def <args>

hi def link sumatrapdfComment	Comment

delcommand Hi

let b:current_syntax = "sumatrapdf"

" vim: ts=8 sw=8 noet
