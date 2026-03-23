# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/opt/node@22/bin:$PATH:$HOME/go/bin:/opt/homebrew/opt/mysql-client/bin"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="agnoster"
ZSH_THEME="apple"
DEFAULT_USER="thordy"
prompt_context(){}

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="yyyy-mm-dd"
HISTFILESIZE=10000000
HISTSIZE=10000000

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  colorize
)
autoload -U compinit && compinit

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=244

# Disable the magic paste functions
DISABLE_MAGIC_FUNCTIONS=true

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias zshconfig="vim ~/.zshrc"
alias zshrc='source ~/.zshrc'
alias extip='curl https://icanhazip.com/; curl -4 https://icanhazip.com/'
alias unixtime="date -d @$1 +'%Y-%m-%d %H:%M:%S'"
alias process='ps aux | grep "$@"'

# Set KCAPP_ROOT
export KCAPP_ROOT=$HOME/Development/kcapp

# zsh-autocomplete
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '^ ' autosuggest-accept


##
## Auto expanding aliases
##  https://blog.sebastian-daschner.com/entries/zsh-aliases
##  https://stackoverflow.com/questions/36133855/zsh-alias-with-no-space-at-the-end-of-the-invocation
## 
# blank aliases
typeset -a baliases
baliases=()

balias() {
  alias $@
  args="$@"
  args=${args%%\=*}
  baliases+=(${args##* })
}

# ignored aliases
typeset -a ialiases
ialiases=(ls grep history ccat vpnssh unixtime process hex)

ialias() {
  alias $@
  args="$@"
  args=${args%%\=*}
  ialiases+=(${args##* })
}

# functionality
expand-alias-space() {
  [[ $LBUFFER =~ "\<(${(j:|:)baliases})\$" ]]; insertBlank=$?
  # MacOS: Removed \< from the beginning of regex
  if [[ ! $LBUFFER =~ "(${(j:|:)ialiases})\$" ]]; then
    zle _expand_alias
  fi
  zle self-insert
  if [[ "$insertBlank" = "0" ]]; then
    zle backward-delete-char
  fi
}
zle -N expand-alias-space

bindkey " " expand-alias-space
bindkey -M isearch " " magic-space

alias mcp='mvn clean package'
alias gcm='git checkout master'
alias gcd='git checkout develop'
alias sag='sudo apt-get install '
alias mci='mvn clean install '
alias mcit='mvn clean install -DskipITs'
alias tmuxa='tmux attach-session -t'
alias tmuxl='tmux list-session'
alias gpa='git push ; git push --tags ; git push origin master'

### 
###

function multi {
  cmd=$1
  shift
  while [[ $cmd = "ssh" ]]; do
    pre_check="$(echo $@ | tr ' ' '\n' | sed -e 's/^.*@//g' | \
                 xargs nmap -p 22 -PN -oG - | grep Port | grep -v open)"
    test "${pre_check}x" != "x" && (clear; echo "$pre_check") || break
  done
  tmux send-keys -t 0 "$cmd ${@[1]}"
  for ((pane = 1; pane < ${#@[@]}; pane++)); do
    tmux splitw -h
    tmux send-keys -t $pane "$cmd ${@[pane+1]}"
    tmux select-layout tiled > /dev/null
  done
  tmux set-window-option synchronize-panes on > /dev/null
  tmux set-window-option pane-active-border-style fg=red > /dev/null
  tmux set-window-option pane-border-style fg=yellow > /dev/null
  tmux send-keys Enter
}

# Find the proper DNS name:
# Usage: lip <ip>
function lip() {
  dig +short @10.0.0.3 -x $1
}
