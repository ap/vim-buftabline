" references to mention:
" minibufexpl http://www.vim.org/scripts/script.php?script_id=159
" buftabs http://www.vim.org/scripts/script.php?script_id=1664
" airline http://www.vim.org/scripts/script.php?script_id=4661
" BufLine http://www.vim.org/scripts/script.php?script_id=4940
" wintabs https://github.com/zefei/vim-wintabs

scriptencoding utf-8

augroup BufTabLine
autocmd!

hi default link BufTabLineCurrent TabLineSel
hi default link BufTabLineActive  PmenuSel
hi default link BufTabLineHidden  TabLine
hi default link BufTabLineFill    TabLineFill

function! s:is_scratch(bufnum)
	return -1 != index(['nofile','acwrite'], getbufvar(a:bufnum, '&buftype'), 0, 1)
endfunction

function! s:user_buffers() " help buffers are always unlisted, but quickfix windows are not
	return filter(range(1,bufnr('$')),'buflisted(v:val) && "quickfix" !=? getbufvar(v:val, "&buftype")')
endfunction

let s:prev_currentbuf = winbufnr(0)
function! BufTabLine()
	let tabs = []

	" pick up data on all the buffers
	let bufnums = s:user_buffers()
	let currentbuf = winbufnr(0)
	for bufnum in bufnums
		let bufpath    = bufname(bufnum)
		let bufactive  = bufwinnr(bufnum) > 0
		let tab = {
			\ 'num'    : bufnum,
			\ 'head'   : strlen(bufpath) ? fnamemodify(bufpath, ':p:~:.:h') : '',
			\ 'tail'   : strlen(bufpath) ? fnamemodify(bufpath, ':t') : '',
			\ 'label'  : strlen(bufpath) ? '' : s:is_scratch(bufnum) ? ' ! ' : ' * ',
			\ 'hilite' : currentbuf == bufnum ? 'Current' : bufactive ? 'Active' : 'Hidden',
			\ }
		let tabs += [tab]
	endfor

	" disambiguate same-basename files by adding trailing path segments
	let tabs_by_tail = {}
	for tab in tabs
		if strlen(tab.label) | continue | endif
		let tab.label = ' ' . tab.tail . ' '
		let group = get(tabs_by_tail, tab.tail, []) + [tab]
		let tabs_by_tail[tab.tail] = group
	endfor
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
				let group = get(tabs_by_tail, tab.tail, []) + [tab]
				let tabs_by_tail[tab.tail] = group
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
