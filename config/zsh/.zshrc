############################################################
# ZSH OPTIONS
############################################################

setopt autocd
setopt correct
setopt interactivecomments
setopt magicequalsubst
setopt nonomatch
setopt notify
setopt numericglobsort
setopt promptsubst

# Histórico
setopt histignorealldups
setopt sharehistory
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
PROMPT='%{$fg[green]%}%n@%m%{$reset_color%} %{$fg[blue]%}%~%{$reset_color%} $ '

############################################################
# HISTORY CONFIG
############################################################

HISTFILE="$HOME/.zsh_history"
HISTSIZE=2000
SAVEHIST=2000
alias history="history 0"

############################################################
# KEYBINDINGS (EMACS MODE)
############################################################

bindkey -e
bindkey ' ' magic-space
bindkey '^U' backward-kill-line
bindkey '^[[3;5~' kill-word
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[Z' reverse-menu-complete   # Shift + Tab

############################################################
# COMPLETION COLORS
############################################################

autoload -Uz compinit
compinit
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

############################################################
# ALIASES
############################################################

alias ls='ls --color=auto'
alias v='nvim'
alias dev='cd ~/Developments'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

############################################################
# PATH
############################################################

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/opt/nodejs/bin:$PATH"


# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"

############################################################
# STARSHIP PROMPT (OPCIONAL)
############################################################

# eval "$(starship init zsh)"

############################################################
# ZSH PLUGINS
############################################################

# Autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#44475a'
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
