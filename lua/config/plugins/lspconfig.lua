return {
  {
    "neovim/nvim-lspconfig",
    enabled = true,
    config = function()
      require("lspconfig").lua_ls.setup {}
    end,
  }
}
