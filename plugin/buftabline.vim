" Vim global plugin for rendering the buffer list in the tabline
" Licence:     The MIT License (MIT)
" Commit:      $Format:%H$
" {{{ Copyright (c) 2015 Aristotle Pagaltzis <pagaltzis@gmx.de>
" 
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
" 
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
" 
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
" }}}

if v:version < 700
	echoerr printf('Vim 7 is required for buftabline (this is only %d.%d)',v:version/100,v:version%100)
	finish
endif

if exists('g:loadedBuftabline')
	finish
endif
let g:loadedBuftabline = 1

scriptencoding utf-8

hi default link BufTabLineCurrent TabLineSel
hi default link BufTabLineActive  PmenuSel
hi default link BufTabLineHidden  TabLine
hi default link BufTabLineFill    TabLineFill

let g:buftabline_numbers    = get(g:, 'buftabline_numbers',    0)
let g:buftabline_indicators = get(g:, 'buftabline_indicators', 0)
let g:buftabline_separators = get(g:, 'buftabline_separators', 0)
let g:buftabline_show       = get(g:, 'buftabline_show',       2)
let g:buftabline_plug_max   = get(g:, 'buftabline_plug_max',  10)

augroup BufTabLine
autocmd!
autocmd VimEnter  * call buftabline#update(0)
autocmd TabEnter  * call buftabline#update(0)
autocmd BufAdd    * call buftabline#update(0)
autocmd BufDelete * call buftabline#update(str2nr(expand('<abuf>')))
augroup END

for s:n in range(1, g:buftabline_plug_max) + ( g:buftabline_plug_max > 0 ? [-1] : [] )
	let s:b = s:n == -1 ? -1 : s:n - 1
	execute printf("noremap <silent> <Plug>BufTabLine.Go(%d) :<C-U>exe 'b'.get(buftabline#user_buffers(),%d,'')<cr>", s:n, s:b)
endfor
unlet! s:n s:b

if v:version < 703
	function s:transpile()
		let [ savelist, &list ] = [ &list, 0 ]
		redir => src
			silent function buftabline#render
		redir END
		let &list = savelist
		let src = substitute(src, '\n\zs[0-9 ]*', '', 'g')
		let src = substitute(src, 'strwidth(strtrans(\([^)]\+\)))', 'strlen(substitute(\1, ''\p\|\(.\)'', ''x\1'', ''g''))', 'g')
		return src
	endfunction
	exe "delfunction buftabline#render\n" . s:transpile()
	delfunction s:transpile
endif
