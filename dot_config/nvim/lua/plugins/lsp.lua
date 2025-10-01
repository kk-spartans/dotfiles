return {
    {
        "mason-org/mason.nvim",
        opts = {},
        lazy = false,
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "pyright", "ts_ls", "powershell_es", "stylua", "ruff" },
            automatic_enable = true,
        },
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        lazy = false,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
        lazy = false,
    },
}
