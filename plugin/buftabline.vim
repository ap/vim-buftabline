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

if exists('*strwidth')
    function! buftabline#strwidth(expr)
        return strwidth(a:expr)
    endfunction
else
    function! buftabline#normalizecharsforstrwidth(c)
        let nrValue = char2nr(a:c)

        if nrValue < 0x0080 | return '1' " Optimization for ascii
        " These values are generated from the strwidth function on My Machine
        elseif nrValue >= 0x1100  && nrValue <= 0x115f  | return '22'
        elseif nrValue >= 0x2329  && nrValue <= 0x232a  | return '22'
        elseif nrValue >= 0x2e80  && nrValue <= 0x2e99  | return '22'
        elseif nrValue >= 0x2e9b  && nrValue <= 0x2ef3  | return '22'
        elseif nrValue >= 0x2f00  && nrValue <= 0x2fd5  | return '22'
        elseif nrValue >= 0x2ff0  && nrValue <= 0x2ffb  | return '22'
        elseif nrValue >= 0x3000  && nrValue <= 0x303e  | return '22'
        elseif nrValue >= 0x3041  && nrValue <= 0x3096  | return '22'
        elseif nrValue >= 0x3099  && nrValue <= 0x30ff  | return '22'
        elseif nrValue >= 0x3105  && nrValue <= 0x312d  | return '22'
        elseif nrValue >= 0x3131  && nrValue <= 0x318e  | return '22'
        elseif nrValue >= 0x3190  && nrValue <= 0x31ba  | return '22'
        elseif nrValue >= 0x31c0  && nrValue <= 0x31e3  | return '22'
        elseif nrValue >= 0x31f0  && nrValue <= 0x321e  | return '22'
        elseif nrValue >= 0x3220  && nrValue <= 0x3247  | return '22'
        elseif nrValue >= 0x3250  && nrValue <= 0x32fe  | return '22'
        elseif nrValue >= 0x3300  && nrValue <= 0x4dbf  | return '22'
        elseif nrValue >= 0x4e00  && nrValue <= 0xa48c  | return '22'
        elseif nrValue >= 0xa490  && nrValue <= 0xa4c6  | return '22'
        elseif nrValue >= 0xa960  && nrValue <= 0xa97c  | return '22'
        elseif nrValue >= 0xac00  && nrValue <= 0xd7a3  | return '22'
        elseif nrValue >= 0xf900  && nrValue <= 0xfaff  | return '22'
        elseif nrValue >= 0xfe10  && nrValue <= 0xfe19  | return '22'
        elseif nrValue >= 0xfe30  && nrValue <= 0xfe52  | return '22'
        elseif nrValue >= 0xfe54  && nrValue <= 0xfe66  | return '22'
        elseif nrValue >= 0xfe68  && nrValue <= 0xfe6b  | return '22'
        elseif nrValue >= 0xff01  && nrValue <= 0xff60  | return '22'
        elseif nrValue >= 0xffe0  && nrValue <= 0xffe6  | return '22'
        elseif nrValue >= 0x1b000 && nrValue <= 0x1b001 | return '22'
        elseif nrValue >= 0x1f200 && nrValue <= 0x1f202 | return '22'
        elseif nrValue >= 0x1f210 && nrValue <= 0x1f23a | return '22'
        elseif nrValue >= 0x1f240 && nrValue <= 0x1f248 | return '22'
        elseif nrValue >= 0x1f250 && nrValue <= 0x1f251 | return '22'
        elseif nrValue >= 0x0080  && nrValue <= 0x009f  | return '4444'
        elseif nrValue == 0x070f                        | return '666666'
        elseif nrValue >= 0x180b && nrValue <= 0x180e   | return '666666'
        elseif nrValue >= 0x200b && nrValue <= 0x200f   | return '666666'
        elseif nrValue >= 0x202a && nrValue <= 0x202e   | return '666666'
        elseif nrValue >= 0x206a && nrValue <= 0x206f   | return '666666'
        elseif nrValue >= 0xd800 && nrValue <= 0xdfff   | return '666666'
        elseif nrValue == 0xfeff                        | return '666666'
        elseif nrValue >= 0xfff9 && nrValue <= 0xfffb   | return '666666'
        endif
        return '1'
    endfunction

    function! buftabline#strwidth(expr)
        return strlen(substitute(a:expr,'.','\=buftabline#normalizecharsforstrwidth(submatch(0))','g'))
    endfunction
endif

function! buftabline#user_buffers() " help buffers are always unlisted, but quickfix buffers are not
	return filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
endfunction

let s:prev_currentbuf = winbufnr(0)
function! buftabline#render()
	let show_num = g:buftabline_numbers == 1
	let show_ord = g:buftabline_numbers == 2
	let show_mod = g:buftabline_indicators
	let lpad     = g:buftabline_separators ? nr2char(0x23B8) : ' '

	let bufnums = buftabline#user_buffers()

	" pick up data on all the buffers
	let tabs = []
	let tabs_by_tail = {}
	let currentbuf = winbufnr(0)
	let screen_num = 0
	for bufnum in bufnums
		let screen_num = show_num ? bufnum : show_ord ? screen_num + 1 : ''
		let tab = { 'num': bufnum }
		let tab.hilite = currentbuf == bufnum ? 'Current' : bufwinnr(bufnum) > 0 ? 'Active' : 'Hidden'
		let bufpath = bufname(bufnum)
		if strlen(bufpath)
			let bufpath = substitute(fnamemodify(bufpath, ':p:~:.'), '^$', '.', '')
			let suf = isdirectory(bufpath) ? '/' : ''
			if strlen(suf) | let bufpath = fnamemodify(bufpath, ':h') | endif
			let tab.head = fnamemodify(bufpath, ':h')
			let tab.tail = fnamemodify(bufpath, ':t')
			let pre = ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' ) . screen_num
			if strlen(pre) | let pre .= ' ' | endif
			let tab.fmt = pre . '%s' . suf
			let tabs_by_tail[tab.tail] = get(tabs_by_tail, tab.tail, []) + [tab]
		elseif -1 < index(['nofile','acwrite'], getbufvar(bufnum, '&buftype')) " scratch buffer
			let tab.label = ( show_mod ? '!' . screen_num : screen_num ? screen_num . ' !' : '!' )
		else " unnamed file
			let tab.label = ( show_mod && getbufvar(bufnum, '&mod') ? '+' : '' )
			\             . ( screen_num ? screen_num : '*' )
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
					let tab.head = fnamemodify(tab.head, ':h')
				endif
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
		let tab.label = lpad . ( has_key(tab, 'fmt') ? printf(tab.fmt, tab.tail) : tab.label ) . ' '
		let tab.width = buftabline#strwidth(tab.label)
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
				while delta > ( endtab.width - buftabline#strwidth(endtab.label) )
					let endtab.label = substitute(endtab.label, side.cut, '', '')
				endwhile
				let endtab.label = substitute(endtab.label, side.cut, side.indicator, '')
			endif
		endfor
	endif

	if len(tabs) | let tabs[0].label = substitute(tabs[0].label, lpad, ' ', '') | endif

	return '%1X' . join(map(tabs,'printf("%%#BufTabLine%s#%s",v:val.hilite,v:val.label)'),'') . '%#BufTabLineFill#'
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
		if a:deletion && -1 < index(bufnums, bufnr('%'))
			" BufDelete triggers before buffer is deleted
			" so if current buffer is a user buffer, it must be subtracted
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

noremap <silent> <Plug>BufTabLine.Go(1)  :exe 'b'.buftabline#user_buffers()[0]<cr>
noremap <silent> <Plug>BufTabLine.Go(2)  :exe 'b'.buftabline#user_buffers()[1]<cr>
noremap <silent> <Plug>BufTabLine.Go(3)  :exe 'b'.buftabline#user_buffers()[2]<cr>
noremap <silent> <Plug>BufTabLine.Go(4)  :exe 'b'.buftabline#user_buffers()[3]<cr>
noremap <silent> <Plug>BufTabLine.Go(5)  :exe 'b'.buftabline#user_buffers()[4]<cr>
noremap <silent> <Plug>BufTabLine.Go(6)  :exe 'b'.buftabline#user_buffers()[5]<cr>
noremap <silent> <Plug>BufTabLine.Go(7)  :exe 'b'.buftabline#user_buffers()[6]<cr>
noremap <silent> <Plug>BufTabLine.Go(8)  :exe 'b'.buftabline#user_buffers()[7]<cr>
noremap <silent> <Plug>BufTabLine.Go(9)  :exe 'b'.buftabline#user_buffers()[8]<cr>
noremap <silent> <Plug>BufTabLine.Go(10) :exe 'b'.buftabline#user_buffers()[9]<cr>
