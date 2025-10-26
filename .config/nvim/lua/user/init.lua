return {
  {
    "astronvim/astrocore",
    opts = {
      -- ... other astrocore options
      -- This hook runs very late in the startup process,
      -- guaranteeing your command is executed.
      on_very_lazy = function()
        vim.fn.serverstart('/tmp/nvim')
      end,
    },
  },
}
