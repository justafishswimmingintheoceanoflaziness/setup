local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

require("lazy").setup({
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			dashboard.section.header.val = {
				[[⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣠⣤⣤⣤⣤⣤⣤⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀]],
				[[⣶⣶⣶⣶⡄⢰⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡆⢠⣴⣶⣶⣶]],
				[[⢹⣿⡿⣿⣷⠀⠿⣿⣿⣿⣦⣀⠀⠀⠀⠀⣀⣴⣿⣿⣿⠿⠀⣾⣿⢿⣿⡏]],
				[[⠘⣿⣷⣬⡙⠿⣦⣌⡙⠿⣿⣿⣷⣦⣴⣾⣿⣿⠿⢋⣡⣴⠿⢋⣥⣾⣿⠃]],
				[[⠀⢻⣿⣌⠛⢷⣌⡙⢿⣶⡌⠙⢿⣿⣿⠿⠋⢡⣶⡿⢋⣡⡶⠛⣡⣿⡟⠀]],
				[[⠀⠘⠿⣿⣿⣦⣌⠛⢾⣿⣇⠸⣷⣌⣡⣶⡇⣸⣿⡷⠛⣡⣴⣿⣿⠿⠃⠀]],
				[[⠀⠀⢠⣌⠻⢿⣿⣿⣦⣿⣿⠀⣿⣿⣿⣿⠀⣿⣿⣴⣿⣿⡿⠟⣡⡄⠀⠀]],
				[[⠀⠀⢸⣿⣷⠀⠀⠉⠉⠉⠛⠀⣿⣿⣿⣿⠀⠛⠉⠉⠉⠀⠀⣾⣿⡇⠀⠀]],
				[[⠀⠀⢸⣿⣿⣿⣦⠀⢠⣴⣾⡇⢸⣿⣿⣿⠀⣷⣦⡄⠀⣴⣿⣿⣿⡇⠀⠀]],
				[[⠀⠀⠀⣿⣿⣿⣿⠀⢸⣿⣿⡇⢸⣿⣿⣿⠀⣿⣿⡇⠀⣿⣿⣿⣿⠁⠀⠀]],
				[[⠀⠀⠀⣿⣿⣿⣿⠀⢸⣿⣿⡇⢾⣿⣿⣿⠀⣿⣿⡇⠀⣿⣿⣿⣿⠀⠀⠀]],
				[[⠀⠀⠀⠻⢿⣿⣿⠀⢸⣿⣿⣷⣶⣶⣶⣶⣶⣿⣿⡇⠀⣿⣿⣿⠟⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠙⢿⠀⢸⣿⣿⠋⣉⣉⣉⣉⠉⣿⣿⡇⠀⡿⠋⠀⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠃⣼⣿⣿⣿⣿⣧⠘⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀]],
				[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠘⠛⠛⠛⠛⠛⠛⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
			}

			dashboard.section.buttons.val = {
				dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("b", "  > Browse files", ":Oil --float<CR>"),
				dashboard.button("f", "󰈞  > Find file", ":Telescope find_files<CR>"),
				dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
			}

			alpha.setup(dashboard.config)
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = function() require("colorizer").setup({ "*", css = { rgb_fn = true } }) end,
	},

	{
		"numToStr/Comment.nvim",
		config = function() require("Comment").setup() end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			cmp.setup({
				snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, { name = "luasnip" },
				}, { { name = "buffer" } }),
			})
		end,
	},
	{
		'hrsh7th/nvim-pasta',
		config = function()
			-- Set up key mappings for pasting
			vim.keymap.set({ 'n', 'x' }, 'p', require('pasta.mapping').p)
			vim.keymap.set({ 'n', 'x' }, 'P', require('pasta.mapping').P)

			-- Configure nvim-pasta settings
			require('pasta').config.next_key = vim.keycode('<C-n>') -- Key to cycle to the next yank
			require('pasta').config.prev_key = vim.keycode('<C-p>') -- Key to cycle to the previous yank
			require('pasta').config.indent_key = vim.keycode(',') -- Key to indent the pasted text
			require('pasta').config.indent_fix = true -- Enable automatic indentation fixing
		end
	},
	{
		'hrsh7th/nvim-automa',
		config = function()
			local automa = require('automa')
			automa.setup({
				mapping = {
					['.'] = {
						queries = {
							-- wide-range dot-repeat definition.
							automa.query_v1({ '!n(h,j,k,l)+' }),
						}
					},
				},
			})
		end
	},
	{ "kyazdani42/nvim-web-devicons" },
	{
		'akinsho/toggleterm.nvim',
		version = "*", -- You can specify a version if needed
		config = function()
			require("toggleterm").setup {
				-- Configuration options go here
				size = 50, -- Default terminal size
				open_mapping = [[<c-\>]], -- Key mapping to toggle the terminal
				hide_numbers = true, -- Hide the number column in the terminal
				shade_filetypes = {},
				shade_terminals = true,
				start_in_insert = true, -- Start in insert mode
				insert_mappings = true, -- Enable insert mode mappings
				persist_size = true, -- Keep the terminal size after closing
				direction = 'vertical', -- Terminal direction (horizontal, vertical, tab)
				close_on_exit = true, -- Close the terminal when the process exits
				open_dir = vim.fn.getcwd(),
				shell = vim.o.shell, -- Use the default shell
			}
		end
	},

	{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "kdheepak/cmp-latex-symbols" },

	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
	},

	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					rust = { "rustfmt" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					go = { "gofmt", "goimports" },
					bash = { "shfmt" },
					sh = { "shfmt" },
					c = { "clang-format" },
					cpp = { "clang-format" },
					html = { "prettier" },
					css = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
					yaml = { "prettier" },
				},
				format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
			})
		end,
	},

	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		config = function() require("fidget").setup() end,
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},

	{
		"Wansmer/treesj",
		keys = { { "<leader>j", function() require("treesj").toggle() end, desc = "Toggle Split/Join" } },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function() require("treesj").setup({}) end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function() require("nvim-autopairs").setup({}) end,
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function() require("nvim-surround").setup({}) end,
	},

	{
		"williamboman/mason.nvim",
		config = function() require("mason").setup() end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls", "lua_ls", "rust_analyzer", "gopls", "ts_ls",
					"html", "cssls", "emmet_ls", "tailwindcss", "pyright", "clangd",
					"yamlls", "jsonls", "eslint", "marksman", "sqlls", "texlab",
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local util = require("lspconfig.util")

			local servers = {
				{
					name = "bashls",
					cmd = { "bash-language-server", "start" },
					filetypes = { "sh", "bash" },
					root_dir = util.find_git_ancestor,
				},
				{
					name = "lua_ls",
					cmd = { "lua-language-server" },
					filetypes = { "lua" },
					root_dir = util.root_pattern(".git", ".luarc.json", ".luarc.jsonc", ".luacheckrc",
						".stylua.toml", "stylua.toml", "selene.toml", "selene.yml"),
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim" } },
							workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
							telemetry = { enable = false },
						},
					},
				},
				{
					name = "gopls",
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				},
				{
					name = "rust_analyzer",
					cmd = { "rust-analyzer" },
					filetypes = { "rust" },
					root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
				},
				{
					name = "ts_ls", -- ✅ FIXED: Correct server name
					cmd = { "typescript-language-server", "--stdio" },
					filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
					root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json",
						".git"),
				},
			}

			for _, server in ipairs(servers) do
				server.capabilities = capabilities

				vim.api.nvim_create_autocmd("FileType", {
					pattern = server.filetypes,
					callback = function(args)
						local clients = vim.lsp.get_clients({ bufnr = args.buf })
						if not vim.tbl_isempty(clients) then
							return -- If there are active clients, do nothing
						end
						vim.lsp.start({
							name = server.name,
							cmd = server.cmd, -- Ensure you have the command to start the server
							capabilities = server.capabilities,
							-- Add any other necessary server options here
						})
					end,
				})
			end

			-- LSP keymaps
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open diagnostic" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>wl",
						function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
						opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				end,
			})
		end,
	},

	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		config = function() require("rust-tools").setup({}) end,
	},
	{
		'nvimdev/lspsaga.nvim',
		config = function()
			require('lspsaga').setup({})
		end,
		dependencies = {
			'nvim-treesitter/nvim-treesitter', -- optional
			'nvim-tree/nvim-web-devicons', -- optional
		}
	},

	{
		"jose-elias-alvarez/typescript.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		config = function() require("typescript").setup({}) end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "bash", "go", "rust", "typescript", "javascript", "lua", "python", "html", "css", "markdown", "json", "yaml" },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = { enable = true, lookahead = true, keymaps = { ["af"] = "@function.outer", ["if"] = "@function.inner", ["ac"] = "@class.outer", ["ic"] = "@class.inner" } },
					move = { enable = true, set_jumps = true, goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" }, goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" } },
				},
			})
		end,
	},

	{
		"iamcco/markdown-preview.nvim",
		build = function() vim.fn["mkdp#util#install"]() end,
		ft = "markdown",
		config = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown Preview" })
			vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { desc = "Markdown Stop" })
		end,
	},

	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup()
			vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { icons_enabled = true, theme = "auto", component_separators = "|", section_separators = "" },
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

	{
		'catppuccin/nvim',
		as = 'catppuccin', -- Alias for the plugin
		config = function()
			-- Set the color scheme to Latte
			require('catppuccin').setup({
				flavour = 'latte', -- Set the flavor to Latte
				transparent_background = false, -- Set to true for a transparent background
				term_colors = true, -- Enable terminal colors
				styles = {
					comments = { 'italic' },
					functions = { 'italic' },
					keywords = { 'bold' },
				},
			})
			vim.cmd("colorscheme catppuccin") -- Apply the colorscheme
		end
	},
	-- {
	-- 	'scottmckendry/cyberdream.nvim',
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require('cyberdream').setup({
	-- 			variant = 'neon', -- Set the theme to light
	-- 		})
	-- 		vim.cmd.colorscheme("cyberdream")
	-- 	end
	-- },
	-- {
	-- 	"savq/melange-nvim",
	-- 	config = function()
	-- 		vim.cmd.colorscheme("melange")
	-- 	end,
	-- },

	-- { "vim-scripts/newsprint.vim" },
	-- { "gbprod/nord.nvim" },
	-- { "slugbyte/lackluster.nvim", },
	-- { "vim-scripts/zenesque.vim", },
	-- { "jaredgorski/fogbell.vim", },
	-- { "oahlen/iceberg.nvim", },
	-- { "Skardyy/makurai-nvim", },
	-- { "ellisonleao/gruvbox.nvim" },
	-- { "jnurmine/Zenburn", },
	-- { "RRethy/base16-nvim", },
	-- {
	-- 	"sainnhe/gruvbox-material",
	-- 	config = function()
	-- 		vim.g.gruvbox_material_background = "hard"
	-- 		vim.cmd.colorscheme("gruvbox-material")
	-- 	end,
	-- },
	-- {
	-- 	"blazkowolf/gruber-darker.nvim",
	-- 	opts = {
	-- 		bold = false,
	-- 	},
	-- },
	-- {
	-- 	"zenbones-theme/zenbones.nvim",
	-- 	dependencies = "rktjmp/lush.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	italic = false,
	-- 	config = function()
	-- 		vim.cmd.colorscheme("zenbones")
	-- 	end,
	-- },

	{
		'ray-x/go.nvim',
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/vim-vsnip",
			"hrsh7th/nvim-cmp", -- Completion plugin
			"hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
			"hrsh7th/cmp-buffer", -- Buffer source for nvim-cmp
		},
		config = function()
			-- Setup go.nvim with all configuration options
			require("go").setup({
				go = 'go', -- Path to the Go binary
				goimport = 'goimports', -- Use goimports for importing
				gofmt = 'golines', -- Use golines for formatting
				max_line_len = 120, -- Maximum line length
				tag_transform = false, -- Disable tag transformation
				lsp_cfg = true, -- Enable LSP configuration
				lsp_gopls = {
					cmd = { 'gopls' },
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true, -- Enable staticcheck
						},
					},
				},
			})

			-- Key mappings for Go commands
			local opts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap('n', '<leader>gd', ':GoDef<CR>', opts) -- Go to definition
			vim.api.nvim_set_keymap('n', '<leader>gD', ':GoDoc<CR>', opts) -- Show documentation
			vim.api.nvim_set_keymap('n', '<leader>gf', ':GoFmt<CR>', opts) -- Format the file
			vim.api.nvim_set_keymap('n', '<leader>r', ':GoRun<CR>', opts) -- Run the current file
			vim.api.nvim_set_keymap('n', '<leader>gt', ':GoTest<CR>', opts) -- Run tests
			vim.api.nvim_set_keymap('n', '<leader>gT', ':GoTestFunc<CR>', opts) -- Run test function

			-- Enable pop-up menu for completion
			vim.o.completeopt = 'menuone,noselect'

			-- Setup nvim-cmp for completion
			local cmp = require('cmp')
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For vsnip users
					end,
				},
				mapping = {
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.close(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
				},
			})

			-- Show documentation in a pop-up menu when hovering
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded", -- Add rounded borders to the pop-up
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
	},

	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
		keys = {
			{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>",  desc = "Window left" },
			{ "<C-j>", "<cmd>TmuxNavigateDown<cr>",  desc = "Window down" },
			{ "<C-k>", "<cmd>TmuxNavigateUp<cr>",    desc = "Window up" },
			{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window right" },
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function() require("which-key").setup({}) end,
	},

	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({ window = { width = 100 } })
			vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Zen mode" })
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local function open_multi_files(prompt_bufnr)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local multi_selection = picker:get_multi_selection()
				actions.close(prompt_bufnr)

				if #multi_selection == 0 then
					-- If no multi-select, open currently selected file
					local single_selection = action_state.get_selected_entry()
					if single_selection and single_selection.path then
						vim.cmd("edit " .. single_selection.path)
					end
					return
				end

				-- Open all multi-selected files
				for _, entry in ipairs(multi_selection) do
					if entry.path then
						vim.cmd("vsplit " .. entry.path) -- Change "edit" to "tabedit"/"vsplit" as you prefer
					end
				end
			end

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<Tab>"] = actions.toggle_selection +
							    actions.move_selection_next,
							["<S-Tab>"] = actions.toggle_selection +
							    actions.move_selection_previous,
							["<CR>"] = open_multi_files,
						},
						n = {
							["<Tab>"] = actions.toggle_selection +
							    actions.move_selection_next,
							["<S-Tab>"] = actions.toggle_selection +
							    actions.move_selection_previous,
							["<CR>"] = open_multi_files,
						},
					},
				},
				pickers = {
					find_files = {
						cwd = vim.fn.getcwd(), -- limits to current working directory
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
					},
				},
			})

			telescope.load_extension("fzf")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
		end,
	},

	{
		"CRAG666/code_runner.nvim",
		config = function()
			require("code_runner").setup({
				-- Choose default run mode ("term" uses Neovim's built-in terminal)
				mode = "term",

				-- Start in insert mode in terminal (false to start in normal mode)
				startinsert = true,

				-- Filetype run commands (can override per project/language)
				filetype = {
					python = "python3 -u",
					javascript = "node",
					typescript = "deno run",
					go = "go run",
					lua = "lua",
					rust = "cargo run",
					cpp = "g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
					c = "gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
					java = "javac $fileName && java $fileNameWithoutExt",
					sh = "bash",
					-- add more as needed
				},

				-- Custom handlers before and after run commands
				hook = {
					before_run = function()
						-- Save file automatically before running
						vim.cmd("write")
					end,
					after_run = function()
						-- Print a message after code execution finishes
						print("Execution finished!")
					end,
				},

				-- Floating window configurations (optional)
				float = {
					border = "double", -- border style: "single", "double", "shadow", "curved"
				},

				-- Floating window size options
				float_opts = {
					width = 80,
					height = 20,
				},
			})

			-- Key mappings to run current file or visual selection
			vim.keymap.set("n", "<leader>rr", "<cmd>RunCode<cr>", { desc = "Run current file or selection" })
			vim.keymap.set("v", "<leader>rr", "<cmd>RunCode<cr>", { desc = "Run selected code" })
		end,
	},


})




vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "No highlight" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "rust", "typescript", "javascript", "bash", "sh" },
	callback = function()
		vim.opt_local.shiftwidth = 2; vim.opt_local.tabstop = 2; vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.lua", "*.py", "*.rs", "*.js", "*.ts", "*.go", "*.sh", "*.bash" },
	callback = function() require("conform").format({ async = false, timeout_ms = 1000 }) end,
})

-- vim.schedule(function()
-- 	vim.notify("configuration loaded successfully!", vim.log.levels.INFO, { title = "LazyVim Config" })
-- end)
