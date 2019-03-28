
    " JavaScript {{{1
    let type_javascript = tagbar#prototypes#typeinfo#new()
    let type_javascript.ctagstype = 'javascript'
    let type_javascript.kinds = [
        \ {'short': 'v', 'long': 'global variables', 'fold': 0, 'stl': 0},
        \ {'short': 'C', 'long': 'constants',        'fold': 0, 'stl': 0},
        \ {'short': 'c', 'long': 'classes',          'fold': 0, 'stl': 1},
        \ {'short': 'g', 'long': 'generators',       'fold': 0, 'stl': 0},
        \ {'short': 'p', 'long': 'properties',       'fold': 0, 'stl': 0},
        \ {'short': 'm', 'long': 'methods',          'fold': 0, 'stl': 1},
        \ {'short': 'f', 'long': 'functions',        'fold': 0, 'stl': 1},
    \ ]
    let type_javascript.sro        = '.'
    let type_javascript.kind2scope = {
        \ 'c' : 'class',
        \ 'f' : 'function',
        \ 'm' : 'method',
        \ 'p' : 'property',
    \ }
    let type_javascript.scope2kind = {
        \ 'class'    : 'c',
        \ 'function' : 'f',
    \ }
    let types.javascript = type_javascript
