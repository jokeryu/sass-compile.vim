"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/sass-compile.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:save_cpo = &cpo
set cpo&vim

if !exists("g:sass_compile_cdloop")
    let g:sass_compile_cdloop = 5
endif
if !exists("g:sass_compile_sassdir")
    let g:sass_compile_sassdir = ['scss', 'sass', 'css', 'stylesheet']
endif
if !exists("g:sass_compile_cssdir")
    let g:sass_compile_cssdir = ['css', 'stylesheet']
endif
if !exists("g:sass_compile_aftercmd")
    let g:sass_compile_aftercmd = ''
endif
if !exists("g:sass_compile_option")
    let g:sass_compile_option = ''
endif

function! sasscompile#CompassCheck()
    if filereadable('config.rb')
        return 1
    endif
    return 0
endfunction
function! sasscompile#SassCheck()
    let css = ''
    for e in g:sass_compile_cssdir
        if isdirectory(e)
            let css = e
            break
        endif
    endfor
    return css
endfunction

function! sasscompile#CompassConfig()
    let confile = searchparent#File('config.rb')

    if confile != ''
        exec 'e '.confile
    endif
endfunction

function! sasscompile#SassCompile()
    let fdir = expand('%:p:h')
    let compassconf = searchparent#File('config.rb')
    let cmd = ''
    let compassFlg = 0

    if compassconf != ''
        let cdir = fnamemodify(compassconf, ':h')
        exec 'silent cd '.cdir
    endif

    let dir = searchparent#Dir(g:sass_compile_cssdir)
    let sdir = searchparent#Dir(g:sass_compile_sassdir)
    if dir != ''
        let cmd = 'sass --update '.g:sass_compile_option.' '.sdir.':'.dir
    endif

    if cmd != ''
        if g:sass_compile_beforecmd != ''
            call system(g:sass_compile_beforecmd)
        endif
        if g:sass_compile_aftercmd != ''
            " let cmd = "sasscompileresult=$(".cmd."|sed s/'\[[0-9]*m'/''/g|tr '\\n' '__'|tr ' ' '_')\n ".g:sass_compile_aftercmd
            let cmd .= " && sasscompiledist=".dir."\n "
            let cmd .= g:sass_compile_aftercmd
        endif

        " let cmd = '('.cmd.')&'

        redir @a
            call system(cmd)
        redir END

        " cgetexpr @a
        " copen
    endif

    exec 'silent cd '.fdir
endfunction

let &cpo = s:save_cpo
