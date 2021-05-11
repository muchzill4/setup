local map = require('mc4.shortcuts').map

map('n', '<Leader>ff', '<Cmd>Telescope find_files<CR>')
map('n', '<Leader>fb', '<Cmd>Telescope buffers<CR>')
map('n', '<Leader>ft', '<Cmd>Telescope tags<CR>')
map('n', '<Leader>fs', '<Cmd>Telescope live_grep<CR>')
map('n', '<Leader>fB', '<Cmd>Telescope builtin<CR>')
map('n', '<Leader>fd', '<Cmd>lua require("mc4.telescope").edit_dotfiles()<CR>')
