local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true }

local function nkeymap(key, map)
    keymap('n', key, map, opts)
end

-- LSP
nkeymap('gd', ':lua vim.lsp.buf.definition()<cr>')
nkeymap('gD', ':lua vim.lsp.buf.declaration()<cr>')
nkeymap('gi', ':lua vim.lsp.buf.implementation()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.document_symbol()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.workspace_symbol()<cr>')
nkeymap('gr', ':lua vim.lsp.buf.references()<cr>')
nkeymap('gt', ':lua vim.lsp.buf.type_definition()<cr>')
nkeymap('K', ':lua vim.lsp.buf.hover()<cr>')
nkeymap('<c-k>', ':lua vim.lsp.buf.signature_help()<cr>')
nkeymap('<leader>af', ':lua vim.lsp.buf.code_action()<cr>')
nkeymap('<leader>rn', ':lua vim.lsp.buf.rename()<cr>')

-- Floaterm
nkeymap('<leader>tt', ':FloatermToggle<cr>')

-- NvimTree
nkeymap('<leader>nt', ':NvimTreeToggle<cr>')

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- CMake
nkeymap('<leader>cg', ':CMakeGenerate<cr>')
nkeymap('<leader>cb', ':CMakeBuild<cr>')
nkeymap('<leader>cr', ':CMakeRun<cr>')
nkeymap('<leader>cd', ':CMakeDebug<cr>')
nkeymap('<leader>cc', ':CMakeClean<cr>')
nkeymap('<leader>sex', ':SetExecutable ')
nkeymap('<leader>sbd', ':SetBuildDir ')
nkeymap('<leader>sbc', ':SetBuildConfig ')
nkeymap('<leader>sec', ':SetExportCompileCommands ')

-- Formatting
nkeymap('<leader>fo', ':lua require("conform").format({lsp_format = "fallback",})<cr>')
