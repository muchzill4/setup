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

hi clear
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
call s:hl('Visual', '', 0)

call s:hl('Search', 3, '', 'inverse,underline')
call s:hl('IncSearch', 3, '', 'inverse')

call s:hl('MatchParen', 1, 0)

call s:hl('NonText', 0)
call s:hl('SpecialKey', 0)

call s:hl('Cursor', 2, '', 'inverse')
call s:hl('LineNr', 4)

call s:hl('CursorLineNr', 4)
call s:hl('CursorLine', '', '')
call s:hl('CursorColumn', '', '')
call s:hl('ColorColumn', '', 0)

call s:hl('Pmenu', '', 0)
call s:hl('PmenuSel', 3, '', 'inverse')
call s:hl('WildMenu', 3, '', 'inverse')

call s:hl('StatusLine', '', 0, 'inverse')
call s:hl('StatusLineNC', '', 0)
call s:hl('VertSplit', 0, '', 'inverse')

call s:hl('Directory', 4)
call s:hl('Title', 1)

call s:hl('Folded', 4, '', 'inverse,underline')

call s:hl('ModeMsg', 2, '', 'inverse')

" Syntax
call s:hl('Comment', 4)
call s:hl('Todo', 4, '', 'underline')

call s:hl('Constant', 2)
call s:hl('String', 6)

call s:hl('Identifier', 1)
call s:hl('Function', 3)

call s:hl('Statement', 7)
call s:hl('PreProc', 7)

call s:hl('Type', 5)

call s:hl('Special', 7)

call s:hl('Error', '', 1)
call s:hl('ErrorMsg', '', 1)

call s:hl('DiffDelete', 1, '', 'inverse')
call s:hl('DiffChange', 3, '', 'inverse')
call s:hl('DiffAdd', 2, '', 'inverse')
call s:hl('DiffText', 6, '', 'inverse')

" | >> Link
" |

" HTML / XML
hi link htmlEndTag htmlTag
hi link xmlEndTag xmlTag

" CoffeeScript
hi link coffeeSpaceError NONE
hi link coffeeSemicolonError NONE
hi link coffeeReservedError NONE

" CtrlP
hi link CtrlPMatch IncSearch
