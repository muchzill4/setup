" File: lettherebelight.vim
" Description: And the Master said: 'let there be light'
" Repo: 
" Author: muchzill4 <muchzill4@gmail.com>
"
" Thanks:
" - Bram Moolenaar for this wonderful editor
" - Steve Losh (stevelosh.com) for badwolf and learnvimscriptthehardway! 
" - Ethan Schoonover (ethanschoonover.com) for Solarized

" Init: {{{

if !has("gui_running") && &t_Co != 88 && &t_Co != 256
    finish
endif

set background=dark

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "lettherebelight"

" }}}
" Highlighting Function: {{{

function! s:HL(group, fg, ...)
	" Arguments: group, guifg, guibg, gui, guisp

	let histring = 'hi ' . a:group . ' '

	if strlen(a:fg)
		if a:fg == 'fg'
			let histring .= 'guifg=fg ctermfg=fg '
		elseif a:fg == 'bg'
			let histring .= 'guifg=bg ctermfg=bg '
		elseif a:fg == 'none'
			let histring .= 'guifg=NONE ctermfg=NONE '
		else
			let c = get(s:pal, a:fg)
			let histring .= 'guifg=#' . c[0] . ' ctermfg=' . c[1] . ' '
		endif
	endif

	if a:0 >= 1 && strlen(a:1)
		if a:1 == 'bg'
			let histring .= 'guibg=bg ctermbg=bg '
		elseif a:fg == 'fg'
			let histring .= 'guibg=fg ctermbg=fg '
		elseif a:1 == 'none'
			let histring .= 'guibg=NONE ctermfg=NONE '
		else
			let c = get(s:pal, a:1)
			let histring .= 'guibg=#' . c[0] . ' ctermbg=' . c[1] . ' '
		endif
	else
		let histring .= 'guibg=NONE ctermbg=NONE '
	endif

	if a:0 >= 2 && strlen(a:2)
		if a:2 == 'none'
			let histring .= 'gui=NONE cterm=NONE '
		else
			let histring .= 'gui=' . a:2 . ' cterm=' . a:2 . ' '
	endif
	else
		let histring .= 'gui=NONE cterm=NONE '
	endif

	if a:0 >= 3 && strlen(a:3)
		if a:3 == 'none'
			let histring .= 'guisp=NONE '
		else
			let c = get(s:pal, a:3)
			let histring .= 'guisp=#' . c[0] . ' '
		endif
	endif

	execute histring
endfunction

function! s:ParseColorscheme(scheme)

	for [group, line] in items(a:scheme)
		let fg = s:getPaletteColors(line[0])
		let bg = s:getPaletteColors(line[1])
		let attr = line[2] == '' ? 'NONE' : line[2]
		exec printf("hi %s guifg=%s guibg=%s gui=%s ctermfg=%s ctermbg=%s cterm=%s", group, fg[0], bg[0], attr, fg[1], bg[1], attr)
	endfor

endfunction

function! s:getPaletteColors(x)


	let c = get(s:pal, a:x)
	" TODO: make me better!
	if len(c) == 1
		return ['NONE', 'NONE']
	else
		return ['#'.c[0], c[1]]
	endfor

endfunction

" }}}
" Palette: {{{

let s:pal = {}

let s:pal.0 = ['172024', 0]
let s:pal.1 = ['d40051', 1]
let s:pal.2 = ['74c954', 2]
let s:pal.3 = ['f39f08', 3]
let s:pal.4 = ['3a81c8', 4]
let s:pal.5 = ['aa37b4', 5]
let s:pal.6 = ['5f919a', 6]
let s:pal.7 = ['d0bfaf', 7]
let s:pal.8 = ['283c43', 8]
let s:pal.9 = ['ea511d', 9]
let s:pal.10 = ['b5e42a', 10]
let s:pal.11 = ['fdc438', 11]
let s:pal.12 = ['8acddc', 12]
let s:pal.13 = ['cb83e2', 13]
let s:pal.14 = ['80cdbd', 14]
let s:pal.15 = ['dfdedb', 15]

let s:pal['asphalt'] = ['555555', 236]
let s:pal['smoke'] = ['bbbbbb', 241]
let s:pal['coal'] = ['000000', 232]

" }}}
" TODO
" Colorscheme:

" .-----------------.------------.------------.------------.
" | Highlight group | Foreground | Background | Attributes |
" |-----------------|------------|------------|------------|
let s:cs = {
\  'Normal':        [ 15         , 0          , ''         ]
\, 'Visual':        [ 15         , 8          , ''         ]
\
\, 'Search':        [ 0          , 11         , 'bold'     ]
\, 'Title':         [ ''         , ''         , ''         ]
\, 'NonText':       [ 8          , ''         , ''         ]
\, 'SpecialKey':    [ 8          , ''         , ''         ]
\, 'MatchParen':    [ 0         , 7           , 'bold'     ]
\
\, 'StatusLine':    [ 0          , 14         , 'bold'     ]
\, 'StatusLineNC':  [ 14         , 8          , ''         ]
\, 'TabLine':       [ 14         , 8          , ''         ]
\, 'TabLineSel':    [ 0          , 14         , 'bold'     ]
\, 'TabLineFill':   [ 15         , 8          , ''         ]
\, 'Directory':     [ 6          , ''         , 'bold'     ]
\
\, 'Cursor':        [ 0          , 1          , ''         ]
\, 'CursorLine':    [ ''         , ''         , ''         ]
\, 'CursorColumn':  [ ''         , ''         , ''         ]
\, 'ColorColumn':   [ ''         , ''         , ''         ]
\, 'CursorLineNr':  [ 1          , ''         , ''         ]
\, 'LineNr':        [ 8          , ''         , ''         ]
\, 'VertSplit':     [ 'asphalt'  , ''         , ''         ]
\, 'Folded':        [ 6          , 8          , 'italic'   ]
\, 'FoldColumn':    [ 6          , 8          , 'italic'   ]
\
\, 'TODO':          [ 6          , ''         , 'bold'     ]
\, 'Comment':       [ 6          , ''         , 'italic'   ]
\
\, 'Constant':      [ 4          , ''         , 'bold'     ]
\, 'String':        [ 2          , ''         , ''         ]
\, 'Number':        [ 9          , 0          , 'bold'     ]
\, 'Boolean':       [ 10         , ''         , 'bold'     ]
\
\, 'Identifier':    [ 15         , ''         , ''         ]
\, 'Function':      [ 3          , ''         , ''         ]
\
\, 'Statement':     [ 13         , ''         , 'bold'     ]
\, 'Repeat':        [ 13         , ''         , ''         ]
\, 'Conditional':   [ 13         , ''         , 'bold'     ]
\, 'Label':         [ 13         , ''         , ''         ]
\, 'Operator':      [ 5          , ''         , ''         ]
\, 'Keyword':       [ 5          , ''         , ''         ]
\
\, 'PreProc':       [ 2          , ''         , ''         ]
\, 'Include':       [ 13         , ''         , ''         ]
\, 'Define':        [ 5          , ''         , ''         ]
\, 'Macro':         [ 6          , ''         , ''         ]
\, 'PreCondit':     [ 6,'','' ]
\
\, 'Type':          [ 4          , ''         ,''          ]
\, 'StorageClass':  [ 1          , ''         ,''          ]
\
\, 'Special':       [ 7          , ''         , ''         ]
\, 'Delimiter':     ['','','']
\
\, 'Error':         ['','','']
\
\, 'DiffChange':    [ 12, 8, '']
\, 'DiffText':      [ 12, 8, '']
\, 'DiffAdd':       [ 10, 8, '']
\, 'DiffDelete':    [ 9,  8, '']
\
\, 'Pmenu':         [ 15         , 8          , ''         ]
\, 'PmenuSel':      [ 0          , 14         , 'bold'     ]
\ }

call s:ParseColorscheme(s:cs)

" Common
hi link Float Number
hi link TabLine StatusLineNC
hi link TabSel StatusLine
hi link TabLineFill Normal

" Ruby
hi link rubyConstant Constant
hi link rubyClass Statement
hi link rubyBlockParameter StorageClass
hi link rubyInterpolationDelimiter Function

" PHP
hi link phpMemberSelector Special
hi link phpVarSelector Special
hi link phpOperator Operator
hi link phpSpecialFunction Function

" HTML
hi link htmlTag Special
hi link htmlArg Operator

" CSS
hi link cssClassName Repeat
hi link cssTagName Statement
hi link cssIdentifier StorageClass
hi link cssTextProp NONE
hi link cssFontProp NONE
hi link cssBackgroundProp NONE
hi link cssBorderOutlineProp NONE
hi link cssVendor NONE
hi link cssPaddingProp NONE
hi link cssMarginProp NONE
hi link cssBoxProp NONE
hi link cssListProp NONE
hi link cssPositioningProp NONE
hi link cssDimensionProp NONE
hi link cssColorProp NONE
hi link cssTransformProp NONE
hi link cssFunctionName Function
hi link cssBraces Special
hi link cssColor Constant

" JS
hi link jsReturn Statement
hi link jsLabel StorageClass

" EasyMotion
hi link EasyMotionShade Comment
hi link EasyMotionTarget StorageClass

" CtrlP
hi link CtrlPMatch Search
hi link CtrlPMode1 Comment
hi link CtrlPMode2 Comment
