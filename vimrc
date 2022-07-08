set nocompatible

if (has("termguicolors"))
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
if has("win32")
    set shell=C:/Progra~1/Git/bin/bash.exe
    set shellcmdflag=-c
    set shellpipe=2>&1\ \|\ tee
    set shellredir=>%s\ 2>&1
    let s:vimdir = $HOME . "/vimfiles"
else
    let s:vimdir = $HOME . "/.vim"
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
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif
endif

if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
              \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
    set nolangremap
endif

if ! isdirectory(s:vimdir . "/temp")
    call mkdir(s:vimdir . "/temp", "", 0700)
endif
let &directory = s:vimdir . "/temp/"
if has("vms")
    set nobackup
else
    if ! isdirectory(s:vimdir . "/bak")
        call mkdir(s:vimdir . "/bak", "", 0700)
    endif
    set backup
    let &backupdir = s:vimdir . "/bak"
    if has('persistent_undo')
        if ! isdirectory(s:vimdir . "/undo")
            call mkdir(s:vimdir . "/undo", "", 0700)
        endif
        set undofile
        let &undodir = s:vimdir . "/undo/"
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
nnoremap <silent> <S-Tab> :bprev<CR>
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <C-PageUp> :bprev<CR>
nnoremap <silent> <C-PageDown> :bnext<CR>
inoremap <silent> <C-PageUp> <Esc>:bprev<CR>
inoremap <silent> <C-PageDown> <Esc>:bnext<CR>
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>
cnoremap <C-a> <Home>
nnoremap <Space> za
nnoremap <C-Space> zA

function! FoldOnBraces()
    if ! foldlevel(line('.'))
        exec "normal! zfa{"
    else
        exec "normal! za"
    endif
    redraw
endfunction

function! FoldForMarkdown()
    if foldlevel(line('.'))
        exec "normal! za"
    else
        if search('^#\{1,\} \w', 'bcnW')
            if search('^#\{1,\} \w', "nW")
                let lcur = line('.')
                let lstart = search('^#\{1,\} [^ \t]', "bcnW")
                let lend = search('^#\{1,\} [^ \t]', "nW") - 2
                if lcur <= lend && lstart < lend
                    exec lstart . "," . lend . "fold"
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
    autocmd FileType c,cpp,h,hpp,sh {
        nunmap <buffer> <Space>
        nnoremap <silent><buffer> <Space> :call FoldOnBraces()<CR>
        }
    autocmd FileType markdown {
        nunmap <buffer> <Space>
        nnoremap <silent><buffer> <Space> :call FoldForMarkdown()<CR>
        }
augroup END

" Remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

function! s:insert_gates()
    let gatename = substitute(toupper(expand("%:t")), "[\.\-]", "_", "g")
    execute "normal! ggO#ifndef __" . gatename . "__"
    execute "normal! o#define __" . gatename . "__"
    execute "normal! Go#endif /* __" . gatename . "__ */"
    normal! 2O
    normal! k
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

if ! has('nvim')
    function ToggleTerminal() abort
        const terms = term_list()
        if empty(terms)
            term ++curwin
        else
            const term = terms[0]
            if bufwinnr(term) < 0
                execute term . 'b'
            else
                bprev
            endif
        endif
    endfunction
    inoremap <silent> <C-`> <Esc>:call ToggleTerminal()<CR>
    nnoremap <silent> <C-`> :call ToggleTerminal()<CR>
    set termwinkey=<C-l>
    exec 'tnoremap <silent> <C-`>' &termwinkey . ':call ToggleTerminal()<CR>'
    exec 'tnoremap <silent> <C-n>' &termwinkey . 'N<CR>'
    exec 'tnoremap <silent> <S-Insert>' &termwinkey . '"*'
    exec 'tnoremap <silent> <C-q>' &termwinkey . ':NERDTreeToggle<CR>'
endif
