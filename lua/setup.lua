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
            enable = true,
        },
        modules = {},
    })

    -- Folding
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
    vim.opt.foldcolumn = '2'
end

local function cmp_setup()
    local cmp = require('cmp')
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
        ensure_installed = { 'ast_grep', 'harper_ls', 'lua_ls', 'clangd', 'cmake', 'glsl_analyzer' },
        automatic_installation = true,
    })
end

local function lsp_setup()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('lspconfig').lua_ls.setup({
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
                    checkThirdParty = false,  -- Avoid prompting about third-party libraries
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        capabilities = capabilities,
    })
    require('lspconfig').clangd.setup({})
    require('lspconfig').cmake.setup({})
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

local function vim_cmake_setup()
    -- Generate compile_commands.json
    vim.cmd [[let g:cmake_link_compile_commands = 1]]
    vim.cmd [[let g:cmake_build_dir_location = './build']]
end

local function colorscheme_setup()
    require('kanagawa').setup({
        transparent = true,
    })

    vim.cmd [[colorscheme kanagawa-wave]]
end

treesitter_setup()
cmp_setup()
mason_setup()
lsp_setup()
nvim_tree_setup()
floaterm_setup()
vim_cmake_setup()
colorscheme_setup()

