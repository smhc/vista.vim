
    " HTML {{{1
    let type_html = tagbar#prototypes#typeinfo#new()
    let type_html.ctagstype = 'html'
    let type_html.kinds = [
        \ {'short' : 'a', 'long' : 'named anchors', 'fold' : 0, 'stl' : 1},
        \ {'short' : 'h', 'long' : 'H1 headings',   'fold' : 0, 'stl' : 1},
        \ {'short' : 'i', 'long' : 'H2 headings',   'fold' : 0, 'stl' : 1},
        \ {'short' : 'j', 'long' : 'H3 headings',   'fold' : 0, 'stl' : 1},
    \ ]
    let types.html = type_html
