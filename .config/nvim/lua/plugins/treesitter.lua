-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "go",         -- Go syntax parsing
      "typescript", -- TypeScript syntax parsing
      "tsx",        -- TSX/React syntax parsing
      "javascript", -- JavaScript syntax parsing
    },
  },
}
