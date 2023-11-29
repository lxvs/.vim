function vimrc#BnextSkipTerm(reverse = 0)
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

function vimrc#FoldOnBraces()
    if ! foldlevel(line('.'))
        exec 'normal! zfi{'
    else
        exec 'normal! za'
    endif
    redraw
endfunction

function vimrc#FoldForMarkdown()
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

function vimrc#RemoveTrailingSpaces()
    if &bin || &filetype ==# 'diff' || &filetype ==# 'gitcommit'
                \ || &filetype ==# 'xcradlehistory'
        return
    endif
    silent! %s/\s\+$//ge
    const lasthist = histget('/', -1)
    const lastcmd = split(lasthist, '\s\+')[0]
    if lastcmd ==# '\s\+$'
        call histdel('/', -1)
    endif
endfunction

function vimrc#InsertHeaderGates()
    const gatename = substitute(toupper(expand('%:t')), '[\.\-]', '_', 'g')
    exec 'normal! ggO#ifndef __' .. gatename .. '__'
    exec 'normal! o#define __' .. gatename .. '__'
    exec 'normal! Go#endif /* __' .. gatename .. '__ */'
    normal! 2O
    normal! k
endfunction

function vimrc#ToggleTerminal(new = 0) abort
    const terms = term_list()
    const newterm = 'botright terminal ++close ' .. &shell .. ' --login -i'
    const newterm_curwin = 'botright terminal ++curwin ++close ' .. &shell .. ' --login -i'
    const otherbuf = len(filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&buftype") !=# "terminal"'))
    const onlywin = otherbuf ? 'call vimrc#BnextSkipTerm(1)' : 'enew'
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

function vimrc#RotateTerm(reverse = 0) abort
    const terms = term_list()
    let len = len(terms)
    if len > 1
        let idx = a:reverse ? (index(terms, bufnr('%')) +  1) % len : (index(terms, bufnr('%')) -  1) % len
        exec 'buffer' terms[idx]
    endif
endfunction

function vimrc#Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
