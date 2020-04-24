hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "mc4"

function! s:hl(group, ctermfg, ctermbg, cterm)
  if a:ctermfg != ""
    exec printf("hi %s ctermfg=%s", a:group, a:ctermfg)
  endif
  if a:ctermbg != ""
    exec printf("hi %s ctermbg=%s", a:group, a:ctermbg)
  endif
  if a:cterm != ""
    exec printf("hi %s cterm=%s", a:group, a:cterm)
  endif
endfunction

call s:hl('VertSplit', '8', '0', 'NONE')
call s:hl('TabLine', '7', '8', 'NONE')
call s:hl('TabLineSel', '0', '7', 'NONE')
call s:hl('TabLineFill', '', '8', 'NONE')
call s:hl('StatusLine', '0', '7', 'NONE')
call s:hl('StatusLineNC', '7', '8', 'NONE')
call s:hl('Pmenu', '7', '8', 'NONE')
call s:hl('PmenuSel', '0', '7', 'NONE')
call s:hl('LineNr', '8', '', '')
call s:hl('CursorLineNr', '7', '', '')
call s:hl('CursorLine', '', '', 'NONE')
call s:hl('CursorColumn', '', 'NONE', 'NONE')

call s:hl('Normal', '', '', '')
call s:hl('Visual', '15', '0', 'reverse')
call s:hl('ModeMsg', '3', '0', 'bold')
call s:hl('Folded', '8', '0', 'underline')
call s:hl('IncSearch', '0', '3', 'bold')
call s:hl('Search', '0', '6', '')
call s:hl('MatchParen', '0', '6', '')

call s:hl('Comment', '4', '', 'NONE')
call s:hl('Constant', '5', '', '')
call s:hl('String', '6', '', '')
call s:hl('Character', '2', '', 'bold')
call s:hl('Identifier', '1', '', 'NONE')
call s:hl('Function', '3', '', '')
call s:hl('Statement', '15', '', '')
call s:hl('PreProc', '2', '', '')
call s:hl('Include', '2', '', '')
call s:hl('Define', '15', '', '')
call s:hl('Type', '3', '', '')
call s:hl('Special', '5', '', '')
call s:hl('Underlined', '7', '', '')
call s:hl('Error', '0', '1', 'NONE')
call s:hl('Todo', '4', 'NONE', 'bold,underline')

call s:hl('ErrorMsg', '0', '1', 'NONE')
call s:hl('SpellBad', '0', '1', 'NONE')
call s:hl('Title', '7', '', 'bold')
call s:hl('Directory', '4', '', '')
call s:hl('SignColumn', '1', '8', 'NONE')

call s:hl('DiffAdd', '0', '2', 'NONE')
call s:hl('DiffDelete', '0', '1', 'NONE')
call s:hl('DiffChange', '0', '6', 'NONE')
call s:hl('DiffText', '0', '6', 'bold')
