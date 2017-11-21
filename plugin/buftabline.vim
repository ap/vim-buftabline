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

scriptencoding utf-8

augroup BufTabLine
autocmd!

hi default link BufTabLineCurrent TabLineSel
hi default link BufTabLineActive  PmenuSel
hi default link BufTabLineHidden  TabLine
hi default link BufTabLineFill    TabLineFill

let g:buftabline_numbers    = get(g:, 'buftabline_numbers',    0)
let g:buftabline_indicators = get(g:, 'buftabline_indicators', 0)
let g:buftabline_separators = get(g:, 'buftabline_separators', 0)
let g:buftabline_show       = get(g:, 'buftabline_show',       2)

function! buftabline#user_buffers() " help buffers are always unlisted, but quickfix buffers are not
	return filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
endfunction

let s:dirsep = fnamemodify(getcwd(),':p')[-1:]
let s:centerbuf = winbufnr(0)
function! buftabline#render()
	let show_num = g:buftabline_numbers == 1
	let show_ord = g:buftabline_numbers == 2
	let show_mod = g:buftabline_indicators
	let lpad     = g:buftabline_separators ? nr2char(0x23B8) : ' '

	let bufnums = buftabline#user_buffers()
	let centerbuf = s:centerbuf " prevent tabline jumping around when non-user buffer current (e.g. help)

	" pick up data on all the buffers
	let tabs = []
	let path_tabs = []
	let tabs_per_tail = {}
	let currentbuf = winbufnr(0)
	let screen_num = 0
	for bufnum in bufnums
		let screen_num = show_num ? bufnum : show_ord ? screen_num + 1 : ''
		let tab = { 'num': bufnum }
		let tab.hilite = currentbuf == bufnum ? 'Current' : bufwinnr(bufnum) > 0 ? 'Active' : 'Hidden'
		if currentbuf == bufnum | let [centerbuf, s:centerbuf] = [bufnum, bufnum] | endif
		let bufpath = bufname(bufnum)
		if strlen(bufpath)
			let tab.path = fnamemodify(bufpath, ':p:~:.')
			let tab.sep = strridx(tab.path, s:dirsep, strlen(tab.path) - 2) " keep trailing dirsep
			let tab.label = tab.path[tab.sep + 1:]
			let pre = ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' ) . screen_num
			let tab.pre = strlen(pre) ? pre . ' ' : ''
			let tabs_per_tail[tab.label] = get(tabs_per_tail, tab.label, 0) + 1
			let path_tabs += [tab]
		elseif -1 < index(['nofile','acwrite'], getbufvar(bufnum, '&buftype')) " scratch buffer
			let tab.label = ( show_mod ? '!' . screen_num : screen_num ? screen_num . ' !' : '!' )
		else " unnamed file
			let tab.label = ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' )
			\             . ( screen_num ? screen_num : '*' )
		endif
		let tabs += [tab]
	endfor

	" disambiguate same-basename files by adding trailing path segments
	while len(filter(tabs_per_tail, 'v:val > 1'))
		let [ambiguous, tabs_per_tail] = [tabs_per_tail, {}]
		for tab in path_tabs
			if -1 < tab.sep && has_key(ambiguous, tab.label)
				let tab.sep = strridx(tab.path, s:dirsep, tab.sep - 1)
				let tab.label = tab.path[tab.sep + 1:]
			endif
			let tabs_per_tail[tab.label] = get(tabs_per_tail, tab.label, 0) + 1
		endfor
	endwhile

	" now keep the current buffer center-screen as much as possible:

	" 1. setup
	let lft = { 'lasttab':  0, 'cut':  '.', 'indicator': '<', 'width': 0, 'half': &columns / 2 }
	let rgt = { 'lasttab': -1, 'cut': '.$', 'indicator': '>', 'width': 0, 'half': &columns - lft.half }

	" 2. sum the string lengths for the left and right halves
	let currentside = lft
	for tab in tabs
		let tab.label = lpad . get(tab, 'pre', '') . tab.label . ' '
		let tab.width = strwidth(strtrans(tab.label))
		if centerbuf == tab.num
			let halfwidth = tab.width / 2
			let lft.width += halfwidth
			let rgt.width += tab.width - halfwidth
			let currentside = rgt
			continue
		endif
		let currentside.width += tab.width
	endfor
	if currentside is lft " centered buffer not seen?
		" then blame any overflow on the right side, to protect the left
		let [lft.width, rgt.width] = [0, lft.width]
	endif

	" 3. toss away tabs and pieces until all fits:
	if ( lft.width + rgt.width ) > &columns
		let [oversized, remainder]
		\ = lft.width < lft.half ? [ [rgt], &columns - lft.width ]
		\ : rgt.width < rgt.half ? [ [lft], &columns - rgt.width ]
		\ :                        [ [lft, rgt], 0 ]
		for side in oversized
			let delta = side.width - ( remainder ? remainder : side.half )
			" toss entire tabs to close the distance
			while delta >= tabs[side.lasttab].width
				let delta -= remove(tabs, side.lasttab).width
			endwhile
			" then snip at the last one to make it fit
			let endtab = tabs[side.lasttab]
			while delta > ( endtab.width - strwidth(strtrans(endtab.label)) )
				let endtab.label = substitute(endtab.label, side.cut, '', '')
			endwhile
			let endtab.label = substitute(endtab.label, side.cut, side.indicator, '')
		endfor
	endif

	if len(tabs) | let tabs[0].label = substitute(tabs[0].label, lpad, ' ', '') | endif

	let swallowclicks = '%'.(1 + tabpagenr('$')).'X'
	return swallowclicks . join(map(tabs,'printf("%%#BufTabLine%s#%s",v:val.hilite,strtrans(v:val.label))'),'') . '%#BufTabLineFill#'
endfunction

function! buftabline#update(deletion)
	set tabline=
	if tabpagenr('$') > 1 | set guioptions+=e showtabline=2 | return | endif
	set guioptions-=e
	if 0 == g:buftabline_show
		set showtabline=1
		return
	elseif 1 == g:buftabline_show
		let bufnums = buftabline#user_buffers()
		let total = len(bufnums)
		if a:deletion && -1 < index(bufnums, str2nr(expand('<abuf>')))
			" BufDelete triggers before buffer is deleted
			" so if the buffer to be deleted is a user buffer, it must be subtracted
			let total -= 1
		endif
		let &g:showtabline = 1 + ( total > 1 )
	elseif 2 == g:buftabline_show
		set showtabline=2
	endif
	set tabline=%!buftabline#render()
endfunction

autocmd BufAdd    * call buftabline#update(0)
autocmd BufDelete * call buftabline#update(1)
autocmd TabEnter  * call buftabline#update(0)
autocmd VimEnter  * call buftabline#update(0)

let c = 1
while c <= 99
    execute "noremap <silent> <Plug>BufTabLine.Go(" . c . ")  :exe 'b'.get(buftabline#user_buffers()," . (c - 1) . ",'')<cr>"
    let c += 1
endwhile

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
