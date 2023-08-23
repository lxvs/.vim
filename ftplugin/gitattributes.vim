if &filetype == 'gitattributes'
  if exists('b:did_ftplugin')
    finish
  endif
  let b:did_ftplugin = 1

  let s:cpo_save = &cpo
  set cpo&vim

  if &fileformat == 'dos'
      setlocal ff=unix
      let b:undo_ftplugin = "setl ff<"
  endif

  let &cpo = s:cpo_save
  unlet s:cpo_save
endif
" vim: ts=8
