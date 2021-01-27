let s:file_extension_matches = [
  \ 'default'      ,
  \ 'styl'         ,
  \ 'sass'         ,
  \ 'scss'         ,
  \ 'htm'          ,
  \ 'html'         ,
  \ 'erb'          ,
  \ 'slim'         ,
  \ 'ejs'          ,
  \ 'css'          ,
  \ 'less'         ,
  \ 'md'           ,
  \ 'mdx'          ,
  \ 'markdown'     ,
  \ 'rmd'          ,
  \ 'json'         ,
  \ 'js'           ,
  \ 'mjs'          ,
  \ 'jsx'          ,
  \ 'rb'           ,
  \ 'php'          ,
  \ 'py'           ,
  \ 'pyc'          ,
  \ 'pyo'          ,
  \ 'pyd'          ,
  \ 'coffee'       ,
  \ 'mustache'     ,
  \ 'hbs'          ,
  \ 'conf'         ,
  \ 'ini'          ,
  \ 'yml'          ,
  \ 'yaml'         ,
  \ 'toml'         ,
  \ 'bat'          ,
  \ 'jpg'          ,
  \ 'jpeg'         ,
  \ 'bmp'          ,
  \ 'png'          ,
  \ 'webp'         ,
  \ 'gif'          ,
  \ 'ico'          ,
  \ 'twig'         ,
  \ 'cpp'          ,
  \ 'cxx'          ,
  \ 'cc'           ,
  \ 'cp'           ,
  \ 'c'            ,
  \ 'cs'           ,
  \ 'h'            ,
  \ 'hh'           ,
  \ 'hpp'          ,
  \ 'hxx'          ,
  \ 'hs'           ,
  \ 'lhs'          ,
  \ 'lua'          ,
  \ 'java'         ,
  \ 'sh'           ,
  \ 'fish'         ,
  \ 'bash'         ,
  \ 'zsh'          ,
  \ 'ksh'          ,
  \ 'csh'          ,
  \ 'awk'          ,
  \ 'ps1'          ,
  \ 'ml'           ,
  \ 'mli'          ,
  \ 'diff'         ,
  \ 'db'           ,
  \ 'sql'          ,
  \ 'dump'         ,
  \ 'clj'          ,
  \ 'cljc'         ,
  \ 'cljs'         ,
  \ 'edn'          ,
  \ 'scala'        ,
  \ 'go'           ,
  \ 'dart'         ,
  \ 'xul'          ,
  \ 'sln'          ,
  \ 'suo'          ,
  \ 'pl'           ,
  \ 'pm'           ,
  \ 't'            ,
  \ 'rss'          ,
  \ 'f#'           ,
  \ 'fsscript'     ,
  \ 'fsx'          ,
  \ 'fs'           ,
  \ 'fsi'          ,
  \ 'rs'           ,
  \ 'rlib'         ,
  \ 'd'            ,
  \ 'erl'          ,
  \ 'hrl'          ,
  \ 'ex'           ,
  \ 'exs'          ,
  \ 'eex'          ,
  \ 'leex'         ,
  \ 'vim'          ,
  \ 'ai'           ,
  \ 'psd'          ,
  \ 'psb'          ,
  \ 'ts'           ,
  \ 'tsx'          ,
  \ 'jl'           ,
  \ 'pp'           ,
  \ 'vue'          ,
  \ 'elm'          ,
  \ 'swift'        ,
  \ 'dockerfile'   ,
  \ 'git'          ,
  \ 'license'      ,
  \ 'xcplayground' 
\]

let s:file_node_exact_matches = {
  \ 'gruntfile.coffee'                 : 'gruntfile',
  \ 'gruntfile.js'                     : 'gruntfile',
  \ 'gruntfile.ls'                     : 'procfile',
  \ 'gulpfile.coffee'                  : 'gulpfile',
  \ 'gulpfile.js'                      : 'gulpfile',
  \ 'gulpfile.ls'                      : 'gulpfile',
  \ 'mix.lock'                         : 'mix',
  \ 'dropbox'                          : 'dropbox',
  \ '.gitconfig'                       : 'git',
  \ '.gitignore'                       : 'git',
  \ '.gitlab-ci.yml'                   : 'git',
  \ '.bashrc'                          : 'bashrc',
  \ '.zshrc'                           : 'bashrc',
  \ '.vimrc'                           : 'vim',
  \ '.gvimrc'                          : 'vim',
  \ '_vimrc'                           : 'vim',
  \ '_gvimrc'                          : 'vim',
  \ '.bashprofile'                     : 'bashrc',
  \ 'favicon.ico'                      : 'favicon',
  \ 'license'                          : 'license',
  \ 'procfile'                         : 'procfile',
  \ 'dockerfile'                       : 'dockerfile',
  \ 'docker-compose.yml'               : 'dockerfile',
  \ 'makefile'                         : 'makefile',
  \ 'cmakelists.txt'                   : 'cmake',
\}

let s:file_node_pattern_matches = {
  \ '.*jquery.*\.js$'       : 'jquery',
  \ '.*angular.*\.js$'      : 'angular',
  \ '.*backbone.*\.js$'     : 'backbone',
  \ '.*require.*\.js$'      : 'requirejs',
  \ '.*materialize.*\.js$'  : 'materialize',
  \ '.*materialize.*\.css$' : 'materialize',
  \ '.*mootools.*\.js$'     : 'mootols',
  \ '.*vimrc.*'             : 'vim'
\}

function! buftabline#util#getftp(fname)
  " Exact match
  for [key, val] in items(s:file_node_exact_matches)
    if a:fname =~ '\c'.key.'$'
      return val
    endif
  endfor
  " Pattern match
  for [key, val] in items(s:file_node_exact_matches)
    if a:fname =~ key
      return val
    endif
  endfor
  " Extension match
  let fext = fnamemodify(a:fname, ':e')
  for key in s:file_extension_matches
    if fext == key
      return key
    endif
  endfor
  " None match
  return 'default'
endfunction


