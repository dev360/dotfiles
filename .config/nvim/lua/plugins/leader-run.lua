  return {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<leader>G"] = {
            function()
              if vim.fn.expand('%:e') == 'go' then
                local file_dir = vim.fn.expand('%:p:h')
                local filename = vim.fn.expand('%:t')
                vim.cmd('!' .. 'cd ' .. file_dir .. ' && go run ' .. filename)
              end
            end,
            desc = "Run Go file"
          },
        },
      },
    },
  }
