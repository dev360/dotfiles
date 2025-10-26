return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "rafamadriz/friendly-snippets", -- The snippet library
  },
  config = function(plugin, opts)
    require("astronvim.plugins.configs.luasnip")(plugin, opts)
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}
