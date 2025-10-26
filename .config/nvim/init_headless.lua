local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
    -- stylua: ignore
    vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- IMPORTANT:  Only require lazy.nvim, NOT your entire AstroNvim config
local lazy = require("lazy")

-- Configure lazy.nvim with ONLY the plugins you NEED for headless
lazy.setup({
    -- Example: If you need only 'some-plugin' for headless:
    {'some-plugin'},  -- Add only the plugins you need in headless mode

    -- If you need to run a command after plugin setup:
    config = function()
        -- Put your headless-specific commands here
        vim.cmd [[
            " Example: Run a command
            " PackerSync  -- If you need Packer
            " MyCustomFunction() -- If you have custom functions
        ]]

        -- IMPORTANT: Quit Neovim after your commands are done
        vim.cmd [[quitall]] -- or vim.cmd [[q]]

    end
}, {
    -- IMPORTANT: Set a root directory or specify the config directory
    root = "~/.config/nvim", -- or set config = "~/.config/nvim/lua"
    -- If you set root, you don't need to specify config separately
    -- config = "~/.config/nvim/lua"
})


