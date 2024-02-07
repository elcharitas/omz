# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# disable compfix
export ZSH_DISABLE_COMPFIX=true

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions as nano
export EDITOR="nano"
git config --global core.editor $EDITOR

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

# Open an app(mac) with disabled web security.
# works magic without necessarily needing a CORs extension.
function open-app(){
   open -na ${1:="Brave Browser"} --args --user-data-dir=/tmp/temporary-chrome-profile-dir --disable-web-security
}

# undo last commit. 
function grhs() {
   git reset --soft HEAD~
}

# create a new github profile
function mkgh(){
   gh profile create $1;
   mkdir ~/Workspace/$1;
}

# switch to an existing github profile
function chgh() {
   gh profile switch $1 --local-dir=~/Workspace/$1
}

# $1 - Branch to target defaults to dev
# $2 - PR Title defaults to commit last commit in current branch
function ghpr() {
    gh pr create -d -B ${1:=dev} -t ${2:=$(git log --oneline -1 --pretty=%B)}
}

function git-rest-soft() {
    git reset --soft HEAD~$1
}

# Git commit with custom date and random time
function git-commit-with-date() {
  if [ "$#" -lt 1 ]; then
    echo "Usage: git-commit-with-date <commit message>"
    return 1
  fi

  local input_date=$(date -j -f "%Y-%m-%d" "$1" "+%Y-%m-%dT%H:%M:%S" 2> /dev/null)
  local last_commit_date=$(git log -1 --format=%cd --date=iso-strict)

  if [ "$input_date" != "" ] && [ $(date -j -f "%Y-%m-%dT%H:%M:%S" "$input_date" "+%s") -gt $(date -j -f "%Y-%m-%dT%H:%M:%S" "$last_commit_date" "+%s") ]; then
    last_commit_date="$input_date"
  fi

  if [ -z "$last_commit_date" ]; then
    # If there is no commit, use a random time at or after 7am
    local random_time=$(printf "%02d:%02d:%02d" $((RANDOM % 5 + 7)) $((RANDOM % 60)) $((RANDOM % 60)))
    last_commit_date=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$last_commit_date" "+%Y-%m-%dT%H:%M:%S")
  else
    # If there is a commit, use a random time after that of the last commit
    local random_minutes=$((RANDOM % 60 + 10))  # Random number of minutes between 10 and 60
    last_commit_date=$(date -j -v+${random_minutes}M -f "%Y-%m-%dT%H:%M:%S" "$last_commit_date" "+%Y-%m-%dT%H:%M:%S")
  fi

  GIT_AUTHOR_DATE="$last_commit_date" GIT_COMMITTER_DATE="$last_commit_date" git commit ${@:2}
}

# Git alias for the custom function
alias gcwd="git-commit-with-date"
