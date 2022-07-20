set nocompatible

if (has('termguicolors'))
    set termguicolors
endif

if has('gui_running')
    set guioptions-=m
    set guioptions-=T
    set guifont=Consolas:h11,Courier_New:h11
    set columns=132
    set lines=43
endif

if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

set shellslash
set grepprg=grep\ -Hnr
let s:vimdir = $HOME .. '/.vim'
if has('win32') || has('win64')
    set runtimepath-=$HOME/vimfiles
    set runtimepath-=$HOME/vimfiles/after
    set runtimepath^=$HOME/.vim
    set runtimepath+=$HOME/.vim/after
    set shell=C:/PROGRA~1/Git/usr/bin/bash.exe
    set shellcmdflag=--login\ -c
    set shellpipe=2>&1\ \|\ tee
    set shellredir=>%s\ 2>&1
endif

let g:is_posix=1
filetype plugin indent on
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set clipboard=
set nofixeol
set autochdir
set hidden
set autoread
set nostartofline
set termwinkey=<C-l>

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
set wildmode=list:longest,longest:full

set title
set cursorline
set noshowmatch
set belloff=all
set listchars=tab:»\ ,trail:·
set list
set foldmethod=manual
set nowrap
set sidescroll=1
set laststatus=2
set noshowmode
let g:lightline = {'colorscheme': 'nord'}
try
    colorscheme nord
catch
    try
        colorscheme desert
    endtry
endtry

let g:diff_translations = 0

set nrformats-=octal
map Q gq
sunmap Q
inoremap <C-U> <C-G>u<C-U>

if &t_Co > 2 || has('gui_running')
    syntax on
    set hlsearch
    unlet! c_comment_strings
endif

if ! exists(':DiffOrig')
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
let &directory = s:vimdir .. '/temp'
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
        let &undodir = s:vimdir .. '/undo'
    endif
endif

if has('syntax') && has('eval')
    packadd! matchit
endif

nnoremap <C-s> <Cmd>w<CR>
inoremap <C-s> <Cmd>w<CR>
xnoremap <C-s> <Cmd>w<CR>
tnoremap <C-s> <Nop>
xnoremap <C-c> "*y
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>
cnoremap <C-a> <Home>
nnoremap <Space> za
nnoremap <C-Space> zA
tnoremap <silent> <C-n> <C-\><C-N>
tnoremap <silent> <S-Insert> "*'

nnoremap <silent> <S-Tab> <Cmd>call vimrc#BnextSkipTerm(1)<CR>
xnoremap <silent> <S-Tab> <Cmd>call vimrc#BnextSkipTerm(1)<CR>
nnoremap <silent> <Tab> <Cmd>call vimrc#BnextSkipTerm()<CR>
xnoremap <silent> <Tab> <Cmd>call vimrc#BnextSkipTerm()<CR>
nnoremap <silent> <C-l> <C-i>
nnoremap <silent> <C-PageUp> <Cmd>call vimrc#BnextSkipTerm(1)<CR>
inoremap <silent> <C-PageUp> <Cmd>call vimrc#BnextSkipTerm(1)<CR>
xnoremap <silent> <C-PageUp> <Cmd>call vimrc#BnextSkipTerm(1)<CR>
nnoremap <silent> <C-PageDown> <Cmd>call vimrc#BnextSkipTerm()<CR>
inoremap <silent> <C-PageDown> <Cmd>call vimrc#BnextSkipTerm()<CR>
xnoremap <silent> <C-PageDown> <Cmd>call vimrc#BnextSkipTerm()<CR>

augroup AutoFold
    autocmd!
    autocmd FileType vim setlocal foldmethod=indent
    autocmd FileType c,cpp,h,hpp,sh,markdown
                \ silent! nunmap <buffer> <Space>
    autocmd FileType c,cpp,h,hpp,sh
                \ nnoremap <silent><buffer> <Space> <Cmd>call vimrc#FoldOnBraces()<CR>
    autocmd FileType markdown
                \ nnoremap <silent><buffer> <Space> <Cmd>call vimrc#FoldForMarkdown()<CR>
augroup END

augroup RemoveTrailingSpaces
    autocmd!
    autocmd BufWrite * call vimrc#RemoveTrailingSpaces()
augroup END

augroup HeaderGates
    autocmd!
    autocmd BufNewFile *.{h,hpp} call vimrc#InsertHeaderGates()
augroup END

augroup FileList
    autocmd!
    autocmd BufNewFile,BufRead */.vim/filelist
                \ nnoremap <buffer><silent> <Leader>o <Cmd>exec 'e ' ..  getline('.')<CR>
    autocmd BUfNewFile,BufRead */.vim/filelist
                \ command! -buffer UpdateFileList exec '!find .. -type f -not -regex ' .. shellescape('^\.\./\..*') .. ' >%'
augroup END

nnoremap <silent> <C-S-q> <Cmd>call vimrc#ToggleTerminal(1)<CR>
inoremap <silent> <C-S-q> <Cmd>call vimrc#ToggleTerminal(1)<CR>
xnoremap <silent> <C-S-q> <Cmd>call vimrc#ToggleTerminal(1)<CR>
tnoremap <silent> <C-S-q> <Cmd>call vimrc#ToggleTerminal(1)<CR>
nnoremap <silent> <C-^> <Cmd>call vimrc#ToggleTerminal(1)<CR>
inoremap <silent> <C-^> <Cmd>call vimrc#ToggleTerminal(1)<CR>
xnoremap <silent> <C-^> <Cmd>call vimrc#ToggleTerminal(1)<CR>
tnoremap <silent> <C-^> <Cmd>call vimrc#ToggleTerminal(1)<CR>
nnoremap <silent> <C-q> <Cmd>call vimrc#ToggleTerminal()<CR>
inoremap <silent> <C-q> <Cmd>call vimrc#ToggleTerminal()<CR>
xnoremap <silent> <C-q> <Cmd>call vimrc#ToggleTerminal()<CR>
tnoremap <silent> <C-q> <Cmd>call vimrc#ToggleTerminal()<CR>

tnoremap <silent> <C-S-Tab> <Cmd>call vimrc#RotateTerm(1)<CR>
tnoremap <silent> <C-Tab> <Cmd>call vimrc#RotateTerm()<CR>
tnoremap <silent> <C-PageUp> <Cmd>call vimrc#RotateTerm(1)<CR>
tnoremap <silent> <C-PageDown> <Cmd>call vimrc#RotateTerm(1)<CR>

command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr vimrc#Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr vimrc#Grep(<f-args>)

cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

augroup VimStartup
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$")
                \           && &filetype !~# 'commit\|gitrebase'
                \           && expand("%") !~ "ADD_EDIT.patch"
                \           && expand("%") !~ "addp-hunk-edit.diff" |
                \   exe "normal! g`\"" |
                \ endif
augroup END
