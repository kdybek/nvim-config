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
local project_config = require('project-config')

local cmake_generate_cmd = 'cmake -G "Ninja Multi-Config" -S . -B "' ..
    project_config.build_dir ..
    '" -DCMAKE_EXPORT_COMPILE_COMMANDS=' .. (project_config.export_compile_commands and 'ON' or 'OFF')

if project_config.export_compile_commands then
    cmake_generate_cmd = cmake_generate_cmd ..
        ' && del compile_commands.json 2>nul && mklink compile_commands.json "' ..
        project_config.build_dir .. '/compile_commands.json"'
end

local cmake_build_cmd = 'cmake --build "' ..
    project_config.build_dir .. '" --config "' .. project_config.build_config .. '"'

local cmake_clean_cmd = 'rmdir /s /q "' .. project_config.build_dir .. '"'

local target_path = '".\\' ..
    project_config.build_dir .. '\\' .. project_config.build_config .. '\\' .. project_config.executable .. '"'

local debugger_cmd = 'lldb -o "r" -o "q" -- ' .. target_path

nkeymap('<leader>cg', ':! ' .. cmake_generate_cmd .. '<cr>')
nkeymap('<leader>cb', ':! ' .. cmake_generate_cmd .. ' && ' .. cmake_build_cmd .. '<cr>')
nkeymap('<leader>cr', ':! ' .. cmake_generate_cmd .. ' && ' .. cmake_build_cmd .. ' && ' .. target_path .. '<cr>')
nkeymap('<leader>cd', ':! ' .. cmake_generate_cmd .. ' && ' .. cmake_build_cmd .. ' && ' .. debugger_cmd .. '<cr>')
nkeymap('<leader>cc', ':! ' .. cmake_clean_cmd .. '<cr>')

-- Formatting
nkeymap('<leader>fo', ':lua require("conform").format({lsp_format = "fallback",})<cr>')
