" File: abitoftron.vim
" Author: muchzill4 <muchzill4@gmail.com>
"
" Thanks:
" - Bram Moolenaar for this wonderful editor
" - Steve Losh (stevelosh.com) for badwolf and learnvimscriptthehardway!
" - Ethan Schoonover (ethanschoonover.com) for Solarized

" | >> INIT
" |
if !has("gui_running") && &t_Co != 256
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
call s:hl('Visual', 0, 4)

call s:hl('Search', 0, 3)
call s:hl('IncSearch', 0, 5)

call s:hl('MatchParen', 0, 4)

call s:hl('NonText', 4)
call s:hl('SpecialKey', 4)

call s:hl('Cursor', 7, 0)
call s:hl('LineNr', 4, 0)
call s:hl('CursorLineNr', 2, '')
call s:hl('CursorLine', '', 0)
call s:hl('CursorColumn', '', 0)

call s:hl('Pmenu', 4, 0)
call s:hl('PmenuSel', 0, 7)

call s:hl('StatusLine', 0, 7)
call s:hl('StatusLineNC', 7, 0, 'underline')
call s:hl('VertSplit', 0, 0)

call s:hl('Directory', 4)
call s:hl('Title', 1)

call s:hl('Folded', 4, 0)

" Syntax
call s:hl('Comment', 4)
call s:hl('Todo', 4, '', 'underline')

call s:hl('Number', 2)
call s:hl('String', 6)
call s:hl('Boolean', 2)

call s:hl('Type', 2)
call s:hl('StorageClass', 7)
call s:hl('Structure', 7)

call s:hl('Identifier', 1)
call s:hl('Function', 3)

call s:hl('Exception', 7)
call s:hl('Include', 5)

call s:hl('PreProc', 7)
call s:hl('Statement', 7)
call s:hl('Repeat', 7)
call s:hl('Conditional', 7)
call s:hl('Label', 7)
call s:hl('Operator', 7)
call s:hl('Keyword', 7)

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

" Netrw
hi link netrwClassify netrwDir

" EasyMotion
hi link EasyMotionShade Comment
hi link EasyMotionTarget Include
hi link EasyMotionTarget2First Include
hi link EasyMotionTarget2Second Include

" CtrlP
hi link CtrlPMatch Search
hi link CtrlPMode1 Comment

" PHP
hi link phpMemberSelector Normal
hi link phpVarSelector Identifier

" HTML
hi link htmlTagName Identifier
hi link htmlSpecialTagName htmlTagName
hi link htmlTag Boolean
hi link htmlEndTag htmlTag
hi link htmlArg Function

" CSS
hi link cssBraces NONE
hi link cssTagName Include
hi link cssIdentifier Function
hi link cssClassName Function

" JS
hi link jsFunction Define
hi link jsGlobalObjects Include
hi link javascriptSFunction Function
hi link jsFuncCall Function
hi link jsFuncArgs Identifier
hi link javascriptRequire Include
