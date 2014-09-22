" File: abitoftron.vim
" Author: muchzill4 <muchzill4@gmail.com>
"
" Thanks:
" - Bram Moolenaar for this wonderful editor
" - Steve Losh (stevelosh.com) for badwolf and learnvimscriptthehardway!
" - Ethan Schoonover (ethanschoonover.com) for Solarized

" | >> INIT
" |
if !has("gui_running") && &t_Co < 256
  finish
endif

set background=dark

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "abitoftron"

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
call s:hl('Visual', 232, 4)

call s:hl('Search', '', '', 'underline')
call s:hl('IncSearch', 0, 3)

call s:hl('MatchParen', 5)

call s:hl('NonText', 4)
call s:hl('SpecialKey', 4)

call s:hl('Cursor', 0, 2)
call s:hl('LineNr', 4)
call s:hl('CursorLineNr', 3)
call s:hl('CursorLine', '', '')
call s:hl('CursorColumn', '', '')
call s:hl('ColorColumn', '', 0)

call s:hl('Pmenu', 232, 7)
call s:hl('PmenuSel', '', 5)

call s:hl('StatusLine', 232, 7)
call s:hl('StatusLineNC', 7, 0)
call s:hl('VertSplit', 4, 0)

call s:hl('Directory', 4)
call s:hl('Title', 1)

call s:hl('Folded', 4, 0)

" Syntax
call s:hl('Comment', 4)
call s:hl('Todo', 232, 4)

call s:hl('Constant', 5)
call s:hl('Number', 2)
call s:hl('String', 6)

call s:hl('Identifier', 1)
call s:hl('Function', 3)

call s:hl('Statement', 7)

call s:hl('PreProc', 7, '')

call s:hl('Type', 2)
call s:hl('StorageClass', 7)
call s:hl('Structure', 7)

call s:hl('Delimiter', 7)

call s:hl('DiffDelete', 232, 1)
call s:hl('DiffChange', 232, 3)
call s:hl('DiffAdd', 232, 2)
call s:hl('DiffText', 232, 7)


" | >> Link
" |

" UI
hi link TabLine StatusLineNC
hi link TabLineFill StatusLineNC
hi link TabLineSel StatusLine

" EasyMotion
hi link EasyMotionShade Comment
hi link EasyMotionTarget Identifier
hi link EasyMotionTarget2First Identifier
hi link EasyMotionTarget2Second Identifier

" CtrlP
hi link CtrlPMatch IncSearch

" PHP
hi link phpIdentifier Normal
hi link phpSpecialFunction Function
hi link phpInterfaces Type
hi link phpFunctions Normal
hi link phpMethods Normal
hi link phpDocTags phpComment

" HTML / XML
hi link htmlEndTag htmlTag
hi link xmlEndTag xmlTag

" JS
hi link jsFunction PreProc
hi link jsGlobalObjects Type
hi link javascriptSFunction Normal
hi link javascriptpFunction Normal
hi link jsExceptions Type
hi link javascriptRequire Include
hi link jsFunctionKey Function
hi link javascriptString String
