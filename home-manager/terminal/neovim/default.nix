{
  config,
  pkgs,
  ...
}: {
  editorconfig = {
    enable = true;
    settings = {
      # Force tab style for python files, because in some cases vim-sleuth's auto-detection goes crazy
      # (for example in python files that contain lots of multiline strings)
      "*.py" = {
        indent_style = "space";
        indent_size = 4;
      };
    };
  };

  xdg.configFile."nvim/lua/colorscheme.lua".text = ''
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

      set bg=${config.colorScheme.variant}

      colorscheme gruvbox-material
    ]])
  '';

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaConfig = builtins.readFile ./init.lua;
    plugins = with pkgs.vimPlugins; [
      # ~~~~~~~~ Git related plugins ~~~~~~~~
      # :Gdiff, :Gblame, etc.
      vim-fugitive
      # <leader>gh to open current line in Github
      vim-gh-line
      # Adds git related signs to the gutter, as well as utilities for managing changes
      gitsigns-nvim

      # ~~~~~~~~ Navigation / editing plugins ~~~~~~~~
      # Paired mappings such as [<space> ]<space>, [b ]b, etc.
      vim-unimpaired
      # cs'" or yi" for example
      vim-surround
      # Add dot-repeat to plugin actions
      vim-repeat
      # Work with several variants of a word at once: `:S/word/substitution`
      vim-abolish
      # Auto-detect file indentation / tabstop, etc.
      vim-sleuth
      # "gc" to comment visual regions/lines
      comment-nvim
      # Auto-save a buffer when it is changed
      auto-save-nvim
      # Close a buffer without closing the window, using :Bdelete
      vim-bbye
      # Deactivate search highlighting when search finished
      vim-cool
      # Navigate your code with search labels, enhanced character motions and Treesitter integration
      flash-nvim
      # Extended f, F, t and T key mappings for Vim.
      clever-f-vim
      # Smart, seamless, directional navigation and resizing of Neovim splits
      smart-splits-nvim

      # ~~~~~~~~ UI ~~~~~~~~
      # Colorscheme
      gruvbox-material
      # Use yazi as file explorer
      yazi-nvim
      # Dependency of nvim-tree-lua, bufferline-nvim and trouble-nvim
      nvim-web-devicons
      # File tree explorer
      nvim-tree-lua
      # Highlight HEX/RGB colors in a buffer
      nvim-colorizer-lua
      # Symbols outline using LSP
      symbols-outline-nvim
      # kmonad config file syntax highlighting
      kmonad-vim
      # Set lualine as statusline
      lualine-nvim
      # "tabline" showing open buffers
      bufferline-nvim
      # zoom/unzoom the current window
      zoomwintab-vim
      # Add indentation guides even on blank lines
      indent-blankline-nvim
      # Useful plugin to show you pending keybinds.
      which-key-nvim
      # Markdown previewer in the browser
      markdown-preview-nvim

      # ~~~~~~~~ LSP ~~~~~~~~
      nvim-lspconfig
      # Dependencies of nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      cmp-buffer
      cmp-path

      # "Fake" LSP server to run stuff like linters and formatters - `none-ls` is the maintained fork of `null-ls`
      none-ls-nvim
      # Dependency of null-ls-nvim and telescope-nvim
      plenary-nvim

      # Show code diagnostics
      trouble-nvim

      # Fuzzy finder (files, LSP, etc.)
      telescope-nvim
      telescope-live-grep-args-nvim
      # Fuzzy Finder Algorithm which requires local dependencies to be built.
      # Only load if `make` is available. Make sure you have the system
      # requirements installed.
      telescope-fzf-native-nvim

      # Highlight, edit, and navigate code
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context
      playground

      nvim-navbuddy
      nvim-navic # Dep of navbuddy
      nui-nvim # Dep of navbuddy
    ];
    extraPackages = with pkgs; [
      basedpyright
      bash-language-server
      ruff
      black
      stylua
      alejandra
      nodePackages.prettier
      sqlfluff
      hclfmt
      docker-compose-language-service
      dockerfile-language-server-nodejs
      # Provides `jsonls`
      vscode-langservers-extracted
    ];
  };
}
