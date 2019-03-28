
    " Go {{{1
    let type_go = tagbar#prototypes#typeinfo#new()
    let type_go.ctagstype = 'go'
    let type_go.kinds = [
        \ {'short' : 'p', 'long' : 'packages',       'fold' : 0, 'stl' : 0},
        \ {'short' : 'i', 'long' : 'interfaces',     'fold' : 0, 'stl' : 0},
        \ {'short' : 'c', 'long' : 'constants',      'fold' : 0, 'stl' : 0},
        \ {'short' : 's', 'long' : 'structs',        'fold' : 0, 'stl' : 1},
        \ {'short' : 'm', 'long' : 'struct members', 'fold' : 0, 'stl' : 0},
        \ {'short' : 't', 'long' : 'types',          'fold' : 0, 'stl' : 1},
        \ {'short' : 'f', 'long' : 'functions',      'fold' : 0, 'stl' : 1},
        \ {'short' : 'v', 'long' : 'variables',      'fold' : 0, 'stl' : 0}
    \ ]
    let type_go.sro = '.'
    let type_go.kind2scope = {
        \ 's' : 'struct'
    \ }
    let type_go.scope2kind = {
        \ 'struct' : 's'
    \ }
    let types.go = type_go
