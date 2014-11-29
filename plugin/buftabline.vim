" Vim global plugin for rendering the buffer list in the tabline
" Licence:     The MIT License (MIT)
" Commit:      $Format:%H$
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

function! buftabline#user_buffers() " help buffers are always unlisted, but quickfix buffers are not
	return filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
endfunction

let s:prev_currentbuf = winbufnr(0)
function! buftabline#render()
	let show_num = exists('g:buftabline_numbers')    ? g:buftabline_numbers    : 0
	let show_mod = exists('g:buftabline_indicators') ? g:buftabline_indicators : 0
	let show_sep = exists('g:buftabline_separators') ? g:buftabline_separators : 0

	let lpad = show_sep ? nr2char(0x23B8) : ' '
	let bufnums = buftabline#user_buffers()

	" pick up data on all the buffers
	let tabs = []
	let tabs_by_tail = {}
	let currentbuf = winbufnr(0)
	for bufnum in bufnums
		let tab = { 'num': bufnum }
		let tab.hilite = currentbuf == bufnum ? 'Current' : bufwinnr(bufnum) > 0 ? 'Active' : 'Hidden'
		let bufpath = bufname(bufnum)
		if strlen(bufpath)
			let bufpath = fnamemodify(bufpath, ':p:~:.')
			let suf = isdirectory(bufpath) ? '/' : ''
			if strlen(suf) | let bufpath = fnamemodify(bufpath, ':h') | endif
			let tab.head = fnamemodify(bufpath, ':h')
			let tab.tail = fnamemodify(bufpath, ':t')
			let pre = ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' ) . ( show_num ? bufnum : '' )
			if strlen(pre) | let pre .= ' ' | endif
			let tab.fmt = lpad . pre . '%s' . suf . ' '
			let tabs_by_tail[tab.tail] = get(tabs_by_tail, tab.tail, []) + [tab]
		elseif -1 < index(['nofile','acwrite'], getbufvar(bufnum, '&buftype')) " scratch buffer
			let tab.label = lpad . ( show_num ? show_mod ? '!' . bufnum . ' ' : bufnum . ' ! ' : '! ' )
		else " unnamed file
			let tab.label = lpad
						\ . ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' )
						\ . ( show_num ? bufnum . ' ' : '* ' )
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
		if has_key(tab, 'fmt') | let tab.label = printf(tab.fmt, tab.tail) | endif
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

	if len(tabs) | let tabs[0].label = substitute(tabs[0].label, lpad, ' ', '') | endif

	return '%T' . join(map(tabs,'printf("%%#BufTabLine%s#%s",v:val.hilite,v:val.label)'),'') . '%#BufTabLineFill#'
endfunction

function! buftabline#update(deletion)
	set tabline=
	if tabpagenr('$') > 1 | set guioptions+=e showtabline=2 | return | endif
	set guioptions-=e
	let show = exists('g:buftabline_show') ? g:buftabline_show : 2
	if 0 == show
		set showtabline=1
		return
	elseif 1 == show
		let bufnums = buftabline#user_buffers()
		let total = len(bufnums)
		if a:deletion && -1 < index(bufnums, bufnr('%'))
			" BufDelete triggers before buffer is deleted
			" so if current buffer is a user buffer, it must be subtracted
			let total -= 1
		endif
		let &g:showtabline = 1 + ( total > 1 )
	elseif 2 == show
		set showtabline=2
	endif
	set tabline=%!buftabline#render()
endfunction

autocmd BufAdd    * call buftabline#update(0)
autocmd BufDelete * call buftabline#update(1)
autocmd TabEnter  * call buftabline#update(0)
autocmd VimEnter  * call buftabline#update(0)
