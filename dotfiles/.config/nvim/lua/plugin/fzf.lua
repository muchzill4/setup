local map = require('mc4.shortcuts').map

map('n', '<leader>f', ':Files<CR>')
map('n', '<leader>b', ':Buffers<CR>')
map('n', '<leader>t', ':Tags<CR>')
map('n', '<leader>c', ':Commits<CR>')
map('n', '<leader>s', ':Rg <C-r><C-w><CR>')
map('v', '<leader>s', [[:<C-u>call VisualStarSearchSet('/', 'raw')<CR>:Rg <C-r><C-/><cr>]])
