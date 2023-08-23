" Vim syntax file
" Language:	Aptio CIF
" Maintainer:	Liu, Zhao-hui <liuzhaohui@ieisystem.com>
" Last Change:	2023-06-16

if exists("b:current_syntax")
	finish
endif

syntax case ignore

syn keyword	cifCategory	eCore IO Flash CPU eChipset eModule ModulePart eBoard Flavor
syn match	cifEnds		'^<\w\+>$'
syn match	cifRegion	'^\[\w\+\]$'
syn match	cifItem		'^\s*\w\+\(\s*=\)\@='
syn match	cifValue	'\(=\s*\)\@<=\("\{0,1}\)\w\+\2'
syn region	cifString	start=+"+  end=+"+
syn region	cifComment	start="#"  end="$"

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link cifCategory	cifString
hi def link cifNumber	cifValue
hi def link cifRegion	Delimiter
hi def link cifEnds	Function
hi def link cifValue	Constant
hi def link cifItem	Type
hi def link cifString	String
hi def link cifComment	Comment

let b:current_syntax = "aptiocif"

" vim: ts=8 sw=8 noet
