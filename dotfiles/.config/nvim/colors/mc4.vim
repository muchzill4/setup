hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'mc4'

function! s:hl(group, ctermfg, ctermbg, cterm)
  if a:ctermfg != ''
    exec printf('hi %s ctermfg=%s', a:group, a:ctermfg)
  else
    exec printf('hi %s ctermfg=none', a:group)
  endif
  if a:ctermbg != ''
    exec printf('hi %s ctermbg=%s', a:group, a:ctermbg)
  else
    exec printf('hi %s ctermbg=none', a:group)
  endif
  if a:cterm != ''
    exec printf('hi %s cterm=%s', a:group, a:cterm)
  else
    exec printf('hi %s cterm=none', a:group)
  endif
endfunction

call s:hl('VertSplit', '0', '', '')
call s:hl('TabLine', '', '0', '')
call s:hl('TabLineSel', '0', '7', 'bold')
call s:hl('TabLineFill', '', '0', '')
call s:hl('StatusLine', '0', '7', 'bold')
call s:hl('StatusLineNC', '', '0', '')
call s:hl('Pmenu', '', '0', '')
call s:hl('PmenuSel', '0', '7', 'bold')
call s:hl('LineNr', '0', '', '')
call s:hl('CursorLineNr', '2', '', '')
call s:hl('CursorLine', '', '0', '')
call s:hl('CursorColumn', '', '0', '')

call s:hl('Normal', '', '', '')
call s:hl('Visual', '', '0', '')
call s:hl('ModeMsg', '5', '', 'bold')
call s:hl('Folded', '0', '', '')
call s:hl('IncSearch', '3', '', 'reverse')
call s:hl('Search', '6', '', 'reverse')
call s:hl('MatchParen', '4', '', 'reverse,bold')

call s:hl('Comment', '4', '', 'italic')
call s:hl('Constant', '2', '', '')
call s:hl('String', '6', '', '')

call s:hl('Identifier', '7', '', '')
call s:hl('Function', '3', '', '')

call s:hl('Statement', '7', '', '')

call s:hl('PreProc', '7', '', '')

call s:hl('Type', '5', '', '')
call s:hl('Special', '7', '', '')
call s:hl('Underlined', '7', '', 'underline')
call s:hl('Error', '1', '', '')
call s:hl('Todo', '4', '', 'bold,underline')

call s:hl('ErrorMsg', '0', '1', '')
call s:hl('SpellBad', '1', '', 'underline,italic')
call s:hl('Title', '7', '', 'bold')
call s:hl('Directory', '4', '', '')
call s:hl('SignColumn', '1', '', '')
call s:hl('EndOfBuffer', '0', '', '')

call s:hl('DiffAdd', '2', '', '')
call s:hl('DiffDelete', '1', '', '')
call s:hl('DiffChange', '3', '', '')
call s:hl('DiffText', '3', '', 'underline')

call s:hl('LspDiagnosticsDefaultError', '1', '', '')
call s:hl('LspDiagnosticsDefaultWarning', '3', '', '')
call s:hl('LspDiagnosticsDefaultInformation', '7', '', '')
call s:hl('LspDiagnosticsDefaultHint', '4', '', '')
call s:hl('LspDiagnosticsUnderlineError', '1', '', 'underline')
call s:hl('LspDiagnosticsUnderlineWarning', '3', '', 'underline')
call s:hl('LspDiagnosticsUnderlineInformation', '7', '', 'underline')
call s:hl('LspDiagnosticsUnderlineHint', '4', '', 'underline')
call s:hl('LspReferenceText', '', '', 'bold,underline')
call s:hl('LspReferenceRead', '', '', 'bold,underline')
call s:hl('LspReferenceWrite', '', '', 'bold,underline')

" Legacy groups for official git.vim and diff.vim syntax
hi! link diffAdded DiffAdd
hi! link diffChanged DiffChange
hi! link diffRemoved DiffDelete
