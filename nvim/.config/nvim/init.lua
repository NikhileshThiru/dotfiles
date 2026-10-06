vim.opt.termguicolors = true

-- ============================================================================
-- OPTIONS
-- ============================================================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.cmdheight = 1
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.showmode = false
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.opt.lazyredraw = true
vim.opt.synmaxcol = 300
vim.opt.fillchars = { eob = " " }

local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = undodir

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.autochdir = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "inclusive"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding = "utf-8"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Let Neovim set the terminal/window title
vim.opt.title = true
vim.opt.titlestring = "%t (%{fnamemodify(getcwd(), ':t')})"

-- ============================================================================
-- STATUSLINE (best-of-both: your look + gitsigns git info + safe fallbacks)
-- ============================================================================

-- Filetype with Nerd Font icon (your table, unchanged)
local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua = "\u{e620} ",
    python = "\u{e73c} ",
    javascript = "\u{e74e} ",
    typescript = "\u{e628} ",
    javascriptreact = "\u{e7ba} ",
    typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ",
    css = "\u{e749} ",
    scss = "\u{e749} ",
    json = "\u{e60b} ",
    markdown = "\u{e73e} ",
    vim = "\u{e62b} ",
    sh = "\u{f489} ",
    bash = "\u{f489} ",
    zsh = "\u{f489} ",
    rust = "\u{e7a8} ",
    go = "\u{e724} ",
    c = "\u{e61e} ",
    cpp = "\u{e61d} ",
    java = "\u{e738} ",
    php = "\u{e73d} ",
    ruby = "\u{e739} ",
    swift = "\u{e755} ",
    kotlin = "\u{e634} ",
    dart = "\u{e798} ",
    elixir = "\u{e62d} ",
    haskell = "\u{e777} ",
    sql = "\u{e706} ",
    yaml = "\u{f481} ",
    toml = "\u{e615} ",
    xml = "\u{f05c} ",
    dockerfile = "\u{f308} ",
    gitcommit = "\u{f418} ",
    gitconfig = "\u{f1d3} ",
    vue = "\u{fd42} ",
    svelte = "\u{e697} ",
    astro = "\u{e628} ",
  }
  if ft == "" then
    return " \u{f15b} "
  end
  return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size (your function, unchanged)
local function file_size()
  local size = vim.fn.getfsize(vim.fn.expand("%"))
  if size < 0 then
    return ""
  end
  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end
  return " \u{f016} " .. size_str .. " "
end

-- Mode icon (your mapping, unchanged)
local function mode_icon()
  local mode = vim.fn.mode()
  local modes = {
    n = " \u{f121}  NORMAL",
    i = " \u{f11c}  INSERT",
    v = " \u{f0168} VISUAL",
    V = " \u{f0168} V-LINE",
    ["\22"] = " \u{f0168} V-BLOCK",
    c = " \u{f120} COMMAND",
    s = " \u{f0c5} SELECT",
    S = " \u{f0c5} S-LINE",
    ["\19"] = " \u{f0c5} S-BLOCK",
    R = " \u{f044} REPLACE",
    r = " \u{f044} REPLACE",
    ["!"] = " \u{f489} SHELL",
    t = " \u{f120} TERMINAL",
  }
  return modes[mode] or (" \u{f059} " .. mode)
end

-- Git info: prefer gitsigns (branch + diff counts), fallback to cached shell branch
local cached_branch = ""
local last_check = 0

local function git_info()
  -- Fast path: gitsigns
  local head = vim.b.gitsigns_head
  local s = vim.b.gitsigns_status_dict
  if head and head ~= "" and type(s) == "table" then
    local added = s.added or 0
    local changed = s.changed or 0
    local removed = s.removed or 0
    return (" \u{e725} %s  +%d ~%d -%d "):format(head, added, changed, removed)
  end

  -- Fallback: cheap cached shell branch (no diff counts available here)
  local now = vim.loop.now()
  if now - last_check > 5000 then
    cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    last_check = now
  end
  if cached_branch ~= "" then
    return " \u{e725} " .. cached_branch .. " "
  end
  return ""
end

_G.mode_icon = mode_icon
_G.file_type = file_type
_G.file_size = file_size
_G.git_info = git_info

vim.cmd([[highlight StatusLineBold gui=bold cterm=bold]])

local function setup_statusline()
  -- One consistent statusline (no WinLeave alternate), less flicker and simpler
  vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufEnter", "ColorScheme" }, {
    callback = function()
      vim.opt_local.statusline = table.concat({
        "  ",
        "%#StatusLineBold#",
        "%{v:lua.mode_icon()}",
        "%#StatusLine#",
        " \u{e0b1} %t %h%m%r",         -- filename (not full path)
        "%{v:lua.git_info()}",
        "\u{e0b1} ",
        "%{v:lua.file_type()}",
        "\u{e0b1} ",
        "%{v:lua.file_size()}",
        "%=",
        " \u{f017} %l:%c  %P ",
      })
    end,
  })
  vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })
end

setup_statusline()

-- ============================================================================
-- KEYMAPS
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })

vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Force Tab to insert a literal tab/indent in Insert & Select mode
vim.keymap.set({ "i", "s" }, "<Tab>", function()
	return "\t"
end, { expr = true, noremap = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	return "\b"
end, { expr = true, noremap = true })

-- ============================================================================
-- AUTOCMDS
-- ============================================================================
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.py",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.css",
		"*.scss",
		"*.html",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.c",
		"*.cpp",
		"*.h",
		"*.hpp",
	},
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then
				has_efm = true
				break
			end
		end
		if not has_efm then
			return
		end

		pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == "efm"
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then
			return
		end
		local last_pos = vim.api.nvim_buf_get_mark(0, '"')
		local last_line = vim.api.nvim_buf_line_count(0)
		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end
		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- Reload files changed outside of Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	callback = function()
		vim.cmd("checktime")
	end,
})

-- Auto-start Java LSP (jdtls)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		local jdtls = require("jdtls")

		local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }

		local bufname = vim.api.nvim_buf_get_name(0)
		local bufdir = vim.fs.dirname(bufname)

		local found = vim.fs.find(root_markers, { path = bufdir, upward = true })[1]
		local root_dir = found and vim.fs.dirname(found) or bufdir

		local mason = vim.fn.stdpath("data") .. "/mason"
		local jdtls_cmd = mason .. "/bin/jdtls"

		local project_name = vim.fn.fnamemodify(root_dir, ":t")
		local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

		jdtls.start_or_attach({
			cmd = { jdtls_cmd, "-data", workspace_dir },
			root_dir = root_dir,
		})
	end,
})

-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
	"https://www.github.com/EdenEast/nightfox.nvim",
	"https://github.com/akinsho/bufferline.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/mfussenegger/nvim-jdtls",
	"https://github.com/nvim-lua/plenary.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	"https://github.com/L3MON4D3/LuaSnip",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end

packadd("nvim-treesitter")
packadd("nightfox.nvim")
packadd("gitsigns.nvim")
packadd("mini.nvim")
packadd("fzf-lua")
packadd("plenary.nvim")
packadd("nvim-web-devicons")
packadd("bufferline.nvim")
packadd("nvim-tree.lua")
packadd("nvim-jdtls")

packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("efmls-configs-nvim")
packadd("LuaSnip")

-- ============================================================================
-- COLORSCHEME + UI LINKS
-- ============================================================================
-- On Omarchy, follow the system theme: Omarchy writes the current theme's
-- lazy.nvim spec to neovim.lua. Clone the plugins it names into their own pack
-- dir (not vim.pack, so theme switches don't touch the shared lockfile), run
-- their setup() with its opts, and apply its colorscheme. Without Omarchy
-- (macOS), carbonfox.
local omarchy_state = vim.fn.expand("~/.local/state/omarchy/current")
local omarchy_pack = vim.fn.stdpath("data") .. "/site/pack/omarchy-themes/opt/"

local function load_omarchy_plugin(spec, reload)
	if type(spec) == "string" then
		spec = { spec }
	end
	for _, dep in ipairs(spec.dependencies or {}) do
		load_omarchy_plugin(dep, reload)
	end

	local name = spec.name or spec[1]:match("[^/]+$")
	local dir = omarchy_pack .. name
	if not vim.uv.fs_stat(dir) then
		local cmd = { "git", "clone", "--quiet", "--depth=1" }
		if spec.branch or spec.tag then
			vim.list_extend(cmd, { "--branch", spec.branch or spec.tag })
		end
		vim.list_extend(cmd, { "https://github.com/" .. spec[1], dir })
		vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then
			vim.fn.delete(dir, "rf")
			return
		end
	end

	-- On a theme switch, drop the plugin's cached modules so setup() takes the new opts.
	if reload and vim.uv.fs_stat(dir .. "/lua") then
		for path, kind in vim.fs.dir(dir .. "/lua", { depth = 10 }) do
			if kind == "file" and path:match("%.lua$") then
				package.loaded[path:gsub("%.lua$", ""):gsub("/init$", ""):gsub("/", ".")] = nil
			end
		end
	end

	vim.cmd.packadd(name)
	if type(spec.opts) == "table" then
		local main = spec.main or name:gsub("^n?vim%-", ""):gsub("[%.%-]n?vim$", ""):gsub("%-neovim$", "")
		local ok, mod = pcall(require, main)
		if ok and type(mod) == "table" and type(mod.setup) == "function" then
			mod.setup(spec.opts)
		end
	end
end

local function omarchy_colorscheme(reload)
	local ok, specs = pcall(dofile, omarchy_state .. "/theme/neovim.lua")
	if not ok or type(specs) ~= "table" then
		return nil
	end
	local colorscheme
	for _, spec in ipairs(specs) do
		if spec[1] == "LazyVim/LazyVim" then
			colorscheme = spec.opts and spec.opts.colorscheme
		else
			load_omarchy_plugin(spec, reload)
		end
	end
	return colorscheme
end

local function apply_colorscheme(reload)
	if reload then
		vim.o.background = "dark" -- light themes switch it back themselves
	end
	local name = omarchy_colorscheme(reload)
	if not (name and pcall(vim.cmd.colorscheme, name)) then
		pcall(vim.cmd.colorscheme, "carbonfox")
	end

	vim.api.nvim_set_hl(0, "NvimTreeNormal", { link = "NormalNC" })
	vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { link = "NormalNC" })
	vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { link = "NormalNC" })
	vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "WinSeparator" })
end

vim.schedule(apply_colorscheme)

-- Re-apply when `omarchy theme set` swaps the theme (it writes theme.name last).
if vim.uv.fs_stat(omarchy_state) then
	local pending = false
	vim.uv.new_fs_event():start(omarchy_state, {}, function(err, filename)
		if err or filename ~= "theme.name" or pending then
			return
		end
		pending = true
		vim.defer_fn(function()
			pending = false
			apply_colorscheme(true)
		end, 100)
	end)
end

-- ============================================================================
-- TREESITTER
-- ============================================================================
local function setup_treesitter()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})

	local ensure_installed = {
		"vim",
		"vimdoc",
		"rust",
		"c",
		"cpp",
		"go",
		"html",
		"css",
		"javascript",
		"json",
		"lua",
		"markdown",
		"python",
		"typescript",
		"vue",
		"svelte",
		"bash",
	}

	local config = require("nvim-treesitter.config")
	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================
require("bufferline").setup({
	options = {
		separator_style = { "", "" },
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
		offsets = {
			{
				filetype = "NvimTree",
				text = "Files",
				text_align = "center",
				separator = false,
			},
		},
	},
})

-- ============================================================================
-- Bufferline background unification (single source of truth)
-- ============================================================================

local function unify_bufferline_background()
  -- match Normal/NormalNC background (your grey is #161616)
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false }) or {}
  local nc = vim.api.nvim_get_hl(0, { name = "NormalNC", link = false }) or {}
  local bg = normal.bg or nc.bg

  -- if bg is nil for any reason, fall back to your known grey
  if not bg then
    bg = tonumber("161616", 16)
  end

  local function setbg(group)
    local cur = vim.api.nvim_get_hl(0, { name = group, link = false }) or {}
    cur.bg = bg
    vim.api.nvim_set_hl(0, group, cur)
  end

  local groups = {
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineBuffer",
    "BufferLineBufferVisible",
    "BufferLineBufferSelected",

    "BufferLineTab",
    "BufferLineTabSelected",

    "BufferLineCloseButton",
    "BufferLineCloseButtonVisible",
    "BufferLineCloseButtonSelected",

    "BufferLineModified",
    "BufferLineModifiedVisible",
    "BufferLineModifiedSelected",

    "BufferLineDuplicate",
    "BufferLineDuplicateVisible",
    "BufferLineDuplicateSelected",

    "BufferLineSeparator",
    "BufferLineSeparatorVisible",
    "BufferLineSeparatorSelected",

    "BufferLineIndicator",
    "BufferLineIndicatorVisible",
    "BufferLineIndicatorSelected",

    -- this is the "Files" offset area when NvimTree is open
    "BufferLineOffset",
    "BufferLineOffsetSeparator",
  }

  for _, g in ipairs(groups) do
    setbg(g)
  end
  vim.api.nvim_set_hl(0, "BufferLineOffset", { bg = bg })
  vim.api.nvim_set_hl(0, "BufferLineOffsetSeparator", { bg = bg })
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false }) or {}
  local bg = normal.bg or tonumber("161616", 16)
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "WinSeparator" })
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { link = "NormalNC" })
end

vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  callback = function()
    vim.schedule(unify_bufferline_background)
  end,
})

require("nvim-tree").setup({
	view = {
		width = 32,
		adaptive_size = true,
	},
	filters = {
		dotfiles = false,
	},
	renderer = {
		group_empty = true,
	},
	update_focused_file = {
		enable = true,
		update_root = true,
        ignore_list = {},
	},
    respect_buf_cwd = true,
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		show_on_open_dirs = true,
	},
})

vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.defer_fn(function()
			local api = require("nvim-tree.api")
			api.tree.open()
			api.tree.focus()
		end, 10)
	end,
})

require("fzf-lua").setup({})

vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })

vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })

vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })

vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })

vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })

vim.keymap.set("n", "<leader>fX", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({ lsp_progress = { enable = false } })
require("mini.icons").setup({})

require("gitsigns").setup({
	signs = {
		add = { text = "\u{2590}" },
		change = { text = "\u{2590}" },
		delete = { text = "\u{2590}" },
		topdelete = { text = "\u{25e6}" },
		changedelete = { text = "\u{25cf}" },
		untracked = { text = "\u{25cb}" },
	},
	signcolumn = true,
	current_line_blame_opts = {
        delay = 500,
        virt_text_pos = "eol",
    }
})

require("mason").setup({})

vim.keymap.set("n", "]h", function()
	require("gitsigns").next_hunk()
end, { desc = "Next git hunk" })

vim.keymap.set("n", "[h", function()
	require("gitsigns").prev_hunk()
end, { desc = "Previous git hunk" })

vim.keymap.set("n", "<leader>hs", function()
	require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })

vim.keymap.set("n", "<leader>hr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })

vim.keymap.set("n", "<leader>hp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })

vim.keymap.set("n", "<leader>hb", function()
	require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })

vim.keymap.set("n", "<leader>hB", function()
	require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle inline blame" })

vim.keymap.set("n", "<leader>hd", function()
	require("gitsigns").diffthis()
end, { desc = "Diff this" })

-- ============================================================================
-- DIAGNOSTICS + LSP
-- ============================================================================
local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "",
	Info = "",
}

vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

vim.api.nvim_create_autocmd("CursorHold", {
	group = augroup,
	callback = function()
		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "rounded",
			source = "always",
			scope = "cursor",
		})
	end,
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "<leader>gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)

	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "<leader>gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)

	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)

	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)

	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>fd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)

	vim.keymap.set("n", "<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, opts)

	vim.keymap.set("n", "<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)

	vim.keymap.set("n", "<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)

	vim.keymap.set("n", "<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)

	vim.keymap.set("n", "<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })

vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local fixjson = require("efmls-configs.formatters.fixjson")

	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	local cpplint = require("efmls-configs.linters.cpplint")
	local clangfmt = require("efmls-configs.formatters.clang_format")

	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")

	vim.lsp.config("efm", {
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c = { clangfmt, cpplint },
				go = { gofumpt, go_revive },
				cpp = { clangfmt, cpplint },
				css = { prettier_d },
				html = { prettier_d },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				markdown = { prettier_d },
				python = { flake8, black },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				vue = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"gopls",
	"clangd",
	"efm",
})


