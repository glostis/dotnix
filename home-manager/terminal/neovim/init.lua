-- -------------- Vim global options --------------
-- More natural split locations
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true

-- This is redundant with the statusline which already shows mode
vim.o.showmode = false

-- Better color display, somehow?
vim.o.termguicolors = true

-- Highlight line of the cursor
vim.o.cursorline = true

-- Persistent undo
vim.o.undofile = true

-- Line number column
vim.o.number = true
vim.o.relativenumber = true

-- Color the column number 101 differently
vim.o.colorcolumn = "121"

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Keep 5 lines above and below cursor to keep it centered vertically
vim.o.scrolloff = 5

-- Decrease updatetime (default 4000)
vim.o.updatetime = 250

-- Control ex-mode tab-completion — this should feel natural
-- See :h wildmode for more details
vim.o.wildmode = "longest:full,full"
-- Ignore case when tab-completing files and directories in ex-mode
vim.o.wildignorecase = true

-- How to deal with and display tab/space characters
vim.o.list = true
vim.o.listchars = "tab:▷⋅,trail:⋅,nbsp:⋅"

-- When pressing `*` to search for word under cursor, consider that `-` is part of a word.
vim.opt_local.iskeyword:append("-")

-- Set terminal title, from https://www.reddit.com/r/neovim/comments/17uez05/set_powershellwindows_terminal_tab_title/
vim.opt.title = true
vim.opt.titlestring = [[%t – %{fnamemodify(getcwd(), ':t')}]]

-- -------------- Mappings --------------
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Override vim-gh-line default keymap
vim.g.gh_line_map = "<leader>og"
vim.g.gh_line_blame_map_default = 0
-- A gh_repo_map_default variable is missing:
-- https://github.com/ruanyl/vim-gh-line/blob/fbf368bdfad7e5478009a6dc62559e6b2c72d603/plugin/vim-gh-line.vim#L37-L39
vim.g.gh_repo_map = "_"

-- Remove zoomwintab default keymaps
vim.g.zoomwintab_remap = 0
vim.g.zoomwintab_hidetabbar = 0

-- Disable Neovim Python provider which bloats startuptime when in a "heavy" Python virtualenv
-- (taken from `:h python-provider`)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Taken from https://bryankegley.me/posts/nvim-getting-started/
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, { noremap = true, silent = true })
end

-- Close the current buffer and move to the previous one
-- (depends on the moll/vim-bbye plugin)
key_mapper("n", "<leader>x", ":Bdelete<CR>")

-- Zoom/unzoom the current window
key_mapper("n", "<leader>z", ":ZoomWinTabToggle<CR>")

-- Mappings to yank to system clipboard
key_mapper("n", "<leader>y", '"+y')
key_mapper("n", "<leader>yA", 'magg"+yG`a') -- "yank all"
key_mapper("v", "<leader>y", '"+y')
key_mapper("n", "<leader>Y", '"+Y')
key_mapper("v", "<leader>Y", '"+Y')

-- preserve indentation while pasting text from the clipboard
key_mapper("n", "<leader>p", ":set paste<CR>:put  +<CR>:set nopaste<CR>")
key_mapper("n", "<leader>P", ":set paste<CR>:put!  +<CR>:set nopaste<CR>")

-- Toggle and resize yazi and nvim-tree file explorers
-- key_mapper("n", "<leader>f", ":RnvimrToggle<CR>")
key_mapper("n", "<leader>tt", ":NvimTreeToggle<CR>")

-- Telescope mappings
key_mapper("n", "<leader>e", ":Telescope find_files<CR>") -- "edit"
key_mapper("n", "<leader>of", ":Telescope oldfiles<CR>") -- "oldfiles"
key_mapper("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>") -- "search"
key_mapper("n", "<leader>g", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>") -- "grep"
key_mapper("n", "<leader>wg", ":Telescope grep_string<CR>") -- "word grep"
key_mapper("n", "<leader>tr", ":Telescope resume<CR>")
key_mapper("n", "<leader>tb", ":Telescope buffers<CR>")

-- Trouble (diagnostics window) mappings
key_mapper("n", "<leader>dl", "<cmd>TroubleToggle<cr>")
key_mapper("n", "<leader>dw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
-- key_mapper("n", "<leader>dl", "<cmd>TroubleToggle loclist<cr>")
-- key_mapper("n", "<leader>dq", "<cmd>TroubleToggle quickfix<cr>")
key_mapper("n", "gr", "<cmd>TroubleToggle lsp_references<cr>")
vim.keymap.set("n", "<leader>dd", function()
  vim.diagnostic.open_float({ source = true })
end, { noremap = true, silent = true, desc = "Open floating [D]iagnostic message" })

-- smart-splits mappings
vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

-- conform mappings
vim.keymap.set({ "n", "v" }, "<leader>b", function()
  require("conform").format({
    async = true,
    bufnr = bufnr,
  })
end, { buffer = bufnr, desc = "[B]eautify (format) current buffer", noremap = true })

require("colorscheme")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
  group = highlight_group,
  pattern = "*",
})

-- Ignore quickfix list in buffer list (is ignored by [b mappings]
-- Taken from https://github.com/tpope/vim-unimpaired/issues/68#issuecomment-42195349
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Map vim filetypes for esoteric filetypes
vim.filetype.add({
  extension = {
    geojson = "json",
    vrt = "xml",
  },
  pattern = {
    [".*%.nomad%.tpl"] = "hcl",
  },
})

-- Restore cursor position
-- Taken from https://stackoverflow.com/a/72939989/9977650
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Open NvimTree at startup on directory
-- Taken from https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  if directory then
    vim.cmd.cd(data.file)
  end

  -- open the tree
  require("nvim-tree.api").tree.open()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = "close",
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-f>"] = actions.to_fuzzy_refine,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " -g'!tests/' " }),
        },
      },
    },
  },
})

-- Enable telescope fzf native, if installed
require("telescope").load_extension("fzf")

-- Enables to add ripgrep options such as `-g` to the "Live Grep" Telescope finder
require("telescope").load_extension("live_grep_args")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  playground = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    javascript = { "prettier" },
    html = { "prettier" },
    sql = { "sqlfluff" },
    hcl = { "hcl" },
    nix = { "alejandra" },
  },
})

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { noremap = true, silent = true, desc = "Go to previous diagnostic message" }
)
vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { noremap = true, silent = true, desc = "Go to next diagnostic message" }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
  nmap("<leader>s", ":SymbolsOutline<CR>", "Open symbols outline")

  nmap("K", vim.lsp.buf.hover, "Hover documentation")

  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

require("lspconfig").basedpyright.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    basedpyright = {
      analysis = {
        diagnosticSeverityOverrides = {
          reportAny = false,
          reportMissingTypeStubs = false,
          reportUnknownParameterType = false,
          reportUnknownVariableType = false,
          reportUnknownArgumentType = false,
          reportUnknownMemberType = false,
          reportUnusedCallResult = false,
        },
      },
    },
  },
})
require("lspconfig").ruff.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require("lspconfig").bashls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require("lspconfig").dockerls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require("lspconfig").docker_compose_language_service.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})
require("lspconfig").jsonls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.diagnostic.config({
  virtual_text = false,
})

local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  -- Somehow a snippet plugin is mandatory, even if not used?
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete {},   -- Don't know what this does
    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- `select = true`: Accept currently selected item / `select = false`: Only confirm explicitly selected items
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    {
      name = "buffer",
      keyword_length = 3,
      option = {
        -- Complete using all visible buffers, taken from
        -- https://github.com/hrsh7th/cmp-buffer#visible-buffers
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        path = "[Path]",
        buffer = "[Buffer]",
      })[entry.source.name]
      return vim_item
    end,
  },
})

require("gitsigns").setup()

require("Comment").setup()

require("auto-save").setup()

require("nvim-tree").setup({
  sync_root_with_cwd = true,
  filters = {
    custom = { "^.git$" },
  },
})

require("colorizer").setup()

require("flash").setup({
  -- Deactivate the label for the first match (you can jump to it with `<CR>`)
  label = {
    current = false,
  },
  search = {
    -- Entering a label is triggered only when typing `:` first, to prevent jumping to random labels
    -- when searching for a word that doesn't exist.
    -- trigger = ":",
  },
  modes = {
    -- clever-f is better in my opinion than flash for smart f, F, t, T
    char = {
      enabled = false,
    },
  },
})
vim.api.nvim_set_hl(0, "FlashLabel", { link = "IncSearch", bold = true })
vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { noremap = true, silent = true, desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { noremap = true, silent = true, desc = "Flash remote" })

require("symbols-outline").setup({ autofold_depth = 1 })

require("lualine").setup({
  sections = {
    -- Show only first line of mode in status line
    lualine_a = {
      {
        "mode",
        fmt = function(str)
          return str:sub(1, 1)
        end,
      },
    },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  options = {
    disabled_filetypes = {
      statusline = { "NvimTree" },
    },
  },
})

require("bufferline").setup({
  options = {
    offsets = {
      { filetype = "NvimTree" },
    },
  },
})

-- This is indent-blankline
require("ibl").setup()

require("which-key").setup()

require("trouble").setup({ mode = "document_diagnostics" })

require("nvim-navbuddy").setup({ lsp = { auto_attach = true } })
