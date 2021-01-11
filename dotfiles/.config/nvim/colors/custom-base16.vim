hi clear
if exists("syntax_on")
  syntax reset
endif

runtime colors/base16-default-dark.vim

let g:colors_name = "custom-base16"

" Add lsp highlights
hi LspDiagnosticsDefaultError ctermfg=1
hi LspDiagnosticsDefaultWarning ctermfg=3
hi LspDiagnosticsDefaultInformation ctermfg=7
hi LspDiagnosticsDefaultHint ctermfg=4
hi LspDiagnosticsUnderlineError ctermfg=1 cterm=underline
hi LspDiagnosticsUnderlineWarning ctermfg=3 cterm=underline
hi LspDiagnosticsUnderlineInformation ctermfg=7 cterm=underline
hi LspDiagnosticsUnderlineHint ctermfg=4 cterm=underline
