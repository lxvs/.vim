" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal noet
setlocal ts=8
setlocal sw=8
let b:undo_indent = "setl et< ts< sw<"
