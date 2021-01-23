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

"the original values would be 24 bit color but apparently that is not possible
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "519aba"
let s:darkBlue = "03589c"
let s:purple = "a074c4"
let s:darkPurple = "854cc7"
let s:lightPurple = "834F79"
let s:juliaPurple = "9558B2"
let s:red = "cc3e44"
let s:darkRed = "a90533"
let s:beige = "F5C06F"
let s:yellow = "cbcb41"
let s:orange = "D4843E"
let s:darkOrange = "e37933"
let s:pink = "f55385"
let s:salmon = "EE6E73"
let s:green = "8dc149"
let s:darkGreen = "019833"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:gray = "6d8086"
let s:darkGray = "4d5a5e"

let s:file_extension_colors = {
  \ 'styl'     : s:green,
  \ 'sass'     : s:pink,
  \ 'scss'     : s:pink,
  \ 'htm'      : s:darkOrange,
  \ 'html'     : s:darkOrange,
  \ 'erb'      : s:red,
  \ 'slim'     : s:orange,
  \ 'ejs'      : s:yellow,
  \ 'css'      : s:blue,
  \ 'less'     : s:darkBlue,
  \ 'md'       : s:blue,
  \ 'mdx'      : s:blue,
  \ 'markdown' : s:blue,
  \ 'rmd'      : s:blue,
  \ 'json'     : s:yellow,
  \ 'js'       : s:yellow,
  \ 'mjs'      : s:yellow,
  \ 'jsx'      : s:blue,
  \ 'rb'       : s:red,
  \ 'php'      : s:purple,
  \ 'py'       : s:blue,
  \ 'pyc'      : s:blue,
  \ 'pyo'      : s:blue,
  \ 'pyd'      : s:blue,
  \ 'coffee'   : s:brown,
  \ 'mustache' : s:orange,
  \ 'hbs'      : s:orange,
  \ 'conf'     : s:gray,
  \ 'ini'      : s:gray,
  \ 'yml'      : s:gray,
  \ 'yaml'     : s:gray,
  \ 'toml'     : s:gray,
  \ 'bat'      : s:gray,
  \ 'jpg'      : s:aqua,
  \ 'jpeg'     : s:aqua,
  \ 'bmp'      : s:aqua,
  \ 'png'      : s:aqua,
  \ 'webp'     : s:aqua,
  \ 'gif'      : s:aqua,
  \ 'ico'      : s:aqua,
  \ 'twig'     : s:green,
  \ 'cpp'      : s:blue,
  \ 'cxx'      : s:blue,
  \ 'cc'       : s:blue,
  \ 'cp'       : s:blue,
  \ 'c'        : s:blue,
  \ 'cs'       : s:blue,
  \ 'h'        : s:blue,
  \ 'hh'       : s:blue,
  \ 'hpp'      : s:blue,
  \ 'hxx'      : s:blue,
  \ 'hs'       : s:beige,
  \ 'lhs'      : s:beige,
  \ 'lua'      : s:blue,
  \ 'java'     : s:red,
  \ 'sh'       : s:darkGray,
  \ 'fish'     : s:green,
  \ 'bash'     : s:darkGray,
  \ 'zsh'      : s:darkGray,
  \ 'ksh'      : s:darkGray,
  \ 'csh'      : s:darkGray,
  \ 'awk'      : s:white,
  \ 'ps1'      : s:darkGray,
  \ 'ml'       : s:darkOrange,
  \ 'mli'      : s:darkOrange,
  \ 'diff'     : s:darkGray,
  \ 'db'       : s:pink,
  \ 'sql'      : s:pink,
  \ 'dump'     : s:pink,
  \ 'clj'      : s:green,
  \ 'cljc'     : s:green,
  \ 'cljs'     : s:green,
  \ 'edn'      : s:blue,
  \ 'scala'    : s:red,
  \ 'go'       : s:blue,
  \ 'dart'     : s:darkBlue,
  \ 'xul'      : s:darkOrange,
  \ 'sln'      : s:darkPurple,
  \ 'suo'      : s:darkPurple,
  \ 'pl'       : s:blue,
  \ 'pm'       : s:blue,
  \ 't'        : s:blue,
  \ 'rss'      : s:darkOrange,
  \ 'f#'       : s:darkBlue,
  \ 'fsscript' : s:blue,
  \ 'fsx'      : s:blue,
  \ 'fs'       : s:blue,
  \ 'fsi'      : s:blue,
  \ 'rs'       : s:blue,
  \ 'rlib'     : s:blue,
  \ 'd'        : s:red,
  \ 'erl'      : s:darkRed,
  \ 'hrl'      : s:pink,
  \ 'ex'       : s:purple,
  \ 'exs'      : s:purple,
  \ 'eex'      : s:purple,
  \ 'leex'     : s:white,
  \ 'vim'      : s:darkGreen,
  \ 'ai'       : s:darkOrange,
  \ 'psd'      : s:darkBlue,
  \ 'psb'      : s:darkBlue,
  \ 'ts'       : s:blue,
  \ 'tsx'      : s:blue,
  \ 'jl'       : s:juliaPurple,
  \ 'pp'       : s:white,
  \ 'vue'      : s:green,
  \ 'elm'      : s:white,
  \ 'swift'    : s:darkOrange,
  \ 'xcplayground' : s:orange
\}

let s:file_node_exact_matches = {
  \ 'gruntfile.coffee'                 : s:yellow,
  \ 'gruntfile.js'                     : s:yellow,
  \ 'gruntfile.ls'                     : s:yellow,
  \ 'gulpfile.coffee'                  : s:pink,
  \ 'gulpfile.js'                      : s:pink,
  \ 'gulpfile.ls'                      : s:pink,
  \ 'mix.lock'                         : s:white,
  \ 'dropbox'                          : s:blue,
  \ '.ds_store'                        : s:white,
  \ '.gitconfig'                       : s:white,
  \ '.gitignore'                       : s:white,
  \ '.gitlab-ci.yml'                   : s:orange,
  \ '.bashrc'                          : s:white,
  \ '.zshrc'                           : s:white,
  \ '.vimrc'                           : s:green,
  \ '.gvimrc'                          : s:green,
  \ '_vimrc'                           : s:green,
  \ '_gvimrc'                          : s:green,
  \ '.bashprofile'                     : s:white,
  \ 'favicon.ico'                      : s:yellow,
  \ 'license'                          : s:white,
  \ 'node_modules'                     : s:green,
  \ 'react.jsx'                        : s:blue,
  \ 'typescript.jsx'                   : s:blue,
  \ 'typescript.tsx'                   : s:blue,
  \ 'procfile'                         : s:purple,
  \ 'dockerfile'                       : s:blue,
  \ 'docker-compose.yml'               : s:blue,
  \ 'makefile'                         : s:white,
  \ 'cmakelists.txt'                   : s:white
\}

let s:file_node_pattern_matches = {
  \ '.*jquery.*\.js$'       : s:blue,
  \ '.*angular.*\.js$'      : s:red,
  \ '.*backbone.*\.js$'     : s:darkBlue,
  \ '.*require.*\.js$'      : s:blue,
  \ '.*materialize.*\.js$'  : s:salmon,
  \ '.*materialize.*\.css$' : s:salmon,
  \ '.*mootools.*\.js$'     : s:white,
  \ '.*vimrc.*'             : s:green,
  \ 'Vagrantfile$'          : s:blue
\}

" let s:characters = '[ a-zA-Z0-9_\#\-\+\*\%\!\~\(\)\{\}\&\.\$\@]'
" substitute will 'eliminate' single backlashes on the string
" let s:chars_double_lashes = substitute(s:characters, '\\', '\\\\', 'g')

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
  " let regexp = '\v'.s:characters.'+\.'.substitute(key, '\W', '\\\0', 'g')

  if exists('g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols["'.key.'"]')
    let icon = g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols[key]
    " exec 'silent syn match '.icon_identifier.' \zs'.icon.'\ze.\+\.'.key.'$' 
    " exec 'silent syn match '.icon_identifier.' \zs'.icon.'\ze.\+\.'.key.'\W*\*$' 
    exec 'silent syn match '.icon_identifier.' "\zs'.icon.'\ze"' 
    exec 'hi def link '.icon_identifier.' BufTabLineNumCurrent'
  endif

  if val != ''
    call s:X(icon_identifier, val, '', '')
  endif
endfor


