" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn case ignore

syn keyword nshStatement    if then else endif for endfor exit set goto
syn keyword nshCmd  alias attrib bcfg cd cls comp connect cp date dblk del
syn keyword nshCmd  devices devtree dh dir disconnect dmem dmpstore
syn keyword nshCmd  drivers drvcfg drvdiag echo edit
syn keyword nshCmd  eficompress efidecompress getmtc
syn keyword nshCmd  guid help hexedit ifconfig ipconfig load
syn keyword nshCmd  loadpcirom ls map mem memmap mkdir mm mode mv
syn keyword nshCmd  openinfo parse pause pci ping reconnect reset rm
syn keyword nshCmd  sermode setsize setvar shift smbiosview stall time
syn keyword nshCmd  timezone touch type unload ver vol


syn match   nshOpt  '\(\a\+\s\+\)\@<=[/-]\a\+'
syn match   nshOpt  '\<-\?\>'

syn keyword nshTodo todo attention note fixme readme
syn region  nshComment  start="#" end="$" contains=nshTodo oneline
syn region  nshString   start=+"+ end=+"+
syn region  nshString   start=+'+ end=+'+
" syn match   nshEcho     '\(^\s*echo\s\)\@<=[^"']\+$' contains=nshEchoOpt
" 2021-03-16: parameters following echo are still considered owned by echo.
syn match   nshEchoOpt  contained '-\(on\|off\)\>'

syn match nshNumber		"\<[1-9]\d*\>"
syn match nshNumber		"\<0x\x\+\>"
syn match nshNumber		"\<0\o*\>"

syn match nshFs     "\<fs\d\+:$"
syn match nshBlk    "\<blk\d\+:$"
syn match nshLabel  '^:\w\+$'
syn match nshLabel  '\(\<goto\s\+\)\@<=\a\+\>'

syn match nshVar    '\(\<set\s\+\(-[vd]\s\+\)\?\)\@<=[A-Za-z_]\w*\>'
syn match nshVar    '%[A-Za-z_]\w*%'
syn match nshVar    '%[A-Za-z]\>'
syn match nshValue  '\(\<set\s\+\(-[vd]\s\+\)\?[A-Za-z_]\w*\s\+\)\@<=\S\+\>' contains=nshString

syn keyword nshConExp   not and or
syn keyword nshMapfunc  efierror pierror oemerror
syn keyword nshBoolfunc isint exist exists available profile
syn keyword nshBinop    gt ugt lt ult ge uge le ule ne eq
syn match   nshBinop    '\s==\s'
syn keyword nshFor      in run

hi def link nshConExp   nshBinop
hi def link nshMapfunc  nshBinop
hi def link nshBoolfunc nshBinop

hi def link nshCmd              Function
hi def link nshVar              Identifier
hi def link nshStatement        Statement
hi def link nshBinop            Statement
hi def link nshFor              Statement
hi def link nshOpt              Special
hi def link nshEchoOpt          Special
hi def link nshValue            Constant
hi def link nshString			String
" hi def link nshEcho  			Constant
hi def link nshComment			Comment
hi def link nshTodo			    Todo
hi def link nshNumber           Constant
hi def link nshLabel            Label
hi def link nshFs               Label
hi def link nshBlk              Label

let b:current_syntax = "efinsh"

let &cpo = s:cpo_save
unlet s:cpo_save
