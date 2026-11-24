-- Nice and simple folding:
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.o.foldtext = ""
vim.opt.foldcolumn = "0"
vim.opt.fillchars:append({fold = " "})
