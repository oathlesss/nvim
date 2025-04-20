return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make"
    },
    config = function()
      require('telescope').setup {

        defaults = vim.tbl_extend(
          "force",
          require('telescope.themes').get_ivy(),
          {
          --- your own `default` options go here, e.g.
          }
        ),
        extensions = {
          fzf = {}
        },
      }
      require("telescope").load_extension("fzf")
      vim.keymap.set("n", "<space>ft", require("telescope.builtin").builtin)
      vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)
      vim.keymap.set("n", "<space>fd", require("telescope.builtin").find_files)
      vim.keymap.set("n", "<space>en", function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config")
        })
      end)
      vim.keymap.set("n", "<space>ep", function()
        require("telescope.builtin").find_files({
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        })
      end)

      require("config.telescope.multigrep").setup()
    end
  }
}
