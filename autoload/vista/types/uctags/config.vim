
" Autoconf {{{1
let type_autoconf = tagbar#prototypes#typeinfo#new()
let type_autoconf.ctagstype = 'autoconf'
let type_autoconf.kinds = [
    \ {'short': 'p', 'long': 'packages',            'fold': 0, 'stl': 1},
    \ {'short': 't', 'long': 'templates',           'fold': 0, 'stl': 1},
    \ {'short': 'm', 'long': 'autoconf macros',     'fold': 0, 'stl': 1},
    \ {'short': 'w', 'long': '"with" options',      'fold': 0, 'stl': 1},
    \ {'short': 'e', 'long': '"enable" options',    'fold': 0, 'stl': 1},
    \ {'short': 's', 'long': 'substitution keys',   'fold': 0, 'stl': 1},
    \ {'short': 'c', 'long': 'automake conditions', 'fold': 0, 'stl': 1},
    \ {'short': 'd', 'long': 'definitions',         'fold': 0, 'stl': 1},
\ ]
let types.config = type_autoconf
