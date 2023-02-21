local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local autocmd = vim.api.nvim_create_autocmd
--local map = vim.api.nvim_set_keymap opt.shiftwidth = 4
opt.expandtab = false
opt.preserveindent = true
opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.smartcase = true
opt.colorcolumn = { '120' }
opt.wrap = false
cmd('highlight ColorColumn ctermbg=darkgray')


local function map(mode, lhs, rhs, opts)
	local options = { noremap=true }
	if opts then options = vim.tbl_extend('force', options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

map({'n', 'v'}, ';', ':')
map({'n', 'v'}, ':', ';')

-- set space as leader
map('n', '<SPACE>', '<Nop>')
g.mapleader = " "

--air-line
g.airline_powerline_fonts = 1

--NERDTree
map('n', '<leader>n :NERDTreeFocus<CR>', ':NERDTreeRefreshRoot<CR>')
--NERDTree autostart"
autocmd('VimEnter', {command = 'NERDTree | wincmd p'})

--Close the tab if NERDTree is the only window remaining in it.
autocmd("BufEnter", {
	pattern = "*",
	command = "if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
})

-- remove ex-mode shortcut
map('n', 'Q', '<Nop>')

--trigger the fuzzy finder (fzf)
map('n', '<leader>f', ":Files<CR>")
map('n', '<leader>g', ":GFiles<CR>")
map('n', '<leader>b', ":Buffers<CR>")
map('n', '<leader>r', ":Rg<CR>")

--quickfixlist binds
map('n', '<C-j>', ":cnext<CR>")
map('n', '<C-k>', ":cprev<CR>")

--locallist binds
map('n', '<C-l>', ":lnext<CR>")
map('n', '<C-h>', ":lprev<CR>")

--split  keybinds
map('n', '<leader>s', ":sp<CR>")
map('n', '<leader>v', ":vs<CR>")

map('n', '<leader>h', "<C-w>h")
map('n', '<leader>j', "<C-w>j")
map('n', '<leader>k', "<C-w>k")
map('n', '<leader>l', "<C-w>l")

--coloring stuff
g.dracula_colorterm = 0
cmd('colorscheme dracula')

local lsp = require("lspconfig")
local lsp_format = require("lsp-format") 

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	lsp_format.on_attach(client)	
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<leader>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


lsp.pylsp.setup {
	on_attach = on_attach,
	settings = {
		pylsp = {
			plugins = {
				pylint = { enable = true },
				black = {
					enable = true,
					line_legth=120,
				},
			},
		},
	},
}

lsp.rnix.setup {
	on_attach = on_attach
}

local cmp = require("cmp")

cmp.setup {
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm({ select = false }),


		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'path' }
	}, {
		{
			name = 'buffer',
			option = {
				keyword_pattern = [[\k\+]], -- allow unicode multibyte characters
			},
		}
	}),
}


