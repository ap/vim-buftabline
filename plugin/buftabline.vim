" Vim global plugin for rendering the buffer list in the tabline
" Licence:     The MIT License (MIT)
" {{{ Copyright (c) 2014 Aristotle Pagaltzis <pagaltzis@gmx.de>
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

scriptencoding utf-8

augroup BufTabLine
autocmd!

hi default link BufTabLineCurrent TabLineSel
hi default link BufTabLineActive  PmenuSel
hi default link BufTabLineHidden  TabLine
hi default link BufTabLineFill    TabLineFill

let s:prev_currentbuf = winbufnr(0)
function! BufTabLine()
	" pick out user buffers (help buffers are always unlisted, but quickfix buffers are not)
	let bufnums = filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')

	" pick up data on all the buffers
	let tabs = []
	let tabs_by_tail = {}
	let currentbuf = winbufnr(0)
	for bufnum in bufnums
		let tab = { 'num': bufnum, 'head': '', 'tail': '', 'label': '', 'hilite': '' }
		let tab.hilite = currentbuf == bufnum ? 'Current' : bufwinnr(bufnum) > 0 ? 'Active' : 'Hidden'
		let bufpath = bufname(bufnum)
		if strlen(bufpath)
			let tab.head = fnamemodify(bufpath, ':p:~:.:h')
			let tab.tail = fnamemodify(bufpath, ':t')
			let tab.label = ' ' . tab.tail . ' '
			let tabs_by_tail[tab.tail] = get(tabs_by_tail, tab.tail, []) + [tab]
		else " scratch buffer or unnamed file?
			let tab.label = -1 < index(['nofile','acwrite'], getbufvar(bufnum, '&buftype')) ? ' ! ' : ' * '
		endif
		let tabs += [tab]
	endfor

	" disambiguate same-basename files by adding trailing path segments
	while 1
		let groups = filter(values(tabs_by_tail),'len(v:val) > 1')
		if ! len(groups) | break | endif
		for group in groups
			call remove(tabs_by_tail, group[0].tail)
			for tab in group
				if strlen(tab.head) && tab.head != '.'
					let tab.tail = fnamemodify(tab.head, ':t') . '/' . tab.tail
					let tab.label = ' ' . tab.tail . ' '
				endif
				let tab.head = fnamemodify(tab.head, ':h')
				let tabs_by_tail[tab.tail] = get(tabs_by_tail, tab.tail, []) + [tab]
			endfor
		endfor
	endwhile

	" now keep the current buffer center-screen as much as possible:

	" 1. setup
	let lft = { 'lasttab':  0, 'cut':  '.', 'indicator': '<', 'width': 0, 'half': &columns / 2 }
	let rgt = { 'lasttab': -1, 'cut': '.$', 'indicator': '>', 'width': 0, 'half': &columns - lft.half }

	" 2. if current buffer not a user buffer, remember the previous one
	"    (to keep the tabline from jumping around e.g. when browsing help)
	if -1 == index(bufnums, currentbuf)
		let currentbuf = s:prev_currentbuf
	else
		let s:prev_currentbuf = currentbuf
	endif

	" 3. sum the string lengths for the left and right halves
	let currentside = lft
	for tab in tabs
		let tab.width = strwidth(tab.label)
		if currentbuf == tab.num
			let halfwidth = tab.width / 2
			let lft.width += halfwidth
			let rgt.width += tab.width - halfwidth
			let currentside = rgt
			continue
		endif
		let currentside.width += tab.width
	endfor
	if 0 == rgt.width " no current window seen?
		" then blame any overflow on the right side, to protect the left
		let [lft.width, rgt.width] = [0, lft.width]
	endif

	" 3. toss away tabs and pieces until all fits:
	if ( lft.width + rgt.width ) > &columns
		for [side,otherside] in [ [lft,rgt], [rgt,lft] ]
			if side.width > side.half
				let remainder = otherside.width < otherside.half ? &columns - otherside.width : side.half
				let delta = side.width - remainder
				" toss entire tabs to close the distance
				while delta >= tabs[side.lasttab].width
					let gain = tabs[side.lasttab].width
					let delta -= gain
					call remove(tabs, side.lasttab, side.lasttab)
				endwhile
				" then snip at the last one to make it fit
				let endtab = tabs[side.lasttab]
				while delta > ( endtab.width - strwidth(endtab.label) )
					let endtab.label = substitute(endtab.label, side.cut, '', '')
				endwhile
				let endtab.label = substitute(endtab.label, side.cut, side.indicator, '')
			endif
		endfor
	endif

	return '%T' . join(map(tabs,'printf("%%#BufTabLine%s#%s",v:val.hilite,v:val.label)'),'') . '%#BufTabLineFill#'
endfunction

function! s:setup()
	if tabpagenr('$') == 1
		set guioptions-=e tabline=%!BufTabLine()
	else
		set guioptions+=e tabline=
	endif
endfunction

autocmd TabEnter * call <SID>setup()

set showtabline=2
call s:setup()
