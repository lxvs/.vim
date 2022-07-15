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

function s:BnextSkipTerm(reverse = 0)
    const otherbuflist = filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") !=# "terminal"')
    const otherbuflen = len(otherbuflist)
    if otherbuflen == 0 || otherbuflen < 2 && &buftype !=# 'terminal'
        return
    endif
    const curbuf = bufnr('%')
    const curidx = index(otherbuflist, curbuf)
    if curidx == -1
        const buflist = filter(range(1, bufnr('$')), 'buflisted(v:val)')
        const cmdbpn = a:reverse ? 'bprev' : 'bnext'
        exec cmdbpn
        while &buftype ==# 'terminal' && bufnr('%') != curbuf
            exec cmdbpn
        endwhile
    else
        const cmd = 'b ' .. otherbuflist[(a:reverse ? curidx - 1 : curidx + 1) % otherbuflen]
        exec cmd
    endif
endfunction

nnoremap <silent> <S-Tab> <Cmd>call <SID>BnextSkipTerm(1)<CR>
xnoremap <silent> <S-Tab> <Cmd>call <SID>BnextSkipTerm(1)<CR>
nnoremap <silent> <Tab> <Cmd>call <SID>BnextSkipTerm()<CR>
xnoremap <silent> <Tab> <Cmd>call <SID>BnextSkipTerm()<CR>
nnoremap <silent> <C-l> <C-i>
nnoremap <silent> <C-PageUp> <Cmd>call <SID>BnextSkipTerm(1)<CR>
inoremap <silent> <C-PageUp> <Cmd>call <SID>BnextSkipTerm(1)<CR>
xnoremap <silent> <C-PageUp> <Cmd>call <SID>BnextSkipTerm(1)<CR>
nnoremap <silent> <C-PageDown> <Cmd>call <SID>BnextSkipTerm()<CR>
inoremap <silent> <C-PageDown> <Cmd>call <SID>BnextSkipTerm()<CR>
xnoremap <silent> <C-PageDown> <Cmd>call <SID>BnextSkipTerm()<CR>

function s:FoldOnBraces()
    if ! foldlevel(line('.'))
        exec 'normal! zfi{'
    else
        exec 'normal! za'
    endif
    redraw
endfunction

function s:FoldForMarkdown()
    if foldlevel(line('.'))
        exec 'normal! za'
    else
        if ! search('^#\{1,\} \w', 'bcnW')
            return
        endif
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
        redraw
    endif
endfunction

augroup AutoFold
    autocmd!
    autocmd FileType vim setlocal foldmethod=indent
    autocmd FileType c,cpp,h,hpp,sh,markdown
                \ silent! nunmap <buffer> <Space>
    autocmd FileType c,cpp,h,hpp,sh
                \ nnoremap <silent><buffer> <Space> <Cmd>call <SID>FoldOnBraces()<CR>
    autocmd FileType markdown
                \ nnoremap <silent><buffer> <Space> <Cmd>call <SID>FoldForMarkdown()<CR>
augroup END

function s:RemoveTrailingSpaces()
    if &bin
        return
    endif
    silent! %s/\s\+$//ge
    const lasthist = histget('/', -1)
    const lastcmd = split(lasthist, '\s\+')[0]
    if lastcmd ==# '\s\+$'
        call histdel('/', -1)
    endif
endfunction

augroup RemoveTrailingSpaces
    autocmd!
    autocmd BufWrite * call s:RemoveTrailingSpaces()
augroup END

function s:InsertHeaderGates()
    const gatename = substitute(toupper(expand('%:t')), '[\.\-]', '_', 'g')
    exec 'normal! ggO#ifndef __' .. gatename .. '__'
    exec 'normal! o#define __' .. gatename .. '__'
    exec 'normal! Go#endif /* __' .. gatename .. '__ */'
    normal! 2O
    normal! k
endfunction
augroup HeaderGates
    autocmd!
    autocmd BufNewFile *.{h,hpp} call <SID>InsertHeaderGates()
augroup END

augroup FileList
    autocmd!
    autocmd BufNewFile,BufRead */.vim/filelist
                \ nnoremap <buffer><silent> <C-\><C-O> <Cmd>e <C-R>=getline('.')<CR><CR>
    autocmd BUfNewFile,BufRead */.vim/filelist
                \ command! -buffer UpdateFileList exec '!find .. -type f -not -regex ' .. shellescape('^\.\./\..*') .. ' >%'
augroup END

function s:ToggleTerminal(new = 0) abort
    const terms = term_list()
    const newterm = 'botright terminal ++close ' .. &shell .. ' --login -i'
    const newterm_curwin = 'botright terminal ++curwin ++close ' .. &shell .. ' --login -i'
    const otherbuf = len(filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") !=# "terminal"'))
    const onlywin = otherbuf ? 'call <SID>BnextSkipTerm(1)' : 'enew'
    let nameterm = 'silent! keepalt file Terminal'
    if empty(terms)
        exec newterm
        exec nameterm bufnr('%')
    else
        if &buftype ==# 'terminal'
            if winnr('$') == 1
                if a:new
                    exec newterm_curwin
                    exec nameterm bufnr('%')
                else
                    exec onlywin
                endif
            else
                close!
                if a:new
                    exec newterm
                    exec nameterm bufnr('%')
                endif
            endif
        else
            if a:new
                exec newterm
                exec nameterm bufnr('%')
            else
                const term = terms[-1]
                if bufwinnr(term) < 0
                    exec 'botright sbuffer' term
                else
                    if winnr('$') == 1
                        exec onlywin
                    else
                        for win_id in win_findbuf(term)
                            let win_nr = win_id2win(win_id)
                            if win_nr > 0
                                exec win_nr 'close!'
                            endif
                        endfor
                    endif
                endif
            endif
        endif
    endif
    file
    checktime
endfunction

nnoremap <silent> <C-S-q> <Cmd>call <SID>ToggleTerminal(1)<CR>
inoremap <silent> <C-S-q> <Cmd>call <SID>ToggleTerminal(1)<CR>
xnoremap <silent> <C-S-q> <Cmd>call <SID>ToggleTerminal(1)<CR>
tnoremap <silent> <C-S-q> <Cmd>call <SID>ToggleTerminal(1)<CR>
nnoremap <silent> <C-^> <Cmd>call <SID>ToggleTerminal(1)<CR>
inoremap <silent> <C-^> <Cmd>call <SID>ToggleTerminal(1)<CR>
xnoremap <silent> <C-^> <Cmd>call <SID>ToggleTerminal(1)<CR>
tnoremap <silent> <C-^> <Cmd>call <SID>ToggleTerminal(1)<CR>
nnoremap <silent> <C-q> <Cmd>call <SID>ToggleTerminal()<CR>
inoremap <silent> <C-q> <Cmd>call <SID>ToggleTerminal()<CR>
xnoremap <silent> <C-q> <Cmd>call <SID>ToggleTerminal()<CR>
tnoremap <silent> <C-q> <Cmd>call <SID>ToggleTerminal()<CR>

function s:RotateTerm(reverse = 0) abort
    const terms = term_list()
    let len = len(terms)
    if len > 1
        let idx = a:reverse ? (index(terms, bufnr('%')) +  1) % len : (index(terms, bufnr('%')) -  1) % len
        exec 'buffer' terms[idx]
    endif
endfunction

tnoremap <silent> <C-S-Tab> <Cmd>call <SID>RotateTerm(1)<CR>
tnoremap <silent> <C-Tab> <Cmd>call <SID>RotateTerm()<CR>
tnoremap <silent> <C-PageUp> <Cmd>call <SID>RotateTerm(1)<CR>
tnoremap <silent> <C-PageDown> <Cmd>call <SID>RotateTerm(1)<CR>

set termwinkey=<C-l>

function s:Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr <SID>Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr <SID>Grep(<f-args>)

cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
