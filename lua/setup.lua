local function filetype_setup()
    vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.hlsl', '*.hlsli' },
        command = 'set filetype=hlsl',
    })
end

local function treesitter_setup()
    require('nvim-treesitter.configs').setup({
        ensure_installed = { 'c', 'cpp', 'python', 'lua', 'hlsl', 'glsl', 'cmake' },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        fold = {
            enable = false,
        },
        modules = {},
    })
end

local function cmp_setup()
    local cmp = require('cmp')
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
        }, {
            { name = 'buffer' },
        })
    })

    -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
    })
end

local function mason_setup()
    require('mason').setup()
    require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'clangd', 'cmake', 'pylsp' },
        automatic_installation = true,
    })
end

local function lsp_setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require 'lspconfig'
    local configs = require 'lspconfig.configs'

    lspconfig.lua_ls.setup({
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim', 'use' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file('', true),
                    checkThirdParty = false, -- Avoid prompting about third-party libraries
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        capabilities = capabilities,
    })
    lspconfig.clangd.setup({
        capabilities = capabilities,
    })
    lspconfig.cmake.setup({
        capabilities = capabilities,
    })
    lspconfig.yamlls.setup({
        capabilities = capabilities,
    })
    lspconfig.matlab_ls.setup({
        capabilities = capabilities,
    })

    if not configs.hlsl_ls then
        configs.hlsl_ls = {
            default_config = {
                cmd = { 'shader-ls', 'lsp' },
                root_dir = lspconfig.util.root_pattern('.git'),
                filetypes = { 'hlsl' },
                settings = {},
            },
        }
    end
    lspconfig.hlsl_ls.setup({
        capabilities = capabilities,
    })
end

local function telescope_setup()
    require('telescope').setup({
        defaults = {
            file_ignore_patterns = {
                "vendor/*", "build/*", "out/*", "bin/*", "lib/*", "deps/*",
                "third_party/*", "third%-party/*", "thirdparty/*"
            },
        },
    })
end

local function conform_setup()
    require('conform').setup({
        formatters_by_ft = {
            lua = { 'stylua' },
            yaml = { 'yamlfix' },
            python = { 'black', 'isort' },
        },
    })
end

local function nvim_tree_setup()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require('nvim-tree').setup({
        sort = {
            sorter = 'case_sensitive',
        },
        view = {
            width = 50,
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = true,
        },
    })
end

local function floaterm_setup()
    vim.cmd [[let g:floaterm_wintype = 'split']]
    vim.cmd [[let g:floaterm_height = 0.3]]
end

local function autosave_setup()
    require('auto-save').setup()
end

local function cmake_setup()
    require('cmake').setup()
end

local function colorscheme_setup()
    require('kanagawa').setup({
        transparent = true,
    })

    vim.cmd [[colorscheme kanagawa-wave]]

    vim.api.nvim_set_hl(0, 'SpellBad', { underline = true, sp = 'grey' })
    vim.api.nvim_set_hl(0, 'SpellCap', { underline = true, sp = 'grey' })
    vim.api.nvim_set_hl(0, 'SpellRare', { underline = true, sp = 'grey' })
    vim.api.nvim_set_hl(0, 'SpellLocal', { underline = true, sp = 'grey' })
end

local function external_file_protection_setup()
    vim.api.nvim_create_autocmd('BufReadPost', {
        pattern = '*',
        callback = function()
            local allowed_dirs = {
                vim.fn.getcwd(),
                vim.fn.stdpath('config'),
            }

            local exceptions = {
                vim.fn.getcwd() .. '/vendor',
            }

            for i, dir in ipairs(allowed_dirs) do
                local unixified_dir, _ = dir:gsub('\\', '/')
                allowed_dirs[i] = unixified_dir
            end

            for i, dir in ipairs(exceptions) do
                local unixified_dir, _ = dir:gsub('\\', '/')
                exceptions[i] = unixified_dir
            end

            local current_file, _ = vim.fn.expand('%:p'):gsub('\\', '/')
            local allowed = false

            for _, dir in ipairs(allowed_dirs) do
                if current_file:match('^' .. dir .. '/') then
                    allowed = true
                    break
                end
            end

            for _, dir in ipairs(exceptions) do
                if current_file:match('^' .. dir .. '/') then
                    allowed = false
                    break
                end
            end

            if not allowed then
                vim.bo.modifiable = false
            end
        end,
    })
end

local function iron_setup()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup {
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = {"zsh"}
          },
          python = {
            command = { "ipython", "--no-autoindent" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          }
        },
        -- set the file type of the newly created repl to ft
        -- bufnr is the buffer id of the REPL and ft is the filetype of the 
        -- language being used for the REPL. 
        repl_filetype = function(bufnr, ft)
          return ft
          -- or return a string name such as the following
          -- return "iron"
        end,
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.vertical.botright(0.4)

        -- repl_open_cmd can also be an array-style table so that multiple 
        -- repl_open_commands can be given.
        -- When repl_open_cmd is given as a table, the first command given will
        -- be the command that `IronRepl` initially toggles.
        -- Moreover, when repl_open_cmd is a table, each key will automatically
        -- be available as a keymap (see `keymaps` below) with the names 
        -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
        -- For example,
        -- 
        -- repl_open_cmd = {
        --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
        --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
        -- }

      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        toggle_repl = "<space>rr", -- toggles the repl open and closed.
        -- If repl_open_command is a table as above, then the following keymaps are
        -- available
        -- toggle_repl_with_cmd_1 = "<space>rv",
        -- toggle_repl_with_cmd_2 = "<space>rh",
        restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_paragraph = "<space>sp",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        send_code_block = "<space>sb",
        send_code_block_and_move = "<space>sn",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
    vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')
end

filetype_setup()
treesitter_setup()
cmp_setup()
mason_setup()
lsp_setup()
telescope_setup()
conform_setup()
nvim_tree_setup()
floaterm_setup()
autosave_setup()
cmake_setup()
colorscheme_setup()
external_file_protection_setup()
iron_setup()
