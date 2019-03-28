
    " Shell script {{{1
    let s:types = {}
    let s:types.lang = 'sh'
    let s:types.kinds     = [
        \ 'f': {'long' : 'functions',    'fold' : 0, 'stl' : 1},
        \ 'a': {'long' : 'aliases',      'fold' : 0, 'stl' : 0},
        \ 's': {'long' : 'script files', 'fold' : 0, 'stl' : 0}
    \ ]
    let types.sh = s:types
    let types.csh = s:types
    let types.zsh = s:types
