" File: mylight.vim
" Author: muchzill4 <muchzill4@gmail.com>
"
" Thanks:
" - Bram Moolenaar for this wonderful editor
" - Steve Losh (stevelosh.com) for badwolf and learnvimscriptthehardway!
" - Ethan Schoonover (ethanschoonover.com) for Solarized

" | >> INIT
" |
if !has("gui_running") && &t_Co < 16
  finish
endif

set background=light

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "mylight"

function! s:hl(group, ...)
  let fg = 'NONE'
  let bg = 'NONE'
  let attr = 'NONE'

  if a:0 >= 1 && strlen(a:1)
    let fg = a:1
  endif

  if a:0 >= 2 && strlen(a:2)
    let bg = a:2
  endif

  if a:0 == 3 && strlen(a:3)
    let attr = a:3
  endif

  exec printf("hi %s ctermfg=%s ctermbg=%s cterm=%s", a:group, fg, bg, attr)
endfunction


" | >> Colorscheme
" |

" UI
call s:hl('Normal', '', '')
call s:hl('Visual', 0, 7)

call s:hl('Search', 0, 226)
call s:hl('IncSearch', 0, 226, 'underline')

call s:hl('MatchParen', '', 7)

call s:hl('NonText', 4)
call s:hl('SpecialKey', 4)
call s:hl('Special', '')

call s:hl('Cursor', 7, 0)
call s:hl('LineNr', 0, 254)
call s:hl('CursorLineNr', 2, 240)
call s:hl('CursorLine', '', 0)
call s:hl('CursorColumn', '', 0)
call s:hl('ColorColumn', '', 0)

call s:hl('Pmenu', 0, 7)
call s:hl('PmenuSel', '', 4)

call s:hl('StatusLine', 7, 237)
call s:hl('StatusLineNC', 0, 7)
call s:hl('VertSplit', 7, 7)

call s:hl('Directory', 4)
call s:hl('Title', 1)

call s:hl('Folded', 4, 0)

" Syntax
call s:hl('Comment', 2)
call s:hl('Todo', 4, '', 'underline')

call s:hl('Number', 4)
call s:hl('String', 1)
call s:hl('Boolean', 2)

call s:hl('Type', 2)
call s:hl('StorageClass', 0)
call s:hl('Structure', 0)

call s:hl('Identifier', '')
call s:hl('Function', '')

call s:hl('Exception', 7)
call s:hl('Include', 5)

call s:hl('PreProc', 5)
call s:hl('Statement', 5)
call s:hl('Repeat', 5)
call s:hl('Conditional', 5)
call s:hl('Label', 5)
call s:hl('Operator', '')
call s:hl('Keyword', 5)

call s:hl('Underlined', 7, '', 'underline')

call s:hl('DiffDelete', 1, '')
call s:hl('DiffChange', 3, '')
call s:hl('DiffAdd', 2, '')
call s:hl('DiffText', 7, '')


" | >> Link
" |

" UI
hi link TabLine StatusLineNC
hi link TabLineFill StatusLineNC
hi link TabLineSel StatusLine

" Netrw & NERDTree
hi link netrwDir Directory
hi link netrwClassify netrwDir
hi link NERDTreeDirSlash netrwDir
hi link NERDTreeOpenable netrwDir
hi link NERDTreeClosable NERDTreeOpenable

" EasyMotion
hi link EasyMotionShade Comment
hi link EasyMotionTarget Identifier
hi link EasyMotionTarget2First Identifier
hi link EasyMotionTarget2Second Identifier

" CtrlP
hi link CtrlPMatch Search
hi link CtrlPMode1 Comment

" PHP
hi link phpMemberSelector Normal
hi link phpVarSelector Identifier

" HTML / XML
hi link htmlTagName Function
hi link htmlSpecialTagName htmlTagName
hi link htmlTag Boolean
hi link htmlEndTag htmlTag
hi link htmlArg Number
hi link xmlEndTag xmlTag

" CSS
hi link cssBraces NONE
hi link cssTagName Include
hi link cssIdentifier Function
hi link cssClassName Function

" LESS
hi link lessDefinition cssProp

" JS
hi link jsFunction Define
hi link jsGlobalObjects Include
hi link javascriptSFunction Function
hi link jsFuncCall Function
hi link jsFuncArgs Identifier
hi link javascriptRequire Include
hi link javascriptString String

" Ruby
hi link rubyRegexp String
hi link rubyRegexpSpecial String
hi link rubyRegexpDelimiter String