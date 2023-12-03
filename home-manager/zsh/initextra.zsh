### START OF MY CUSTOM zshrc ###

stty stop undef  # Disable ctrl-s to freeze terminal.

# Highlight selected completion in the list
zstyle ':completion:*' menu select

# Source: https://superuser.com/a/815317
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list "" \
'm:{a-z\-}={A-Z\_}' \
'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
'r:|?=** m:{a-z\-}={A-Z\_}'
zmodload zsh/complist

# Sometimes there's some completion functions in there
fpath+="$HOME/.zfunc"

_comp_options+=(globdots)  # Include hidden files.

# Taken from https://wiki.archlinux.org/index.php/zsh
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="''${terminfo[khome]}"
key[End]="''${terminfo[kend]}"
key[Delete]="''${terminfo[kdch1]}"
key[Up]="''${terminfo[kcuu1]}"
key[Down]="''${terminfo[kcud1]}"
key[PageUp]="''${terminfo[kpp]}"
key[PageDown]="''${terminfo[knp]}"
key[Shift-Tab]="''${terminfo[kcbt]}"

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# setup key accordingly
[[ -n "''${key[Home]}"      ]] && bindkey -- "''${key[Home]}"      beginning-of-line
[[ -n "''${key[End]}"       ]] && bindkey -- "''${key[End]}"       end-of-line
[[ -n "''${key[Delete]}" ]] && bindkey -- "''${key[Delete]}"       delete-char
[[ -n "''${key[PageUp]}"    ]] && bindkey -- "''${key[PageUp]}"    beginning-of-history
[[ -n "''${key[PageDown]}"  ]] && bindkey -- "''${key[PageDown]}"  end-of-history
[[ -n "''${key[Shift-Tab]}" ]] && bindkey -- "''${key[Shift-Tab]}" reverse-menu-complete
[[ -n "''${key[Up]}"   ]] && bindkey -- "''${key[Up]}"             up-line-or-beginning-search
[[ -n "''${key[Down]}" ]] && bindkey -- "''${key[Down]}"           down-line-or-beginning-search
# Control-left/right = move cursor word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
# Control-backspace = delete word
# From https://stackoverflow.com/a/21252464/9977650
bindkey '^H' backward-kill-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from ''$terminfo valid.
if (( ''${+terminfo[smkx]} && ''${+terminfo[rmkx]} )); then
      autoload -Uz add-zle-hook-widget
      function zle_application_mode_start { echoti smkx }
      function zle_application_mode_stop { echoti rmkx }
      add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
      add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

### END OF MY CUSTOM zshrc ###
