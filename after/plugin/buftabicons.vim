" Sets the highlighting for the given group
fun! s:X(group, fg, bg, attr)
  if a:fg != ""
    exec "silent hi " . a:group . " guifg=#" . a:fg
  endif
  if a:bg != ""
    exec "silent hi " . a:group . " guibg=#" . a:bg
  endif
  if a:attr != ""
    exec "silent hi " . a:group . " gui=" . a:attr
  endif
endfun

let s:file_extension_colors = {
  \ 'default'      : 'ffffff',
  \ 'styl'         : '8dc149',
  \ 'sass'         : 'f55385',
  \ 'scss'         : 'f55385',
  \ 'htm'          : 'e37933',
  \ 'html'         : 'e37933',
  \ 'erb'          : 'cc3e44',
  \ 'slim'         : 'd4843e',
  \ 'ejs'          : 'cbcb41',
  \ 'css'          : '519aba',
  \ 'less'         : '03589c',
  \ 'md'           : '519aba',
  \ 'mdx'          : '519aba',
  \ 'markdown'     : '519aba',
  \ 'rmd'          : '519aba',
  \ 'json'         : 'cbcb41',
  \ 'js'           : 'cbcb41',
  \ 'mjs'          : 'cbcb41',
  \ 'jsx'          : '519aba',
  \ 'rb'           : 'cc3e44',
  \ 'php'          : 'a074c4',
  \ 'py'           : '519aba',
  \ 'pyc'          : '519aba',
  \ 'pyo'          : '519aba',
  \ 'pyd'          : '519aba',
  \ 'coffee'       : '905532',
  \ 'mustache'     : 'd4843e',
  \ 'hbs'          : 'd4843e',
  \ 'conf'         : '6d8086',
  \ 'ini'          : '6d8086',
  \ 'yml'          : '6d8086',
  \ 'yaml'         : '6d8086',
  \ 'toml'         : '6d8086',
  \ 'bat'          : '6d8086',
  \ 'jpg'          : '3affdb',
  \ 'jpeg'         : '3affdb',
  \ 'bmp'          : '3affdb',
  \ 'png'          : '3affdb',
  \ 'webp'         : '3affdb',
  \ 'gif'          : '3affdb',
  \ 'ico'          : '3affdb',
  \ 'twig'         : '8dc149',
  \ 'cpp'          : '519aba',
  \ 'cxx'          : '519aba',
  \ 'cc'           : '519aba',
  \ 'cp'           : '519aba',
  \ 'c'            : '519aba',
  \ 'cs'           : '519aba',
  \ 'h'            : '519aba',
  \ 'hh'           : '519aba',
  \ 'hpp'          : '519aba',
  \ 'hxx'          : '519aba',
  \ 'hs'           : 'f5c06f',
  \ 'lhs'          : 'f5c06f',
  \ 'lua'          : '519aba',
  \ 'java'         : 'cc3e44',
  \ 'sh'           : '4d5a5e',
  \ 'fish'         : '8dc149',
  \ 'bash'         : '4d5a5e',
  \ 'zsh'          : '4d5a5e',
  \ 'ksh'          : '4d5a5e',
  \ 'csh'          : '4d5a5e',
  \ 'awk'          : 'ffffff',
  \ 'ps1'          : '4d5a5e',
  \ 'ml'           : 'e37933',
  \ 'mli'          : 'e37933',
  \ 'diff'         : '4d5a5e',
  \ 'db'           : 'f55385',
  \ 'sql'          : 'f55385',
  \ 'dump'         : 'f55385',
  \ 'clj'          : '8dc149',
  \ 'cljc'         : '8dc149',
  \ 'cljs'         : '8dc149',
  \ 'edn'          : '519aba',
  \ 'scala'        : 'cc3e44',
  \ 'go'           : '519aba',
  \ 'dart'         : '03589c',
  \ 'xul'          : 'e37933',
  \ 'sln'          : '854cc7',
  \ 'suo'          : '854cc7',
  \ 'pl'           : '519aba',
  \ 'pm'           : '519aba',
  \ 't'            : '519aba',
  \ 'rss'          : 'e37933',
  \ 'f#'           : '03589c',
  \ 'fsscript'     : '519aba',
  \ 'fsx'          : '519aba',
  \ 'fs'           : '519aba',
  \ 'fsi'          : '519aba',
  \ 'rs'           : '519aba',
  \ 'rlib'         : '519aba',
  \ 'd'            : 'cc3e44',
  \ 'erl'          : 'a90533',
  \ 'hrl'          : 'f55385',
  \ 'ex'           : 'a074c4',
  \ 'exs'          : 'a074c4',
  \ 'eex'          : 'a074c4',
  \ 'leex'         : 'ffffff',
  \ 'vim'          : '019833',
  \ 'ai'           : 'e37933',
  \ 'psd'          : '03589c',
  \ 'psb'          : '03589c',
  \ 'ts'           : '519aba',
  \ 'tsx'          : '519aba',
  \ 'jl'           : '9558be',
  \ 'pp'           : 'ffffff',
  \ 'vue'          : '8dc149',
  \ 'elm'          : 'ffffff',
  \ 'swift'        : 'e37933',
  \ 'dockerfile'   : '519aba',
  \ 'git'          : 'e37933',
  \ 'license'      : 'cbcb41',
  \ 'xcplayground' : 'd4843e'
\}

if !exists('g:BufTabLineHiColor')
  let g:BufTabLineHiColor = {}
endif

for [key, val] in items(s:file_extension_colors)
  if !has_key(g:BufTabLineHiColor, key)
    let g:BufTabLineHiColor[key] = val
  endif
endfor

for [key, val] in items(g:BufTabLineHiColor)
  let icon_identifier = 'buftablineIcon_'.key

  if exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols["'.key.'"]')
    let icon = g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols[key]
    exec 'silent syn match '.icon_identifier.' "\zs'.icon.'\ze"' 
    exec 'hi def link '.icon_identifier.' BufTabLineNumCurrent'
  endif

  if val != ''
    call s:X(icon_identifier, val, '', '')
  endif
endfor


