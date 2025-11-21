# Set up the prompt
autoload -Uz promptinit
promptinit
prompt redhat


# fancy custom prompt stuff
autoload -Uz vcs_info

# expand prompt
setopt PROMPT_SUBST

# path shrinkification
[[ -f ~/.zsh/shrink-path.plugin.zsh ]] && source ~/.zsh/shrink-path.plugin.zsh

# allow option stacking for docker
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

export IS_DEV_CONTAINER=${IS_DEVCONTAINER:-false}

function command_exists() {
    if command -v $1 &> /dev/null; then
        return 0
    else
        return 1
    fi
}

if ! command_exists "iswork"; then
    iswork() {
        return 1
    }
fi

function leftprompt() {
    local builder=""

    if [[ $IS_DEV_CONTAINER = "true" ]]; then
        builder+="%F{blue}d%f "
    fi

    if [[ ! $USER =~ "sam" ]]; then
        builder+="$USER "
    fi

    local git_root
    git_root=$(git rev-parse --show-toplevel 2> /dev/null)
    local git_status=$?

    local mypath
    local orig_path=$(shrink_path -l -t "$PWD")

    builder+="$orig_path "

    local branch=$(git branch 2> /dev/null | grep '*' | cut -c 3-)
    local git_dirty=$(git status --short 2> /dev/null)

    if [[ ! -z $branch ]]; then
        if [[ "$branch" == *"rebasing"* ]]; then
            branch=$(echo $branch | cut -c 13- | rev | cut -c 2- | rev)
        elif [[ "$branch" == *"detached"* ]]; then
            branch="%F{red}detached%f@$(echo $branch | cut -c 19- | rev | cut -c 2- | rev)"
        fi
        builder+="%B($branch)%b "
    fi

    if [[ ! -z $git_dirty ]]; then
        builder+="%F{red}x%f "
    fi

    local context=""

    # attempt to figure out kube namespace if in an infrastructure/{env} directory
    if iswork && [ ! -z $ROOT_DIR ]; then

        local raw_context=$(kubectl config view --minify 2>&1 | grep namespace | cut -c 16-)

        # print kube context if not me or if in stage/prod
        if [[ $raw_context == "default" ]]; then
            local cluster=$(kubectl config view --minify 2>&1 | grep name | head -n 1)
            if [[ $cluster == *"stage"* ]]; then
                # we're in stage(!)
                context="%F{red}!%f "
            elif [[ $cluster =~ "production" ]]; then
                # we're in prod(!!)
                context="%F{red}!!%f "
            else
                context="%F{magenta}! default%f "
            fi
        elif [[ $raw_context == $USER ]]; then
            # my context, do nothing
            true
        elif [[ ! -z $raw_context ]]; then
            context="%F{magenta}! ${raw_context}%f "
        fi
    fi

    builder+="$context"

    # echo -n '\e[6 q' # cursor bar
    echo "${builder}$ "
}

function rightprompt() {
    local exit_code=$?

    if [ $exit_code -ne 0 ]; then
        echo "$mode %F{red}%B$exit_code%b%f"
    fi
}

PROMPT='$(leftprompt)'
#RPROMPT='$(rightprompt)'

setopt histignorealldups sharehistory

# autoload my functions
fpath=( ~/.zsh/completion "${fpath[@]}" )

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

# NB: zpath must be updated BEFORE loading compinit
if [[ -d "/opt/homebrew" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    fpath=( /opt/homebrew/share/zsh/site-functions "${fpath[@]}" )
fi

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
command_exists dircolors && eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# path extensions
PATH=$HOME/.local/bin:$PATH
PATH=$PATH:$HOME/.yarn/bin

# direnv support
_direnv_hook() {
  command_exists direnv && eval "$(direnv export zsh)";
}

typeset -ag precmd_functions;
if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]; then
  precmd_functions+=_direnv_hook;
fi

export KUBE_EDITOR=$(which nvim)
export BAT_THEME="Solarized (light)"

# git aliases
alias gst="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gdiff="git diff"
alias gl="git pull"
alias glog="git log"
alias gre="git rebase"
alias gri="git rebase -i"
alias gsno="git show --name-only"
alias stash="git stash push"
alias unstash="git stash pop"

# other aliases
alias v="vim"
alias vi="vim"
alias vim="nvim"
alias watch="watch "
alias w="watch "
alias less="less -R"
alias l="ls"
alias ll="ls -la"
alias compose="docker compose"

# k8s
alias k="kubectl"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias klf="kubectl logs -f"

function klfa() {
   kubectl logs -f -l app="$1"
}

alias kks="kubectl -n kube-system"
alias kis="kubectl -n istio-system"
alias kos="kubectl -n opa-system"
alias kci="kubectl -n cluster-ingress"
alias kcm="kubectl -n cert-manager"
alias koi="kubectl -n opa-istio"
alias kd='kubectl -n default'

function oz() {
    groot 2>/dev/null || cd $OZDIR
}

command_exists batcat && alias bat=batcat
command_exists nvim && alias vim="nvim"

function grih() {
    git rebase -i HEAD~$1
}

function squash() {
    if [[ -z $1 ]]; then
        branch="main"
    else
        branch=HEAD~$1
    fi
    git rebase -i --autosquash $branch
}

function qh() {
    if [ -z $argv[2] ]; then
        dir=$PWD
    else
        dir=$argv[2]
    fi

    grep -rn -I \
        --exclude-dir "\.terraform*" \
        --exclude-dir "install" \
        --exclude-dir "build" \
        --exclude-dir ".mypy_cache" \
        --exclude-dir ".venv" \
        --exclude-dir ".git"  \
        --exclude-dir ".cache" \
        --exclude-dir "*.egg-info" \
        --exclude-dir "node_modules" \
        --exclude-dir "swagger-ui" \
        --exclude-dir ".next" \
        --exclude "*.map" \
        --exclude "noise-field.js" \
        --exclude "*bundle.js" \
        --exclude "tf_state.json" \
        --exclude "*.tfstate" \
        --exclude-dir ".next" \
        --exclude-dir "vendor" \
        --exclude-dir "bin" \
        --exclude-dir ".ipynb_checkpoints" \
        $argv[1] $dir
}

function q() {
    qh $argv[1] $OZDIR
}

function goto() {
    cd $OZDIR/$1
}

function kc() {
    if [[ ! -z $1 ]]; then
        kubectl config set-context --current --namespace=$1
    else
        kubectl config set-context --current --namespace=samwolfson
    fi
    direnv reload
}

alias kgc="kubectl config view --minify 2>&1 | grep namespace | cut -c 16-"

function groot() {
    root="$(git rev-parse --show-toplevel)"

    if [[ "$?" != "0" ]]; then
        return 1
    fi

    cd "$root"
}

# use ripgrep if installed
if type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden  -g "!{.git,vendor,node_modules,build,.venv}"'

    _fzf_compgen_path() {
        rg --files --hidden  -g "!{.git,vendor,node_modules,build,.venv}"
    }
fi

autoload -U +X bashcompinit && bashcompinit

# autocompletion
# command_exists kubectl && source <(kubectl completion zsh)
command_exists eksctl && source <(eksctl completion zsh)
command_exists aws && command_exists aws_completer && complete -C "$(which aws_completer)" aws
command_exists terraform && complete -o nospace -C $(which terraform) terraform

# use bash-style word deletion (split on /)
autoload -U select-word-style
select-word-style bash

export EDITOR='nvim'
export VISUAL=$EDITOR

# key bindings
bindkey '^[^?' backward-kill-word
bindkey '^[b' backward-word
bindkey '^[f' forward-word

bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word

# ctrl+P to previous, ctrl+N to next
bindkey '^P' up-line-or-history
bindkey '^N' down-line-or-history

# command_exists difft && export GIT_EXTERNAL_DIFF=difft

# Begin: PlatformIO Core completion support
[[ -d ~/.platformio/penv/bin ]] && PATH=$PATH:$HOME/.platformio/penv/bin
command_exists pio && eval "$(_PIO_COMPLETE=zsh_source pio)"
# End: PlatformIO Core completion support

# fuzzy find
if [[ -d "$HOME/.config/fzf-zsh-plugin/bin" ]]; then
    export PATH="$PATH:$HOME/.config/fzf-zsh-plugin/bin"
    source "$HOME/.config/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh"
else
    bindkey '^R' history-incremental-search-backward
fi

[[ -S ~/.1password/agent.sock ]] && export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FIRST_NAME=Sam
export LAST_NAME=Wolfson

function col() {
    awk -v col="$1" '{ print $col }'
}

function upstream() ({
    set -ex
    target=${1:-main}
    current=$(git rev-parse --abbrev-ref HEAD)
    git checkout $target
    git pull
    git checkout $current
    git rebase $target
})

if [[ -d ~/.tfenv/bin ]]; then
    export PATH=~/.tfenv/bin:$PATH
fi

command_exists terraform && alias tf="terraform"

function koneoff() {
    if [[ $# -eq 0 ]]; then
        echo "usage: koneoff {image} {pod name} {optional init command}"
        return
    fi

    if [[ -z "$3" ]]; then
        kubectl run -it --rm --restart=Never --image "$1" "$2"
    else
        kubectl run -it --rm --restart=Never --image "$1" "$2" -- "$3"
    fi
}

# keep around a directory stack
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# if [[ $IS_DEV_CONTAINER = "true" ]]; then
#     alias tmux="tmux new-session 'tmux unbind-key C-b && tmux set-option -g prefix C-v && zsh'"
# fi

if [[ -d $HOME/go/bin ]]; then
    export PATH="$PATH:$HOME/go/bin"
fi

LINUX_CERT_PATH="/etc/ssl/certs/ca-certificates.crt"

[[ -f "$LINUX_CERT_PATH" ]] && export REQUESTS_CA_BUNDLE="$LINUX_CERT_PATH"

[[ -d "HOME/.cargo" ]] && . "$HOME/.cargo/env"

# MULTIPLEXER
if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

function vactivate() {
    current="$PWD"

    while [[ "$current" != "/" ]]; do
        if [[ -d "$current/.venv" ]]; then
            echo "activating venv in $current"
            source "$current/.venv/bin/activate"
            break
        fi
        current=$(dirname "$current")
    done
}

# if [[ -n "$TMUX" ]]; then
#     export TERM="tmux-256color"
# else
#     export TERM="xterm-256color"
# fi

command_exists fzf && source <(fzf --zsh)

listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

export EMAIL="terabyte128@gmail.com"
export HOMEBREW_NO_AUTO_UPDATE=true

alias darkmode='echo dark > ~/.config/appearance'
alias lightmode='echo light > ~/.config/appearance'
