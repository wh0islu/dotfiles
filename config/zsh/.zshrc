setopt autocd correct interactivecomments magicequalsubst \
       nonomatch notify numericglobsort promptsubst \
       histignorealldups sharehistory \
       hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
alias history="history 0"

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
bindkey '^[[Z' undo

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#44475a'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
eval "$(dircolors -b ~/.dircolors)"
alias ls='ls --color=auto'
alias v="nvim"
alias dev="cd $HOME/Developments/ ; ls"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
export PATH="$HOME/.local/opt/nodejs/bin:$PATH"

eval "$(starship init zsh)"

