return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("null-ls").setup({
            sources = {
                require("null-ls").builtins.formatting.prettierd,
                require("none-ls.diagnostics.eslint_d"),
            },
        })
    end,
    lazy = false,
}
