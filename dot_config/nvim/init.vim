" Inspired by https://github.com/fisadev/fisa-vim-config/blob/master/config.vim

" To use fancy symbols wherever possible, change this setting from 0 to 1
" and use a font from https://github.com/ryanoasis/nerd-fonts in your terminal
let fancy_symbols_enabled = 1

let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.config/nvim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.config/nvim/autoload
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" ============================ Plugin declaration ==============================
call plug#begin()

" ----------------------------------- Git --------------------------------------
" Display per-line git status in the gutter
Plug 'airblade/vim-gitgutter'

" :Gdiff, :Gblame, etc.
Plug 'tpope/vim-fugitive'

" ---------------------------------- Python ------------------------------------
" Sort python imports
Plug 'stsewd/isort.nvim'

" Black, the uncompromising formatter
" See https://github.com/psf/black/issues/1293#issuecomment-596123193
Plug 'ambv/black', { 'tag': '20.8b1' }

" Smart python code navigation
" <Leader>d (definition)
" <Leader>n (occurrences)
" K (definition)
Plug 'davidhalter/jedi-vim'

" Select in/around class/function/docstring in python
" with {i,a}{c,f,d}
Plug 'jeetsukumaran/vim-pythonsense'

" Select current indentation level as an `i` object
" example: `ai` or `ii`
Plug 'michaeljsmith/vim-indent-object'

" Cycle through if..else try..except with %
Plug 'okcompute/vim-python-match'

" Run tests from within vim
Plug 'janko/vim-test'

" ------------------------- Auto-completion/linting ----------------------------
" Asynchronous autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'deoplete-plugins/deoplete-jedi'

" Completion from other opened files
Plug 'Shougo/context_filetype.vim'

" Shows the function signature in a floating window while typing
Plug 'Shougo/echodoc.vim'

" Asynchronous syntax checker
Plug 'w0rp/ale'

" Code and files fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Automatically generate tags for the current repository
Plug 'ludovicchabant/vim-gutentags'

" ------------------------------------ UI --------------------------------------
Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'

" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Nice icons in the file explorer and file type status line.
Plug 'ryanoasis/vim-devicons'

" ------------------------------ Miscellaneous ---------------------------------
" Does what it says
Plug 'tarekbecker/vim-yaml-formatter'

" Toggle comments on lines with `gc{motion}`
Plug 'tomtom/tcomment_vim'

Plug 'tpope/vim-repeat'

" cs'" for example
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

" Auto-write file on change
Plug 'vim-scripts/vim-auto-save'

" Class/module browser
Plug 'majutsushi/tagbar'

" Highlights the yanked region
Plug 'machakann/vim-highlightedyank'

" Close a buffer without closing the window, using :BDelete
Plug 'moll/vim-bbye'
"
" " Go-to with s{char}{char}
" Plug 'justinmk/vim-sneak'
"
" " Highlight a unique character per word to ease f/F/t/T
" Plug 'unblevable/quick-scope'

" tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'benmills/vimux'
Plug 'julienr/vimux-pyutils'

" Highlight HEX/RGB colors in a buffer using :ColorHighlight
Plug 'chrisbra/Colorizer'

" TOML syntax highlighting
Plug 'cespare/vim-toml'
call plug#end()
" ==============================================================================

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif

" ================================= Mappings ===================================
" Map ; to : to avoid pressing shift to enter command mode
" http://vim.wikia.com/wiki/Map_semicolon_to_colon
map ; :
" Keep functionality of native ; by using ;;
noremap ;; ;

let mapleader=","

" Close the current buffer and move to the previous one
noremap <leader>x :Bdelete<CR>

" Use :Gopen to open the current repository in the browser
command! Gopen silent exec "!git open"

" Disable the ever-annoying Ex mode shortcut key. Instead, make Q repeat
" the last macro. *hat tip* http://vimbits.com/bits/263
nnoremap Q @@

" Make Y consistent with C and D
nnoremap Y y$

" copy/pasting sanity
noremap <leader>y "+y
noremap <leader>yy "+yy
noremap <leader>Y "+Y

" preserve indentation while pasting text from the OS X clipboard
noremap <leader>p :set paste<CR>:put  +<CR>:set nopaste<CR>

" Type double escape to remove search highlighting until next search
nnoremap <silent> <esc><esc> :noh<return>

" ==============================================================================


" =========================== Plugin configuration =============================

" --------------------------------- Deoplete -----------------------------------
let g:deoplete#enable_at_startup = 1

" complete with words from any opened file
let g:context_filetype#same_filetypes = {}
let g:context_filetype#same_filetypes._ = '_'

" autocompletion of files and commands behaves like shell
" (complete only the common part, list the options that match)
set wildmode=list:longest

let g:deoplete#sources#jedi#show_docstring = 1

" <TAB>: completion.
" Taken from
" https://github.com/Shougo/deoplete.nvim/issues/816#issuecomment-409119497
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : ""

let g:echodoc_enable_at_startup = 1
let g:echodoc#type = 'floating'

" Disable jedi-vim's completion because we already use deoplete for that
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_stubs_command =""
let g:jedi#rename_command = ""
let g:jedi#usages_command = '<Leader>o'

" --------------------------------- Airline ------------------------------------
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline_skip_empty_sections = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let airline#extensions#ale#show_line_numbers = 0

" Simplify the number area to just be line number, col number
let g:airline_section_z = "%2l:%2c"

let g:airline_mode_map = {
      \ '__'     : '-',
      \ 'c'      : 'C',
      \ 'i'      : 'I',
      \ 'ic'     : 'I',
      \ 'ix'     : 'I',
      \ 'n'      : 'N',
      \ 'multi'  : 'M',
      \ 'ni'     : 'N',
      \ 'no'     : 'N',
      \ 'R'      : 'R',
      \ 'Rv'     : 'R',
      \ 's'      : 'S',
      \ 'S'      : 'S',
      \ ''     : 'S',
      \ 't'      : 'T',
      \ 'v'      : 'V',
      \ 'V'      : 'V',
      \ ''     : 'V',
  \ }

if fancy_symbols_enabled
    let g:webdevicons_enable = 1

    " custom airline symbols
    if !exists('g:airline_symbols')
       let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''
    let g:airline_symbols.branch = '⭠'
    let g:airline_symbols.readonly = '⭤'
    let g:airline_symbols.linenr = '⭡'
    let g:airline_symbols.maxlinenr = ''
else
    let g:webdevicons_enable = 0
endif

" ----------------------------------- Ale --------------------------------------
let g:ale_echo_msg_format = '(%linter%) [%code%] %s'
let g:ale_linters = {'python': ['pycodestyle', 'flake8', 'pylint'], 'tex': []}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'json': ['fixjson'],
\}

" This calls ale_fixers, depending on filetype
" Mnemonic: beautify
map <Leader>b <Plug>(ale_fix)

" ------------------------------ Highlight yank --------------------------------
let g:highlightedyank_highlight_duration = 300

" --------------------------------- AutoSave -----------------------------------
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_silent = 1  " do not display the auto-save notification

" ---------------------------------- Tagbar ------------------------------------
noremap <Leader>q :TagbarToggle<CR>

" ----------------------------------- fzf --------------------------------------
" file finder mapping
nmap <Leader>e :Files<CR>
" tags (symbols) in current file finder mapping
nmap <Leader>g :BTag<CR>
" the same, but with the word under the cursor pre filled
nmap <Leader>wg :execute ":BTag " . expand('<cword>')<CR>
" tags (symbols) in all files finder mapping
nmap <Leader>G :Tags<CR>
" the same, but with the word under the cursor pre filled
nmap <Leader>wG :execute ":Tags " . expand('<cword>')<CR>
" general code finder in current file mapping
nmap <Leader>f :BLines<CR>
" the same, but with the word under the cursor pre filled
nmap <Leader>wf :execute ":BLines " . expand('<cword>')<CR>
" general code finder in all files mapping
nmap <Leader>F :Lines<CR>
" the same, but with the word under the cursor pre filled
nmap <Leader>wF :execute ":Lines " . expand('<cword>')<CR>
" commands finder mapping
nmap <Leader>c :Commands<CR>

nmap <Leader>r :Rg<CR>
nmap <Leader>wr :execute ":Rg " . expand('<cword>')<CR>

" --------------------------------- vim-test -----------------------------------
let test#python#runner = 'pytest'
let g:test#python#pytest#executable = 'python -m pytest -q --no-cov --disable-warnings'
let test#strategy = "neovim"
nnoremap <Leader>tt :TestNearest<cr>
nnoremap <Leader>tf :TestFile<cr>
nnoremap <Leader>ta :TestSuite<cr>


" -------------------------------- vim-sneak -----------------------------------
let g:sneak#s_next = 1

" ------------------------------ vim-quickscope --------------------------------
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" ---------------------------------- vimux -------------------------------------
" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxRunCommand("ipython")<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>

" ==============================================================================


" ============================== General stuff =================================
" Tell neovim where to find the python binary that has the neovim package
" installed
let g:python3_host_prog = $HOME."/.venv/neovim/bin/python"

" Keep 5 lines above and below cursor to keep it centered vertically
set scrolloff=5

" Highlight line of the cursor
set cursorline

set number relativenumber

" Color the column number 101 differently
set colorcolumn=101

" Enable mouse in all modes
set mouse=a

" How to deal with and display tab/space characters
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" Tabs...
filetype plugin indent on
autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType json setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType sh setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType zsh setlocal tabstop=4 shiftwidth=4 expandtab
autocmd FileType dockerfile setlocal tabstop=4 shiftwidth=4 expandtab

autocmd BufRead,BufNewFile *.geojson setfiletype json
autocmd BufRead,BufNewFile *.vrt setfiletype xml

" Jump to last cursor position when opening a file
" Don't do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'svn\|commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    else
        call cursor(1,1)
    endif
endfunction

" Better color display, somehow?
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

function! LoadColorScheme()
    let alacritty_conf = expand('~/.config/alacritty/alacritty.yml')
    if filereadable(alacritty_conf)
        for line in readfile(alacritty_conf)
            if line =~ "^colors: \*.*$"
                let color_profile = split(line, "*")[1]
            endif
        endfor
    endif
    if !exists("color_profile")
        let color_profile = "gruvbox-dark"
    endif
    let background_profile = split(color_profile, "-")[1]
    let color_profile = split(color_profile, "-")[0]
    execute "set background=" . background_profile
    execute "colorscheme " . color_profile
    redraw
endfunction

call LoadColorScheme()

" More natural split locations
set splitbelow
set splitright

" shortcut to prettify a JSON file
map <Leader>j :%!python -m json.tool<CR>

set ignorecase
set smartcase
set noshowmode

" ==============================================================================
