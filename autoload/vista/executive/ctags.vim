" Copyright (c) 2019 Liu-Cheng Xu
" MIT License
" vim: ts=2 sw=2 sts=2 et

let s:provider = fnamemodify(expand('<sfile>'), ':t:r')

let s:reload_only = v:false
let s:should_display = v:false

let s:ctags = get(g:, 'vista_ctags_executable', 'ctags')
let s:support_json_format =
      \ len(filter(split(system(s:ctags.' --list-features'), '\n'), 'v:val =~ "^json"')) > 0

let s:language_opt = {
      \ 'ant'        : ['ant'        , 'pt']            ,
      \ 'asm'        : ['asm'        , 'dlmt']          ,
      \ 'aspperl'    : ['asp'        , 'fsv']           ,
      \ 'aspvbs'     : ['asp'        , 'fsv']           ,
      \ 'awk'        : ['awk'        , 'f']             ,
      \ 'beta'       : ['beta'       , 'fsv']           ,
      \ 'c'          : ['c'          , 'dgsutvf']       ,
      \ 'cpp'        : ['c++'        , 'nvdtcgsuf']     ,
      \ 'cs'         : ['c#'         , 'dtncEgsipm']    ,
      \ 'cobol'      : ['cobol'      , 'dfgpPs']        ,
      \ 'delphi'     : ['pascal'     , 'fp']            ,
      \ 'dosbatch'   : ['dosbatch'   , 'lv']            ,
      \ 'eiffel'     : ['eiffel'     , 'cf']            ,
      \ 'erlang'     : ['erlang'     , 'drmf']          ,
      \ 'expect'     : ['tcl'        , 'cfp']           ,
      \ 'fortran'    : ['fortran'    , 'pbceiklmntvfs'] ,
      \ 'go'         : ['go'         , 'fctv']          ,
      \ 'html'       : ['html'       , 'af']            ,
      \ 'java'       : ['java'       , 'pcifm']         ,
      \ 'javascript' : ['javascript' , 'f']             ,
      \ 'lisp'       : ['lisp'       , 'f']             ,
      \ 'lua'        : ['lua'        , 'f']             ,
      \ 'make'       : ['make'       , 'm']             ,
      \ 'matlab'     : ['matlab'     , 'f']             ,
      \ 'ocaml'      : ['ocaml'      , 'cmMvtfCre']     ,
      \ 'pascal'     : ['pascal'     , 'fp']            ,
      \ 'perl'       : ['perl'       , 'clps']          ,
      \ 'php'        : ['php'        , 'cdvf']          ,
      \ 'python'     : ['python'     , 'cmf']           ,
      \ 'rexx'       : ['rexx'       , 's']             ,
      \ 'ruby'       : ['ruby'       , 'cfFm']          ,
      \ 'rust'       : ['rust'       , 'fgsmcti']     ,
      \ 'scheme'     : ['scheme'     , 'sf']            ,
      \ 'sh'         : ['sh'         , 'f']             ,
      \ 'csh'        : ['sh'         , 'f']             ,
      \ 'zsh'        : ['sh'         , 'f']             ,
      \ 'scala'      : ['scala'      , 'ctTmlp']        ,
      \ 'slang'      : ['slang'      , 'nf']            ,
      \ 'sml'        : ['sml'        , 'ecsrtvf']       ,
      \ 'sql'        : ['sql'        , 'cFPrstTvfp']    ,
      \ 'tex'        : ['tex'        , 'ipcsubPGl']     ,
      \ 'tcl'        : ['tcl'        , 'cfmp']          ,
      \ 'vera'       : ['vera'       , 'cdefgmpPtTvx']  ,
      \ 'verilog'    : ['verilog'    , 'mcPertwpvf']    ,
      \ 'vhdl'       : ['vhdl'       , 'PctTrefp']      ,
      \ 'vim'        : ['vim'        , 'avf']           ,
      \ 'yacc'       : ['yacc'       , 'l']             ,
      \ }

let s:language_opt = map(s:language_opt,
      \ 'printf("--language-force=%s --%s-types=%s", v:val[0], v:val[0], v:val[1])')

function! s:GetCustomCmd(ft) abort
  if exists('g:vista_ctags_cmd') && has_key(g:vista_ctags_cmd, a:ft)
    return g:vista_ctags_cmd[a:ft]
  endif
  return v:null
endfunction

" FIXME support all languages that ctags does
function! s:Cmd(file) abort
  let ft = &filetype

  let custom_cmd = s:GetCustomCmd(ft)

  if custom_cmd isnot v:null
    let cmd = printf('%s %s', custom_cmd, a:file)
    return cmd
  endif

  if ft ==# 'cpp'
    let opt = '--c++-kinds=+p'
  else
    let opt = printf('--language-force=%s', ft)
  endif

  if has_key(s:language_opt, ft)
    let opt = s:language_opt[ft]
  endif

  " TODO vista_ctags_{filetype}_executable
  if s:support_json_format
    let cmd = printf('%s --excmd=number --sort=no --fields=Ks  --fields=+n --output-format=json %s -f- %s', s:ctags, opt, a:file)
    let s:TagParser = function('vista#parser#ctags#TagFromJSON')
  else
    let cmd = printf('%s --excmd=number --sort=no --fields=Ks %s -f- %s', s:ctags, opt, a:file)
    let s:TagParser = function('vista#parser#ctags#ExtractTag')
  endif

  return cmd
endfunction

function! s:on_exit(_job, _data, _event) abort dict
  if v:dying | return | endif

  " Second last line is the real last one in neovim
  call s:ExtractLinewise(self.stdout[:-2])

  call s:ApplyExtracted()
endfunction

function! s:close_cb(channel)
  let s:data = {}
  let t:vista.functions = []

  while ch_status(a:channel, {'part': 'out'}) ==# 'buffered'
    let line = ch_read(a:channel)
    call call(s:TagParser, [line, s:data])
  endwhile

  call s:ApplyExtracted()
endfunction

function! s:ApplyExtracted() abort
  " Update cache when new data comes.
  let s:cache = get(s:, 'cache', {})
  let s:cache[s:fpath] = s:data
  let s:cache.ftime = getftime(s:fpath)
  let s:cache.bufnr = bufnr('')

  if s:reload_only
    call vista#sidebar#Reload(s:data)
    let s:reload_only = v:false
    return
  endif

  if s:should_display
    call vista#viewer#Display(s:data)
    let s:should_display = v:false
  endif
endfunction

function! s:ExtractLinewise(raw_data) abort
  let s:data = {}
  let t:vista.functions = []
  call map(a:raw_data, 'call(s:TagParser, [v:val, s:data])')
endfunction

function! s:AutoUpdate(fpath) abort
  let s:reload_only = v:true
  call s:ApplyExecute(v:false, a:fpath)
endfunction

" Run ctags synchronously given the cmd
function! s:ApplyRun(cmd) abort
  let output = system(a:cmd)
  if v:shell_error
    return vista#error#('Fail to run ctags: '.a:cmd)
  endif

  let s:cache = get(s:, 'cache', {})
  let s:cache.fpath = s:fpath

  call s:ExtractLinewise(split(output, "\n"))
endfunction

" Run ctags asynchronously given the cmd
function! s:ApplyRunAsync(cmd) abort
  if has('nvim')
    " job is job id in neovim
    let jobid = jobstart(a:cmd, {
            \ 'stdout_buffered': 1,
            \ 'stderr_buffered': 1,
            \ 'on_exit': function('s:on_exit')
            \ })
  else
    let job = job_start(a:cmd, {
          \ 'close_cb':function('s:close_cb')
          \ })
    let jobid = matchstr(job, '\d\+') + 0
  endif

  return jobid > 0 ? jobid : 0
endfunction

" Use a temporary files for ctags processing instead of the original one.
" This allows using Tagbar for files accessed with netrw, and also doesn't
" slow down Tagbar for files that sit on slow network drives.
" This idea comes from tagbar.
function! s:IntoTemp(...) abort
  let tmp = tempname()
  let ext = vista#source#Extension()
  if ext != ''
    let tmp = join([tmp, ext], '.')
  endif

  if empty(a:1)
    let lines = vista#source#Lines()
  else
    let lines = readfile(a:1)
  endif

  if writefile(lines, tmp) == 0
    return tmp
  else
    return vista#error#('Fail to write into a temp file.')
  endif
endfunction

function! s:ApplyExecute(bang, fpath) abort
  let file = s:IntoTemp(a:fpath)
  if empty(file)
    return
  endif

  let cmd = s:Cmd(file)

  if a:bang
    call s:ApplyRun(cmd)
  else
    if exists('s:id')
      call vista#util#JobStop(s:id)
    endif

    let s:id = s:ApplyRunAsync(cmd)

    if s:id == 0
      call vista#error#RunCtags(cmd)
    endif
  endif
endfunction

function! s:Run(fpath) abort
  let file = s:IntoTemp(a:fpath)
  if empty(file)
    return
  endif

  let s:fpath = a:fpath

  let cmd = s:Cmd(file)
  call s:ApplyRun(cmd)

  return s:data
endfunction

function! s:RunAsync(fpath) abort
  let file = s:IntoTemp(a:fpath)
  if empty(file)
    return
  endif

  let cmd = s:Cmd(file)

  if exists('s:id')
    call vista#util#JobStop(s:id)
  endif

  let s:id = s:ApplyRunAsync(cmd)

  if !s:id
    call vista#error#RunCtags(cmd)
  endif
endfunction

function! s:Execute(bang, should_display) abort
  let s:should_display = a:should_display
  let s:fpath = expand('%:p')
  call s:ApplyExecute(a:bang, s:fpath)
endfunction

function! s:Dispatch(F, ...) abort
  let ft = &filetype
  let custom_cmd = s:GetCustomCmd(ft)

  let exe = custom_cmd isnot v:null ? split(custom_cmd)[0] : 'ctags'

  if !executable(exe)
    call vista#error#Need(exe)
    return
  endif

  return call(function(a:F), a:000)
endfunction

function! vista#executive#ctags#Cache() abort
  return get(s:, 'cache', {})
endfunction

" Run ctags given the cmd synchronously
function! vista#executive#ctags#Run(fpath) abort
  return s:Dispatch('s:Run', a:fpath)
endfunction

" Run ctags given the cmd asynchronously
function! vista#executive#ctags#RunAsync(fpath) abort
  call s:Dispatch('s:RunAsync', a:fpath)
endfunction

function! vista#executive#ctags#Execute(bang, should_display) abort
  call vista#SetProvider(s:provider)
  call vista#autocmd#Init('VistaCtags', function('s:AutoUpdate'))
  return s:Dispatch('s:Execute', a:bang, a:should_display)
endfunction

function! vista#executive#ctags#ProjectRun() abort
  " https://github.com/universal-ctags/ctags/issues/2042
  "
  " If ctags has the json format feature, we should use the
  " `--output-format=json` option, which is easier to parse and more reliable.
  " Otherwise we will use the `--_xformat` option.
  if s:support_json_format
    let cmd = s:ctags." -R -x --output-format=json --fields=+n"
    let Parser = function('vista#parser#ctags#ProjectTagFromJSON')
  else
    let cmd = s:ctags." -R -x --_xformat='TAGNAME:%N ++++ KIND:%K ++++ LINE:%n ++++ INPUT-FILE:%F ++++ PATTERN:%P'"
    let Parser = function('vista#parser#ctags#ProjectTagFromXformat')
  endif

  let output = system(cmd)
  if v:shell_error
    return vista#error#RunCtags(cmd)
  endif

  let s:data = {}

  call map(split(output, "\n"), 'call(Parser, [v:val, s:data])')

  return s:data
endfunction
