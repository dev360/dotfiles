-- Aerial symbol outline configuration
-- Prefer LSP over treesitter to avoid buggy per-language treesitter queries
-- (notably aerial's Python query, which errors with "method 'start' (a nil value)").

---@type LazySpec
return {
  "stevearc/aerial.nvim",
  opts = {
    backends = {
      ["_"] = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      -- aerial's bundled Python treesitter query is broken; force LSP only
      python = { "lsp" },
    },
  },
}
