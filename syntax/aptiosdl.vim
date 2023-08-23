" Vim syntax file
" Language:	Aptio SDL
" Maintainer:	Liu, Zhao-hui <liuzhaohui@ieisystem.com>
" Last Change:	2023-06-16

if exists("b:current_syntax")
    finish
endif

syntax case ignore

syn keyword sdlEnds             end token elink pcdmapping path
syn keyword sdlEnds             pcidevice siodevice
syn keyword sdlEnds             INFComponent LibraryMapping
syn keyword sdlEnds             FFS_FILE OUTPUTREGISTER
syn keyword sdlValue            boolean expression integer yes no file
syn keyword sdlValue            ReplaceParent AfterParent BeforeParent
syn match   sdlValue            '\(\(Offset\|Length\)\s*=\s*\)\@<=\d\+h[#\t ]*$'
" syn match   sdlValue            '\(\(token\w\+\|target\w\+\)\s*=\s*\)\@<=\w\+'
syn match   sdlItem             '^\s*\w\+\(\s*=\)\@='
syn region  sdlString		start=+"+  end=+"+
syn region  sdlString		start=+'+  end=+'+
syn region  sdlComment		start="#"  end="$"
syn match   gitConflictSymbol   '^<\{7}\(\s\)\@=\|^=\{7}$\|^>\{7}\(\s\)\@='

syn sync ccomment sdlComment

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
"command -nargs=+ Hi     hi def <args>

hi def link sdlNumber           sdlValue
hi def link gitConflictSymbol   Error
hi def link sdlEnds      	Function
hi def link sdlValue      	Constant
hi def link sdlItem		Type
hi def link sdlString		String
hi def link sdlComment		Comment
hi def link sdlSpecial		Special
hi def link sdlError		Error

"delcommand Hi

let b:current_syntax = "aptiosdl"

" vim: ts=8
