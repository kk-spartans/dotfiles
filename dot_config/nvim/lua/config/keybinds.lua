vim.g.mapleader = " "

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.rename)
