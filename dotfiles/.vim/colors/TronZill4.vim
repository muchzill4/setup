" File: TronZill4.vim
" Description: Wtf am I doing?
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

let g:colors_name = "TronZill4"

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

let s:pal.0 = ['192028', 0]
let s:pal.1 = ['d40051', 1]
let s:pal.2 = ['74c954', 2]
let s:pal.3 = ['ffb20d', 3]
let s:pal.4 = ['3a81c8', 4]
let s:pal.5 = ['ff17cd', 5]
let s:pal.6 = ['748aa6', 6]
let s:pal.7 = ['adc2d8', 7]
let s:pal.8 = ['212b39', 8]
let s:pal.9 = ['ea511d', 9]
let s:pal.10 = ['b5e42a', 10]
let s:pal.11 = ['fdc438', 11]
let s:pal.12 = ['183c66', 12]
let s:pal.13 = ['fb8cc2', 13]
let s:pal.14 = ['3b4f68', 14]
let s:pal.15 = ['dfdedb', 15]

let s:pal['smoke']     = ['303030', 236] " invisibles
let s:pal['dust']      = ['626262', 241]
let s:pal['darkgreen'] = ['005f00', 22]
let s:pal['darkred']   = ['5f0000', 52]
let s:pal['darkblue']  = ['875f00', 17]

" }}}
" TODO: 
" TITLE, tabline, folds
" Colorscheme:

" .-----------------.------------.------------.------------.
" | Highlight group | Foreground | Background | Attributes |
" |-----------------|------------|------------|------------|
let s:cs = {
\  'Normal':        [ 7          , 0          , ''         ]
\, 'Visual':        [ 7          , 12         , ''         ]
\
\, 'Search':        [ 0          , 11         , ''         ]
\, 'IncSearch':     [ 0          , 11         , ''         ]
\, 'Title':         [ 3          , ''         , ''         ]
\, 'NonText':       [ 'smoke'    , ''         , ''         ]
\, 'SpecialKey':    [ 'smoke'    , ''         , ''         ]
\, 'MatchParen':    [ 5          , ''         , ''         ]
\
\, 'StatusLine':    [ 0          , 15          , ''     ]
\, 'StatusLineNC':  [ 7          , 8    , ''         ]
\, 'TabLine':       [ 'dust'     , 'smoke'    , ''         ]
\, 'TabLineSel':    [ 0          , 6          , ''     ]
\, 'TabLineFill':   [ 15         , 'smoke'    , ''         ]
\, 'Directory':     [ 6          , ''         , ''     ]
\
\, 'Cursor':        [ 0          , 1          , ''         ]
\, 'CursorLine':    [ ''         , ''         , ''         ]
\, 'CursorColumn':  [ ''         , ''         , ''         ]
\, 'CursorLineNr':  [ 10         , ''         , ''     ]
\, 'LineNr':        [ 14         , 8          , ''         ]
\, 'VertSplit':     [ 'smoke'    , ''         , ''         ]
\, 'Folded':        [ 7          , 12         , 'italic'   ]
\, 'FoldColumn':    [ 6          , 8          , 'italic'   ]
\
\, 'TODO':          [ 6          , 14         , ''         ]
\, 'Comment':       [ 14         , ''         , ''         ]
\
\, 'Constant':      [ 4          , ''         , ''         ]
\, 'String':        [ 9          , ''         , ''         ]
\, 'Number':        [ 2          , ''         , ''     ]
\, 'Boolean':       [ 1          , ''         , ''     ]
\
\, 'Identifier':    [ 7          , ''         , ''         ]
\, 'Variable':      [ 15         , ''         , ''         ]
\, 'Function':      [ 3          , ''         , ''         ]
\
\, 'Statement':     [ 6         , ''         , ''          ]
\, 'Repeat':        [ 6         , ''         , ''          ]
\, 'Conditional':   [ 6         , ''         , ''          ]
\, 'Label':         [ 6         , ''         , ''          ]
\, 'Operator':      [ 6         , ''         , ''          ]
\, 'Keyword':       [ 4         , ''         , ''          ]
\
\, 'PreProc':       [ 6          , ''         , ''         ]
\, 'Include':       [ 10         , ''         , ''         ]
\
\, 'Type':          [ 6          , ''         , ''         ]
\, 'Structure':     [ 4          , ''         , ''         ]
\
\, 'Special':       [ ''         , ''         , ''         ]
\
\, 'Error':         ['','','']
\
\, 'DiffChange':    [ 15         , 'darkyellow' , 'italic' ]
\, 'DiffText':      [ 11         , 'darkyellow' , 'italic' ]
\, 'DiffAdd':       [ 2          , 'darkgreen'  , 'italic' ]
\, 'DiffDelete':    [ 1          , 'darkred'    , 'italic' ]
\
\, 'Pmenu':         [ 'dust'     , 'smoke'   , ''         ]
\, 'PmenuSel':      [ 0          , 6         , ''     ]
\
\, 'RubySymbol':    [ 2          , ''        , ''         ]
\ }

call s:ParseColorscheme(s:cs)

" added Something here

" Common
hi link Float Number
hi link TabLine StatusLineNC
hi link TabSel StatusLine
hi link TabLineFill Normal

" Ruby
hi link rubyInstanceVariable Variable
hi link rubyControl Conditional
hi link rubyPseudoVariable Boolean
hi link rubyConstant Constant
hi link rubyInterpolationDelimiter Conditional
hi link rubyBlockParameter RubySymbol

" PHP
hi link phpStructure Type
hi link phpComparison Operator
hi link phpSpecialFunction Function
hi link phpMemberSelector Operator
hi link phpVarSelector Operator

" HTML
hi link htmlTagName Structure
hi link htmlSpecialTagName Structure
hi link htmlTag Special
hi link htmlArg Operator

" SASS / CSS
hi link cssClassName Variable
hi link sassClass Variable
hi link cssIdentifier Statement
hi link cssBraces NONE
hi link sassId Constant
hi link cssTagName Structure
hi link cssIdentifier Structure

" JS
hi link javascriptRequire Include
hi link coffeeRequire Include
hi link javascriptString String
hi link jsReturn Statement
hi link jsFunctionKey Function
hi link jsGlobalObjects Structure
hi link jsUndefined Boolean
hi link jsNull Boolean
hi link jsObjectKey Variable
hi link javascriptAngular Number
hi link coffeeAngular Number
hi link javascriptAServices Number
hi link coffeeAServices Number

" EasyMotion
hi link EasyMotionShade Comment
hi link EasyMotionTarget MatchParen

" CtrlP
hi link CtrlPMatch Search
hi link CtrlPMode1 Comment
hi link CtrlPMode2 Comment

" Twig
hi link twigString String
hi link twigBlockName Constant

" Cucumber
hi link cucumberFeature Include
hi link cucumberScenario Structure
hi link cucumberWhen Conditional

" YAML
hi link YamlBlockMappingKey Structure

