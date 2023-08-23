if exists("b:current_syntax")
    finish
endif

syntax case ignore

syn match	rimeudbCode	'^[ A-Za-z]\+\s\t[^\t]\+\tc=\d\+\sd=[.e\-0-9]\+\st=\d\+$' contains=rimeudbPhrase
syn match	rimeudbCodeDel	'^[ A-Za-z]\+\s\t[^\t]\+\tc=-\d\+\sd=[.e\-0-9]\+\st=\d\+$' contains=rimeudbPhrase
syn match	rimeudbPhrase	contained '\(\t\)\@1<=[^\t]\+\tc=\d\+\sd=[.e\-0-9]\+\st=\d\+$' contains=rimeudbWeight
syn match	rimeudbWeight	contained '\(\t\)\@1<=c=\d\+\sd=[.e\-0-9]\+\st=\d\+$'
syn region	rimeudbENC	start="enc" end="$"
syn region	rimeudbComment	start="#" end="$"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
command -nargs=+ Hi	hi def <args>

hi def link rimeudbENC		rimeudbComment

hi def link rimeudbCode		Special
hi def link rimeudbCodeDel	TODO
hi def link rimeudbPhrase	String
hi def link rimeudbWeight	Special
hi def link rimeudbComment	Comment

delcommand Hi

let b:current_syntax = "rimeuserdb"

" vim: ts=8
