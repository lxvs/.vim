set nocompatible

if (has('termguicolors'))
    set termguicolors
endif

try
    colorscheme nord
catch
    try
        colorscheme desert
    endtry
endtry

if has('gui_running')
    set guioptions-=m
    set guioptions-=T
    set guifont=Consolas:h11,Courier_New:h11
    set columns=132
    set lines=43
endif

set shellslash
set grepprg=grep\ -nH\ $*
if has('win32')
    set shell=C:/PROGRA~1/Git/usr/bin/bash.exe
    set shellcmdflag=--login\ -c
    set shellpipe=2>&1\ \|\ tee
    set shellredir=>%s\ 2>&1
    let s:vimdir = $HOME .. '/vimfiles'
else
    let s:vimdir = $HOME .. '/.vim'
endif

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set nofixeol
set autochdir
set hidden

set number
set ruler
if has('reltime')
    set incsearch
endif
set ignorecase
set smartcase
set autoindent
set cindent
set smarttab
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=0
set backspace=indent,eol,start
set undolevels=1000
set wildmenu
set wildmode=full

set belloff=all
set listchars=tab:»\ ,trail:·
set list
set foldmethod=manual

set nrformats-=octal
map Q gq
sunmap Q
inoremap <C-U> <C-G>u<C-U>

if 1
    filetype plugin indent on
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line('$') && &ft !~# 'commit'
                \ |   exe 'normal! g`"'
                \ | endif
endif

if &t_Co > 2 || has('gui_running')
    syntax on
    set hlsearch
endif

if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
              \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
    set nolangremap
endif

if ! isdirectory(s:vimdir)
    call mkdir(s:vimdir, '', 0700)
endif
if ! isdirectory(s:vimdir .. '/temp')
    call mkdir(s:vimdir .. '/temp', '', 0700)
endif
let &directory = s:vimdir .. '/temp/'
if has('vms')
    set nobackup
else
    if ! isdirectory(s:vimdir .. '/bak')
        call mkdir(s:vimdir .. '/bak', '', 0700)
    endif
    set backup
    let &backupdir = s:vimdir .. '/bak'
    if has('persistent_undo')
        if ! isdirectory(s:vimdir .. '/undo')
            call mkdir(s:vimdir .. '/undo', '', 0700)
        endif
        set undofile
        let &undodir = s:vimdir .. '/undo/'
    endif
endif

if has('syntax') && has('eval')
    packadd! matchit
endif

inoremap kj <Esc>
cnoremap kj <C-u><BS>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
vnoremap <C-c> "*y
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja
nnoremap <silent> <C-q> :NERDTreeToggle<CR>
inoremap <silent> <C-q> <Esc>:NERDTreeToggle<CR>
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>
cnoremap <C-a> <Home>
nnoremap <Space> za
nnoremap <C-Space> zA

function s:BnextSkipTerm(reverse = 0)
    const start_buf = bufnr('%')
    const cmd = a:reverse ? 'bprev' : 'bnext'
    exec cmd
    while &buftype ==# 'terminal' && bufnr('%') != start_buf
        exec cmd
    endwhile
endfunction
nnoremap <silent> <S-Tab> :call <SID>BnextSkipTerm(1)<CR>
nnoremap <silent> <Tab> :call <SID>BnextSkipTerm()<CR>
nnoremap <silent> <C-PageUp> :call <SID>BnextSkipTerm(1)<CR>
nnoremap <silent> <C-PageDown> :call <SID>BnextSkipTerm()<CR>
inoremap <silent> <C-PageUp> <Esc>:call <SID>BnextSkipTerm(1)<CR>
inoremap <silent> <C-PageDown> <Esc>:call <SID>BnextSkipTerm()<CR>

function s:FoldOnBraces()
    if ! foldlevel(line('.'))
        exec 'normal! zfa{'
    else
        exec 'normal! za'
    endif
    redraw
endfunction

function s:FoldForMarkdown()
    if foldlevel(line('.'))
        exec 'normal! za'
    else
        if search('^#\{1,\} \w', 'bcnW')
            if search('^#\{1,\} \w', 'nW')
                let lcur = line('.')
                let lstart = search('^#\{1,\} [^ \t]', 'bcnW')
                let lend = search('^#\{1,\} [^ \t]', 'nW') - 2
                if lcur <= lend && lstart < lend
                    exec lstart .. ',' .. lend .. 'fold'
                endif
            else
                exec '?^#\{1,\} \w?,$ fold'
            endif
        endif
        redraw
    endif
endfunction

augroup AutoFold
    autocmd!
    autocmd FileType vim setlocal foldmethod=indent
    autocmd FileType c,cpp,h,hpp,sh,markdown
                \ silent! nunmap <buffer> <Space>
    autocmd FileType c,cpp,h,hpp,sh
                \ nnoremap <silent><buffer> <Space> :call <SID>FoldOnBraces()<CR>
    autocmd FileType markdown
                \ nnoremap <silent><buffer> <Space> :call <SID>FoldForMarkdown()<CR>
augroup END

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

function s:InsertHeaderGates()
    const gatename = substitute(toupper(expand('%:t')), '[\.\-]', '_', 'g')
    execute 'normal! ggO#ifndef __' .. gatename .. '__'
    execute 'normal! o#define __' .. gatename .. '__'
    execute 'normal! Go#endif /* __' .. gatename .. '__ */'
    normal! 2O
    normal! k
endfunction
augroup HeaderGates
    autocmd!
    autocmd BufNewFile *.{h,hpp} call <SID>InsertHeaderGates()
augroup END

if ! has('nvim')
    function s:ToggleTerminal(new = 0) abort
        const terms = term_list()
        const newterm = 'botright terminal ++close ' .. &shell .. ' --login -i'
        const newterm_curwin = 'botright terminal ++curwin ++close ' .. &shell .. ' --login -i'
        const otherbuf = len(filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") !=# "terminal"'))
        const onlywin = a:new ? newterm_curwin : (otherbuf ? 'call <SID>BnextSkipTerm(1)' : 'enew')
        if empty(terms)
            exec newterm
            return
        endif
        if &buftype ==# 'terminal'
            if winnr('$') == 1
                exec onlywin
            else
                close
                if a:new
                    exec newterm
                endif
            endif
            return
        endif
        if a:new
            exec newterm
            return
        endif
        const term = terms[-1]
        if bufwinnr(term) < 0
            execute 'botright sbuffer' term
            return
        endif
        if winnr('$') == 1
            exec onlywin
        else
            for win_id in win_findbuf(term)
                let win_nr = win_id2win(win_id)
                if win_nr > 0
                    execute win_nr 'close'
                endif
            endfor
            if a:new
                exec newterm
            endif
        endif
    endfunction
    inoremap <silent> <C-`> <Esc>:call <SID>ToggleTerminal()<CR>
    nnoremap <silent> <C-`> :call <SID>ToggleTerminal()<CR>
    inoremap <silent> <C-1> <Esc>:call <SID>ToggleTerminal(1)<CR>
    nnoremap <silent> <C-1> :call <SID>ToggleTerminal(1)<CR>

    function s:RotateTerm(reverse = 0) abort
        const terms = term_list()
        let len = len(terms)
        if len < 2
            return
        endif
        let idx = a:reverse ? (index(terms, bufnr('%')) +  1) % len : (index(terms, bufnr('%')) -  1) % len
        exec 'buffer' terms[idx]
    endfunction

    set termwinkey=<C-l>
    exec 'tnoremap <silent> <C-`> ' .. &termwinkey .. ':call <SID>ToggleTerminal()<CR>'
    exec 'tnoremap <silent> <C-1> ' .. &termwinkey .. ':call <SID>ToggleTerminal(1)<CR>'
    exec 'tnoremap <silent> <C-Tab> ' .. &termwinkey .. ':call <SID>RotateTerm()<CR>'
    exec 'tnoremap <silent> <C-S-Tab> ' .. &termwinkey .. ':call <SID>RotateTerm(1)<CR>'
    exec 'tnoremap <silent> <C-n> ' .. &termwinkey .. 'N<CR>'
    exec 'tnoremap <silent> <S-Insert> ' .. &termwinkey .. '"*'
    exec 'tnoremap <silent> <C-q> ' .. &termwinkey .. ':NERDTreeToggle<CR>'
endif
