# path
pupdate() { case ":${PATH:=$1}:" in *:"$1":*) ;; *) PATH="$1:$PATH" ;; esac }
export PATH=""
pupdate $HOME/bin
pupdate /usr/local/bin
pupdate /opt/homebrew/bin
pupdate /usr/local/bin
# pupdate /System/Cryptexes/App/usr/bin
pupdate /usr/bin
pupdate /bin
pupdate /usr/sbin
pupdate /sbin
pupdate $HOME/.local/bin
pupdate /nix/var/nix/profiles/default/bin
pupdate /run/current-system/sw/bin

# history
export HISTFILE=~/.zsh_history
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
export HISTSIZE=50000
export SAVEHIST=50000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# setopt globdots
autoload -U compinit
compinit
_comp_options+=(globdots)

ZSH_THEME="af-magic"
plugins=(
  dirhistory
  docker
  docker-compose
  fzf
  fzf-tab
  git
  you-should-use
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)
# zstyle ':omz:plugins:docker' legacy-completion yes
# zstyle ':completion:*:*:docker:*' option-stacking yes sort true
# zstyle ':completion:*:*:docker-*:*' option-stacking yes sort true
zstyle ':completion:*' sort false

# FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source <(kubectl completion zsh)

VIRTUAL_ENV_DISABLE_PROMPT=1

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "^[[1;3B" dirhistory_zle_dirhistory_future
bindkey "^[[1;3A" dirhistory_zle_dirhistory_back
bindkey "ç" fzf-cd-widget
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# fzf
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
  --bind 'shift-up:preview-page-up,shift-down:preview-page-down'
  --height=100%"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
  cd) fzf --preview 'tree -C {} | head -200' "$@" ;;
  export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview 'bat -n --color=always {}' "$@" ;;
  esac
}
