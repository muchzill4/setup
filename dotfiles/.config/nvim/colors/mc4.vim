hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "mc4"

function! s:hl(group, ctermfg, ctermbg, cterm)
  if a:ctermfg != ""
    exec printf("hi %s ctermfg=%s", a:group, a:ctermfg)
  else
    exec printf("hi %s ctermfg=none", a:group)
  endif
  if a:ctermbg != ""
    exec printf("hi %s ctermbg=%s", a:group, a:ctermbg)
  else
    exec printf("hi %s ctermbg=none", a:group)
  endif
  if a:cterm != ""
    exec printf("hi %s cterm=%s", a:group, a:cterm)
  else
    exec printf("hi %s cterm=none", a:group)
  endif
endfunction

call s:hl('VertSplit', '0', '', '')
call s:hl('TabLine', '7', '0', '')
call s:hl('TabLineSel', '7', '', 'reverse,bold')
call s:hl('TabLineFill', '', '0', '')
call s:hl('StatusLine', '7', '', 'reverse,bold')
call s:hl('StatusLineNC', '7', '0', '')
call s:hl('Pmenu', '7', '0', '')
call s:hl('PmenuSel', '0', '7', 'bold')
call s:hl('LineNr', '8', '', '')
call s:hl('CursorLineNr', '7', '', '')
call s:hl('CursorLine', '', '0', '')
call s:hl('CursorColumn', '', '0', '')

call s:hl('Normal', '', '', '')
call s:hl('Visual', '0', '15', '')
call s:hl('ModeMsg', '0', '5', 'bold')
call s:hl('Folded', '8', '', '')
call s:hl('IncSearch', '0', '3', 'bold,underline')
call s:hl('Search', '0', '6', '')
call s:hl('MatchParen', '0', '8', 'bold')

call s:hl('Comment', '4', '', 'italic')
call s:hl('Constant', '2', '', '')
call s:hl('String', '6', '', '')

call s:hl('Identifier', '15', '', '')
call s:hl('Function', '3', '', '')

call s:hl('Statement', '15', '', '')

call s:hl('PreProc', '15', '', '')

call s:hl('Type', '5', '', '')
call s:hl('Special', '7', '', '')
call s:hl('Underlined', '7', '', 'underline')
call s:hl('Error', '0', '1', '')
call s:hl('Todo', '4', '', 'bold,underline')

call s:hl('ErrorMsg', '0', '1', '')
call s:hl('SpellBad', '0', '1', '')
call s:hl('Title', '7', '', 'bold')
call s:hl('Directory', '4', '', '')
call s:hl('SignColumn', '1', '', '')

call s:hl('DiffAdd', '0', '2', '')
call s:hl('DiffDelete', '0', '1', '')
call s:hl('DiffChange', '0', '6', '')
call s:hl('DiffText', '0', '6', 'bold')

" Legacy groups for official git.vim and diff.vim syntax
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete
