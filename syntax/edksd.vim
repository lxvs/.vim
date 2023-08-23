if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn keyword	sdItem		contained prompt help flags varid
syn match	sdItem		contained 'option text'
syn keyword	sdConditional   suppressif grayoutif endif ideqval
syn keyword	sdConstant      TRUE FALSE

syn keyword	sdFunction	oneof endoneof
syn keyword	sdOneof		contained oneof
syn keyword	sdSpecial	RESET_REQUIRED STRING_TOKEN OPTION_DEFAULT
syn keyword	sdSpecial	OPTION_DEFAULT_MFG

syn match       sdLvalue        '^[A-Za-z ]\+='me=e-1 transparent contains=sdItem,sdOneof

syn match       sdPreProc       '#\(if\|ifdef\|endif\|define\|else\)\($\|\s\)'
syn match       sdOperator      '\(&&\|||\||\|!\)'

" It's easy to accidentally add a space after a backslash that was intended
" for line continuation.  Some compilers allow it, which makes it
" unpredictable and should be avoided.
syn match	sdBadContinuation "\\\s\+$"ms=s+1
syn match	sdBadContinuation "\\\s*/\{1,2}.*$"ms=s+1

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	sdSpecial	display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn match	sdSpecial	display contained "\\\(u\x\{4}\|U\x\{8}\)"

" syn match	sdSpaceError	display excludenl "\s\+$"
" syn match	sdSpaceError	display " \+\t"me=e-1

syn region      sdComment       start="//" end="$" keepend

syn case ignore
syn match	sdNumbers	display transparent "\<\d\|\.\d" contains=sdNumber,sdOctalError,sdOctal
" Same, but without octal error (for comments)
syn match	sdNumbersCom	display contained transparent "\<\d\|\.\d" contains=sdNumber,sdOctal
syn match	sdNumber	display contained "0x\x\+\>"
syn match	sdOctal		display contained "0\o\+\>" contains=sdOctalZero
syn match	sdOctalZero	display contained "\<0"
syn match	sdOctalError	display contained "0\o*[89]\d*"
syn case match

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet

" hi def link sdLvalue            sdStatement

hi def link sdOneof		sdFunction

hi def link sdOperator		sdStatement
hi def link sdItem		sdStatement

hi def link sdSpecial		Special
hi def link sdFunction		Function
hi def link sdStatement		Statement
hi def link sdConditional	Conditional
hi def link sdLabel		Label
hi def link sdBadContinuation	Error
hi def link sdSpaceError	Error
hi def link sdType		Type
hi def link sdNumbers		Number
hi def link sdComment		Comment
hi def link sdPreProc		PreProc

let b:current_syntax = "edksd"

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8
