" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal noet
setlocal ts=16
setlocal sw=16
let b:undo_indent = "setl et< ts< sw<"
