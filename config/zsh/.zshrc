############################################################
# ZSH OPTIONS
############################################################

setopt autocd
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

############################################################
# HISTORY CONFIG
############################################################

HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000
SAVEHIST=5000

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
bindkey '^[[Z' reverse-menu-complete

############################################################
# PATH
############################################################

export PATH="$HOME/.local/bin:$PATH"
path=($HOME/.local/share/gem/ruby/*/bin(N/) $path)

# Android SDK (Arch/Linux)
#export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
#export ANDROID_HOME="$ANDROID_SDK_ROOT"
#export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin"

############################################################
# COMPLETION
############################################################

autoload -Uz compinit
compinit -C

# Cores do ls e do completion na paleta kz (truecolor, sem fundo).
() {
  local dir='1;38;2;159;190;160'
  local link='38;2;159;185;180'
  local broken='38;2;216;154;154'
  local exec='1;38;2;210;189;140'
  local archive='38;2;180;165;184'
  local media='38;2;159;173;184'
  local special='38;2;133;133;139'
  local -a c=(
    "di=$dir" "ow=$dir" "tw=$dir" "st=$dir"
    "ln=$link" "or=$broken" "mi=$broken"
    "ex=$exec" "su=$exec" "sg=$exec"
    "pi=$special" "so=$special" "bd=$special" "cd=$special" "do=$special"
  )
  local ext
  for ext in tar tgz gz xz zst bz2 zip 7z rar iso deb rpm; do c+=("*.$ext=$archive"); done
  for ext in png jpg jpeg gif webp svg bmp mp4 mkv webm mov avi mp3 flac ogg wav; do c+=("*.$ext=$media"); done
  export LS_COLORS="${(j.:.)c}"
}
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

############################################################
# ALIASES
############################################################

alias ls='ls --color=auto --group-directories-first'
alias ll='ls -la'
alias grep='grep --color=auto'
alias v='nvim'
alias dev='cd ~/Developments'
alias gitp='cd ~/Developments/Git/'
alias ..='cd ..'
alias ...='cd ../..'
############################################################
# PROMPT
############################################################

# Compact fallback prompt when Starship is unavailable.
PROMPT='%F{cyan}%n@%m%f %F{yellow}%1~%f %(?.%F{green}.%F{red})❯%f '

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

############################################################
# PYENV (LAZY LOAD)
############################################################

export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
  unset -f pyenv
  eval "$(command pyenv init - zsh)"
  pyenv "$@"
}

############################################################
# NVM (LAZY LOAD)
############################################################

export NVM_DIR="$HOME/.nvm"

load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

nvm() {
  unset -f nvm node npm npx codex
  load_nvm
  nvm "$@"
}

node() {
  unset -f nvm node npm npx codex
  load_nvm
  node "$@"
}

npm() {
  unset -f nvm node npm npx codex
  load_nvm
  npm "$@"
}

npx() {
  unset -f nvm node npm npx codex
  load_nvm
  npx "$@"
}

codex() {
  unset -f nvm node npm npx codex
  load_nvm
  codex "$@"
}

############################################################
# KEYBOARD-FIRST CLI
############################################################

export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='find . -type d -not -path "*/.git/*"'
export FZF_DEFAULT_OPTS='--height=45% --layout=reverse --border=rounded --info=inline --prompt="› " --pointer="▸" --marker="✓" --color=bg+:#18181b,bg:#080808,spinner:#a1a1aa,hl:#c5c5ca,fg:#d7d7da,header:#85858b,info:#85858b,pointer:#c5c5ca,marker:#9fbea0,fg+:#f5f5f7,prompt:#c5c5ca,hl+:#f5f5f7'
export FZF_CTRL_T_OPTS='--preview "cat {}"'

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

# Select a directory with fzf and enter it.
fcd() {
  local dir
  dir="$(find "${1:-$HOME}" -type d -not -path '*/.git/*' | fzf --preview 'ls -la {}')" || return
  [[ -n "$dir" ]] && builtin cd -- "$dir"
}

# Select a file with a preview and open it in Neovim.
fedit() {
  local file
  file="$(find "${1:-.}" -type f -not -path '*/.git/*' | fzf --preview 'cat {}')" || return
  [[ -n "$file" ]] && nvim -- "$file"
}

# Notify when a long command, Claude/Codex session, or relevant failure ends.
zmodload zsh/datetime
autoload -Uz add-zsh-hook

_command_notify_preexec() {
  _command_notify_started=$EPOCHREALTIME
  _command_notify_text=$1
}

_command_notify_precmd() {
  local exit_status=$?
  [[ -n "${_command_notify_started:-}" ]] || return

  local elapsed=$(( EPOCHREALTIME - _command_notify_started ))
  local elapsed_int=${elapsed%.*}
  local title message urgency

  local command_name=${_command_notify_text%% *}
  if [[ "$command_name" == codex || "$command_name" == claude ]]; then
    title="Assistant finished"
    message="${command_name} finished in ${elapsed_int}s (status ${exit_status})"
    urgency=normal
  elif (( exit_status != 0 && elapsed >= 2 )); then
    title="Command failed"
    message="${_command_notify_text[1,80]} (status ${exit_status})"
    urgency=critical
  elif (( elapsed >= 15 )); then
    title="Command completed"
    message="${_command_notify_text[1,80]} finished in ${elapsed_int}s"
    urgency=normal
  else
    unset _command_notify_started _command_notify_text
    return
  fi

  notify-send -a Terminal -u "$urgency" "$title" "$message"
  unset _command_notify_started _command_notify_text
}

add-zsh-hook preexec _command_notify_preexec
add-zsh-hook precmd _command_notify_precmd

############################################################
# ZSH PLUGINS
############################################################

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#44475a'
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

############################################################
# ANGULAR COMPLETION
############################################################

# Do not load this at startup; use it only when needed:
# source <(ng completion script)
