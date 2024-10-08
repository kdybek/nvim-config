local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- Greeter
    use {
        'goolord/alpha-nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.startify'.config)
            local startify = require('alpha.themes.startify')
            startify.section.top_buttons.val = {
                startify.button('e', 'New File', ':ene<bar>startinsert<cr>'),
                startify.button('v', 'Neovim Config', ':e ' .. vim.fn.stdpath('config') .. '/init.lua<cr>'),
            }
        end
    }

    -- IDE plugins
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    use {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'neovim/nvim-lspconfig',
    }
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'voldikss/vim-floaterm'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = { 'nvim-tree/nvim-web-devicons' },
    }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } },
    }
    use 'stevearc/conform.nvim'
    use 'github/copilot.vim'
    use 'pocco81/auto-save.nvim'
    use 'mbbill/undotree'

    -- Color schemes
    use 'tomasr/molokai'
    use 'rebelot/kanagawa.nvim'

    if packer_bootstrap then
        require('packer').sync()
    end
end)
