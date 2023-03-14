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

-- -------------- Mappings --------------
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Taken from https://bryankegley.me/posts/nvim-getting-started/
local key_mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, { noremap = true, silent = true })
end

-- Close the current buffer and move to the previous one
-- (depends on the moll/vim-bbye plugin)
key_mapper("", "<leader>x", ":Bdelete<CR>")

-- Mappings to yank to system clipboard
key_mapper("n", "<leader>y", '"+y')
key_mapper("v", "<leader>y", '"+y')
key_mapper("n", "<leader>Y", '"+Y')
key_mapper("v", "<leader>Y", '"+Y')

-- preserve indentation while pasting text from the clipboard
key_mapper("n", "<leader>p", ":set paste<CR>:put  +<CR>:set nopaste<CR>")
key_mapper("n", "<leader>P", ":set paste<CR>:put!  +<CR>:set nopaste<CR>")

-- Toggle and resize ranger and nvim-tree file explorers
key_mapper("n", "<leader>r", ":RnvimrToggle<CR>")
key_mapper("t", "<M-i>", "<C-\\><C-n>:RnvimrResize<CR>")
key_mapper("n", "<leader>t", ":NvimTreeToggle<CR>")

-- Telescope mappings
key_mapper("n", "<leader>ff", ":Telescope find_files<CR>") -- "find files"
key_mapper("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>") -- "search"
key_mapper("n", "<leader>gg", ":Telescope live_grep<CR>") -- "grep"
key_mapper("n", "<leader>gw", ":Telescope grep_string<CR>") -- "grep word"

-- -------------- Packages/plugins declaration and customization --------------
-- Bootstrap installation of the lazy.nvim package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- ~~~~~~~~ Git related plugins ~~~~~~~~
  -- :Gdiff, :Gblame, etc.
  "tpope/vim-fugitive",
  -- <leader>gh to open current line in Github
  "ruanyl/vim-gh-line",
  -- Adds git related signs to the gutter, as well as utilities for managing changes
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- ~~~~~~~~ Navigation / editing plugins ~~~~~~~~
  -- Paired mappings such as [<space> ]<space>, [b ]b, etc.
  "tpope/vim-unimpaired",
  -- cs'" or yi" for example
  "tpope/vim-surround",
  -- Add dot-repeat to plugin actions
  "tpope/vim-repeat",
  -- Auto-detect file indentation / tabstop, etc.
  "tpope/vim-sleuth",

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim", opts = {} },

  -- Auto-save a buffer when it is changed
  {
    "Pocco81/auto-save.nvim",
    opts = {
      -- Disable message showing that buffer was saved
      execution_message = { message = "" },
    },
  },

  -- Seamless navigation between vim splits and tmux panes
  "christoomey/vim-tmux-navigator",

  -- Close a buffer without closing the window, using :Bdelete
  "moll/vim-bbye",

  -- Deactivate search highlighting when search finished
  "romainl/vim-cool",

  -- ~~~~~~~~ UI ~~~~~~~~
  -- Colorscheme
  "sainnhe/gruvbox-material",

  -- Use ranger as file explorer
  "kevinhwang91/rnvimr",

  -- File tree explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sync_root_with_cwd = true,
      filters = {
        custom = { "^.git$" },
      },
    },
  },

  -- Highlight HEX/RGB colors in a buffer
  { "NvChad/nvim-colorizer.lua", opts = {} },

  -- kmonad config file syntax highlighting
  "kmonad/kmonad-vim",

  { -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    opts = {
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
    },
  },

  -- "tabline" showing open buffers
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        offsets = {
          { filetype = "NvimTree" },
        },
      },
    },
  },

  { -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = "┊",
      show_trailing_blankline_indent = false,
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  -- Markdown previewer in the browser
  {
    "iamcco/markdown-preview.nvim",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- TODO: python testing, tmux interaction

  -- ~~~~~~~~ LSP ~~~~~~~~
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },

      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
    },
  },

  -- "Fake" LSP server to run stuff like linters and formatters
  { "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Fuzzy Finder (files, lsp, etc)
  { "nvim-telescope/telescope.nvim", version = "*", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = "make",
    cond = function()
      return vim.fn.executable("make") == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
    },
    config = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  },
}, {})

-- Colorscheme configuration
vim.cmd([[
  " Override the IncSearch and Search highlight groups
  function! s:gruvbox_material_custom() abort
    let l:palette = gruvbox_material#get_palette('medium', 'original', {})
    call gruvbox_material#highlight('IncSearch', l:palette.bg0, l:palette.orange)
    call gruvbox_material#highlight('Search', l:palette.bg0, l:palette.yellow)
  endfunction

  augroup GruvboxMaterialCustom
    autocmd!
    autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
  augroup END

  let g:gruvbox_material_foreground = 'original'

  colorscheme gruvbox-material
]])

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
})

-- Restore cursor position
-- Taken from https://stackoverflow.com/a/72939989/9977650
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- Open NvimTree at startup on directory or [No Name] buffer
-- Taken from https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  -- buffer is a [No Name]
  local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  if not (directory or no_name) then
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
      },
    },
  },
})

-- Enable telescope fzf native, if installed
require("telescope").load_extension("fzf")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "bash",
    "css",
    "diff",
    "dockerfile",
    "gitcommit",
    "gitignore",
    "help",
    "html",
    "ini",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "rst",
    "sxhkdrc",
    "toml",
    "vim",
    "yaml",
  },

  -- Autoinstall languages that are not installed.
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  playground = {
    enable = true,
  },
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

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.json_tool,
    null_ls.builtins.formatting.stylua,
  },
  on_attach = function(client, bufnr)
    vim.keymap.set("n", "<leader>b", function()
      vim.lsp.buf.format({
        async = true,
        bufnr = bufnr,
        -- Make sure that only null-ls does the formatting
        filter = function(client)
          return client.name == "null-ls"
        end,
      })
    end, { buffer = bufnr, desc = "[B]eautify (format) current buffer", noremap = true })
  end,
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
vim.keymap.set("n", "<leader>e", function()
  vim.diagnostic.open_float({ source = true })
end, { noremap = true, silent = true, desc = "Open floating diagnostic message" })
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { noremap = true, silent = true, desc = "Open diagnostics list" }
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
  nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  nmap("K", vim.lsp.buf.hover, "Hover documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature documentation")

  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

local servers = {
  pyright = {},
  ruff_lsp = {},
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above and linters/formatter are installed
local mason_installer = require("mason-tool-installer")
mason_installer.setup({
  ensure_installed = {
    "black",
    "isort",
    "pyright",
    "ruff-lsp",
    "stylua",
  },
})

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
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
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
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
    { name = "buffer", keyword_length = 3 },
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
