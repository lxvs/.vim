" Vim syntax file
" Language:     Xcradle Change History
" Written By:   Liu, Zhao-hui <liuzhaohui@ieisystem.com>
" Last Change:  2023-06-27

if exists("b:current_syntax")
  finish
endif

syn case ignore

syn match	xcradlehistoryWarning	'\s\+$'
syn match	xcradlehistoryItem	"^[A-Za-z0-9#_\\/]\+:" nextgroup=xcradlehistoryValue
syn match	xcradlehistoryValue	"\(^[A-Za-z0-9#_\\/]\+:\s\|\t\+\|\s\{4,}\)\@<=.*$"
syn match	xcradlehistoryFilesAuto	"\(^RelatedFiles:\s*\)\@<=.\+$"
syn match	xcradlehistoryFiles	"^\d\+\.\s[^\\]\+$"
syn match       xcradlehistorySpecial    '\s\(N/A\|NA\)$'
syn match       xcradlehistoryComment    '^#.*$'
syn keyword     xcradlehistoryKeyword   high medium low none

" Define the default highlighting.
" Only when an item doesn't have highlighting yet
command -nargs=+ Hi     hi def <args>

hi def link	xcradlehistoryFiles	xcradlehistoryValue
hi def link	xcradlehistoryFilesAuto	xcradlehistorySpecial
hi def link	xcradlehistoryKeyword	xcradlehistorySpecial
hi def link	xcradlehistoryWarning	Error
hi def link	xcradlehistoryComment	Comment
hi def link	xcradlehistoryItem	Type
hi def link	xcradlehistoryValue	Constant
hi def link	xcradlehistorySpecial	Special

delcommand Hi

let b:current_syntax = "xcradlehistory"

" vim: ts=8 sw=8 noet
