# Basics
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"

autoload -Uz colors
colors
autoload -Uz compinit
compinit

# Package Manager Paths
# export CACHE_BASE=
# export CARGO_HOME="$CACHE_BASE/.cargo"
# export CARGO_TARGET_DIR="$CACHE_BASE/cargo-target"
# export DOCKER_TMPDIR="$CACHE_BASE/docker/tmp"
# export DOCKER_CONFIG="$CACHE_BASE/.docker"
# export MISE_CACHE_DIR="$CACHE_BASE/mise"
# export NPM_CONFIG_STORE_DIR="$CACHE_BASE/.pnpm-store"
# export RUSTUP_HOME="$CACHE_BASE/.rustup"
# export SCCACHE_DIR="$CACHE_BASE/sccache"
# export UV_CACHE_PATH="$CACHE_BASE/uv"

# export PATH="$CARGO_HOME/bin:$PATH"

# Key Bindings
bindkey -v
bindkey "^[[3~" delete-char
stty erase "^?"

# History
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history hist_ignore_all_dups hist_reduce_blanks

# Other Options
setopt auto_cd
setopt correct
setopt print_eight_bit
setopt no_flow_control ignore_eof
setopt no_beep
setopt extended_glob

# Prompt 
PROMPT="%(4/|%-1//…/%1/|%3/)%# "
RPROMPT="[%n@%m]"

# Completion 
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..

# History Search
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# VCS Info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg

# tmux
_tmux_new_session_name() {
  local base_name=$1
  local timestamp
  local session_name

  while true; do
    timestamp=$(date '+%Y%m%d%H%M%S')
    session_name="${base_name}-${timestamp}"

    if ! tmux has-session -t "$session_name" 2>/dev/null; then
      printf '%s\n' "$session_name"
      return
    fi

    sleep 1
  done
}
_tmux_split_rows () {
  local pane_id=$1
  local rows=$2
  local remaining=$rows
  local split_percent

  while (( remaining > 1 ))
  do
    split_percent=$(( (remaining - 1) * 100 / remaining ))
    pane_id=$(tmux split-window -d -v -p "$split_percent" -P -F '#{pane_id}' -t "$pane_id")
    ((remaining--))
  done
}
_tmux_attach_grid () {
  local base_name=$1
  local columns=$2
  local rows=$3
  local session_name
  local pane_id
  local -a pane_ids
  local remaining=$columns
  local split_percent
  session_name=$(_tmux_new_session_name "$base_name")
  pane_id=$(tmux new-session -d -P -F '#{pane_id}' -s "$session_name")
  pane_ids=("$pane_id")
  while (( remaining > 1 ))
  do
    split_percent=$(( (remaining - 1) * 100 / remaining ))
    pane_id=$(tmux split-window -d -h -p "$split_percent" -P -F '#{pane_id}' -t "$pane_id")
    pane_ids+=("$pane_id")
    ((remaining--))
  done
  for pane_id in "${pane_ids[@]}"
  do
    _tmux_split_rows "$pane_id" "$rows"
  done
  tmux select-pane -t "${pane_ids[1]}"
  tmux attach-session -t "$session_name"
}
tmux6() {
  _tmux_attach_grid tmux6 2 3
}
tmux8() {
  _tmux_attach_grid tmux8 2 4
}
tmux12 () {
  _tmux_attach_grid tmux12 3 4
}

# Aliases

## System
alias reboot='sudo reboot'

alias clean='sudo rm -rf "/tmp/*" && rm -rf "$HOME/.cache/*"'

alias apt='sudo apt' aptug='sudo apt update && sudo apt upgrade -y && sudo apt autoclean && sudo apt autoremove -y --purge'

## Docker
alias dckr-stop='sudo docker kill $(sudo docker ps -q) && sudo docker rm $(sudo docker ps -a -q)'

## Git
alias gst='git status' gl='git log' gb='git branch' gc='git checkout' gcb='git checkout -b' gplo='git pull origin' gmg='git merge' gad='git add' gcm='git commit -m' gsts='git stash' gstsp='git stash pop' gpso='git push origin'

## tmux
alias tmux-kill='tmux kill-server'

## AI Tools
alias cdx='codex --yolo' cld='claude --dangerously-skip-permissions' gmn='gemini --yolo'
alias cdxug='npm i -g @openai/codex@latest' gmnug='npm i -g @google/gemini-cli@latest'
alias cdxcdx='codex --model=gpt-5.3-codex --yolo' cdxmin='codex --model=gpt-5.4-mini --yolo'

## Utilities
alias pbcopy='xsel --clipboard --input' pbpaste='xsel --clipboard --output'
