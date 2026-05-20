---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts.window = opts.window or {}
    opts.window.mappings = opts.window.mappings or {}
    opts.window.mappings["O"] = function(state)
      local node = state.tree:get_node()
      local path = node:get_id()
      vim.fn.jobstart({ "open", path }, { detach = true })
    end
  end,
}
