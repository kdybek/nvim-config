local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true, silent = false }

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
nkeymap('<leader>cd', ':CMakeRunDebug<cr>')
nkeymap('<leader>cc', ':CMakeClean<cr>')

-- UndoTree
nkeymap('<leader>ut', ':UndotreeToggle<cr> :UndotreeFocus<cr>')

-- Running scripts
nkeymap('<leader>ro', ':!octave --silent --no-gui %<cr>')

-- Formatting
nkeymap('<leader>fo', ':lua require("conform").format({lsp_format = "fallback",})<cr>')

-- Misc
function SwitchSourceHeader()
    local extension = vim.fn.expand('%:e')

    if extension == 'h' then
        if vim.fn.filereadable(vim.fn.expand('%:r') .. '.cpp') == 1 then
            vim.api.nvim_command('edit %:r.cpp')
        elseif vim.fn.filereadable(vim.fn.expand('%:r') .. '.c') == 1 then
            vim.api.nvim_command('edit %:r.c')
        else
            print('No corresponding .cpp or .c file found')
        end
    elseif extension == 'cpp' or extension == 'c' then
        if vim.fn.filereadable(vim.fn.expand('%:r') .. '.h') == 1 then
            vim.api.nvim_command('edit %:r.h')
        else
            print('No corresponding .h file found')
        end
    else
        print('Not a .cpp, .c or .h file')
    end
end

nkeymap('<leader>sh', ':lua SwitchSourceHeader()<cr>')
