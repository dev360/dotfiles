return {
  n = {
    ["<leader>G"] = {
      function()
        if vim.fn.expand('%:e') == 'go' then
          local file_dir = vim.fn.expand('%:p:h')
          local filename = vim.fn.expand('%:t')
          vim.cmd('!' .. 'cd ' .. file_dir .. ' && go run ' .. filename)
        else
          print('Not a Go file')
        end
      end,
      desc = "Run Go file"
    },
  },
}
