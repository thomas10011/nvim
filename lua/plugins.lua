-- Install Packer automatically if it's not installed(Bootstraping)
-- Hint: string concatenation is done by `..`
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


-- Reload configurations if we modify plugins.lua
-- Hint
--     <afile> - replaced with the filename of the buffer being manipulated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])


-- Install plugins here - `use ...`
-- Packer.nvim hints
--     after = string or list,           -- Specifies plugins to load before this plugin. See "sequencing" below
--     config = string or function,      -- Specifies code to run after this plugin is loaded
--     requires = string or list,        -- Specifies plugin dependencies. See "dependencies".
--     ft = string or list,              -- Specifies filetypes which load this plugin.
--     run = string, function, or table, -- Specify operations to be run after successful installs/updates of a plugin
return require('packer').startup(function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        ---------------------------------------
        -- NOTE: PUT YOUR THIRD PLUGIN HERE --
        ---------------------------------------
        use 'tanvirtin/monokai.nvim'

        use { 'neovim/nvim-lspconfig' }
        use { 'hrsh7th/nvim-cmp', config = [[require('config.nvim-cmp')]] }
        use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
        use { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' } -- buffer auto-completion
        use { 'hrsh7th/cmp-path', after = 'nvim-cmp' } -- path auto-completion
        use { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' } -- cmdline auto-completion
        use 'L3MON4D3/LuaSnip'
        use 'saadparwaiz1/cmp_luasnip'

        use { 'williamboman/mason.nvim' }
        use { 'williamboman/mason-lspconfig.nvim'}
        -- use { 'neovim/nvim-lspconfig' }            -- previous installed

        use {
            'nvim-lualine/lualine.nvim',
            config = [[require('config.lualine')]],
            requires = { 'nvim-tree/nvim-web-devicons', opt = true }
        }

        use {
            'nvim-tree/nvim-tree.lua',
            config = [[require('config.nvim-tree')]],
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional
            },
        }

        use {
            'nvim-treesitter/nvim-treesitter',
            config = [[require('config.nvim-treesitter')]],
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
        }
        
        use {
            'nvim-telescope/telescope.nvim', tag = '0.1.2',
            -- or                            , branch = '0.1.x',
            config = [[require('config.telescope')]],
            requires = { {'nvim-lua/plenary.nvim'} }
        }

        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require('packer').sync()
        end
    end)
