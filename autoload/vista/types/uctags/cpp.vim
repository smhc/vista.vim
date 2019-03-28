
    " C++ {{{1
    let type_cpp = tagbar#prototypes#typeinfo#new()
    let type_cpp.ctagstype = 'c++'
    let type_cpp.kinds     = [
        \ {'short' : 'h', 'long' : 'header files', 'fold' : 1, 'stl' : 0},
        \ {'short' : 'd', 'long' : 'macros',       'fold' : 1, 'stl' : 0},
        \ {'short' : 'p', 'long' : 'prototypes',   'fold' : 1, 'stl' : 0},
        \ {'short' : 'g', 'long' : 'enums',        'fold' : 0, 'stl' : 1},
        \ {'short' : 'e', 'long' : 'enumerators',  'fold' : 0, 'stl' : 0},
        \ {'short' : 't', 'long' : 'typedefs',     'fold' : 0, 'stl' : 0},
        \ {'short' : 'n', 'long' : 'namespaces',   'fold' : 0, 'stl' : 1},
        \ {'short' : 'c', 'long' : 'classes',      'fold' : 0, 'stl' : 1},
        \ {'short' : 's', 'long' : 'structs',      'fold' : 0, 'stl' : 1},
        \ {'short' : 'u', 'long' : 'unions',       'fold' : 0, 'stl' : 1},
        \ {'short' : 'f', 'long' : 'functions',    'fold' : 0, 'stl' : 1},
        \ {'short' : 'm', 'long' : 'members',      'fold' : 0, 'stl' : 0},
        \ {'short' : 'v', 'long' : 'variables',    'fold' : 0, 'stl' : 0}
    \ ]
    let type_cpp.sro        = '::'
    let type_cpp.kind2scope = {
        \ 'g' : 'enum',
        \ 'n' : 'namespace',
        \ 'c' : 'class',
        \ 's' : 'struct',
        \ 'u' : 'union'
    \ }
    let type_cpp.scope2kind = {
        \ 'enum'      : 'g',
        \ 'namespace' : 'n',
        \ 'class'     : 'c',
        \ 'struct'    : 's',
        \ 'union'     : 'u'
    \ }
    let types.cpp = type_cpp
    let types.cuda = type_cpp
