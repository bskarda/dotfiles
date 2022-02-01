# For debugging issues
#set -x

alias rcluster='ssh -l bskarda rlogin.cs.vt.edu'
alias grep='grep --color=auto'
alias l="exa -lh"
alias ll="exa -lah"
alias nh="tr \"\t\" \"\n\" | cat -n"
alias g=git
alias ce='chef exec'
alias lastten="history | tail"
alias mdt="mcv dependency:tree"
alias mdtv="mvn dependency:tree -Dverbose"
alias mcv="mvn clean verify"
alias mci="mvn clean install"
alias mcie="mvn clean install -Dexhaustive"
alias mcist="mvn clean install -DskipTests"
alias remove_trailing_whitepace="git ls-files | xargs perl -pi -e 's/ +$//'"
alias agi='ag --path-to-ignore ~/.ignore'
alias largest_files="du -cksh * | sort -rh | head"
alias p=pnpm
alias root='cd $(git rev-parse --show-toplevel)'

large_files() {
  du -sh "$@" | sort -hr | head
}

mbo() {
  # just put release and shade in here so we always build a shaded jar no matter where we are
  mvn clean verify -pl "$1" -am -Prelease,shade
}

export GPG_TTY=$(tty)
export JVM_REMOTE_3333_ARGS='-Dcom.sun.management.jmxremote.port=3333 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false'

docker_shell() {
  docker exec -i -t $1 /bin/bash
}

chime() {
  say -v Yuri "done"
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  local out file key
  IFS=$'\n' out=($(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}

function mvn_version_bump {
  mvn --batch-mode versions:set -DnewVersion="$1" -DgenerateBackupPoms=false
}

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# Autocomplete for 'g' as well
complete -o default -o nospace -F __git_wrap__git_main g

# Update window size after every command
shopt -s checkwinsize

# Turn on globstar **
shopt -s globstar

#alias git=hub
# alias vim=nvim

# Git dotfiles tracking. Run at laptop setup
# git init --bare $HOME/.dotfiles
# config config status.showUntrackedFiles no
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PAGER=less
export EDITOR=vim

export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:~/bin:$PATH

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWUNTRACKEDFILES=true
export GIT_PS1_SHOWSTASHSTATE=true

# Tab completion case insensitive
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Tab completion one tab
bind "set show-all-if-ambiguous on"

# Docker
# export DOCKER_HOST=tcp://

# Was previously in .bashrc
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# TMUX
#if which tmux >/dev/null 2>&1; then
#    # if no session is started, start a new session
#    test -z ${TMUX} && tmux
#
#    # when quitting tmux, try to attach
#    while test -z ${TMUX}; do
#        tmux attach || break
#    done
#fi

#if [[ -s ~/.git-completion.bash ]]; then
#    source ~/.git-completion.bash
#fi

## This stuff will give you a fancy-dancy prompt that includes the
## svn/git trunk/tags/branches part of the URL in it so you will always know
## where you are working in Subversion or Git.
#PROMPT_NO_COLOR="\[\033[0m\]"
#PROMPT_BLACK="\[\033[1;30m\]"
#PROMPT_BOLD_RED="\[\033[1;31m\]"
#PROMPT_BOLD_GREEN="\[\033[1;32m\]"
#PROMPT_BOLD_YELLOW="\[\033[1;33m\]"
#PROMPT_BOLD_CYAN="\[\033[1;34m\]"
#PROMPT_BOLD_MAGENTA="\[\033[1;35m\]"
#PROMPT_BOLD_GREY="\[\033[1;36m\]"
#PROMPT_BOLD_WHITE="\[\033[1;37m\]"
#PROMPT_RED="\[\033[0;31m\]"
#PROMPT_GREEN="\[\033[0;32m\]"
#PROMPT_YELLOW="\[\033[0;33m\]"
#PROMPT_CYAN="\[\033[0;34m\]"
#PROMPT_MAGENTA="\[\033[0;35m\]"
#PROMPT_TEAL="\[\033[0;36m\]"
#PROMPT_WHITE="\[\033[0;37m\]"
#
## Default SVN and Git colors
#SVN_TRUNK_COLOR_DEFAULT=$PROMPT_YELLOW
#SVN_BRANCH_COLOR_DEFAULT=$PROMPT_GREEN
#GIT_MASTER_COLOR_DEFAULT=$PROMPT_YELLOW
#GIT_BRANCH_COLOR_DEFAULT=$PROMPT_GREEN
#
## Set SVN and Git colors if not already set
## To set you own SVN_TRUNK_COLOR, define SVN_TRUNK_COLOR before sourcing pose.bash
#SVN_TRUNK_COLOR=${SVN_TRUNK_COLOR:-$SVN_TRUNK_COLOR_DEFAULT}
#SVN_BRANCH_COLOR=${SVN_BRANCH_COLOR:-$SVN_BRANCH_COLOR_DEFAULT}
#GIT_MASTER_COLOR=${GIT_MASTER_COLOR:-$GIT_MASTER_COLOR_DEFAULT}
#GIT_BRANCH_COLOR=${GIT_BRANCH_COLOR:-$GIT_BRANCH_COLOR_DEFAULT}

# check if the current directory is the root of a git repo and fetch
function git_fetch_from_root {
if [ -d .git ]; then
  git fetch;
fi
}

## Print nickname for git/hg/bzr/svn version control in CWD
function __scm_branch {
local dir="$PWD"
local vcs
local nick
while [[ "$dir" != "/" ]]; do
    for vcs in git hg svn bzr; do
        if [[ -d "$dir/.$vcs" ]] && hash "$vcs" &>/dev/null; then
            case "$vcs" in
                git) __git_ps1 "${1:-(%s) }"; return;;
                hg) nick=$(hg branch 2>/dev/null);;
                svn) nick=$(svn info 2>/dev/null\
                    | grep -e '^URL:'\
                    | sed -e "s/.*\///");;
                bzr)
                    local conf="${dir}/.bzr/branch/branch.conf" # normal branch
                    [[ -f "$conf" ]] && nick=$(grep -E '^nickname =' "$conf" | cut -d' ' -f 3)
                    conf="${dir}/.bzr/branch/location" # colo/lightweight branch
                    [[ -z "$nick" ]] && [[ -f "$conf" ]] && nick="$(basename "$(< $conf)")"
                    [[ -z "$nick" ]] && nick="$(basename "$(readlink -f "$dir")")";;
            esac
            [[ -n "$nick" ]] && printf "($nick)"
            return 0
        fi
    done
    dir="$(dirname "$dir")"
done
}

# function prompt {
# if [[ -s ~/.git-prompt.sh ]]; then
#     source ~/.git-prompt.sh
#     # TODO Use this in PS1/Prompt command
#     if [[ -s ~/.rvm/bin/rvm-prompt ]]; then
#         #PROMPT_COMMAND='__git_ps1 "\u@\h:\w [\$(~/.rvm/bin/rvm-prompt)]"  "\\n\$ " '
#         PS1='\u@\h:\w [$(~/.rvm/bin/rvm-prompt)] $(__scm_branch)  \n\$ '
#     else
#         PROMPT_COMMAND='__git_ps1 "\u@\h:\w"  "\\n\$ " '
#     fi
# fi
# }

function jobcount {
local stopped=$(jobs -s | wc -l | tr -d " ")
local running=$(jobs -r | wc -l | tr -d " ")
if [[ $((stopped + running)) -gt 0 ]]; then
    echo -n "[${PROMPT_YELLOW}${stopped}s|${running}r${PROMPT_NO_COLOR}] "
fi
}


if [[ -s ~/.git-prompt.sh ]]; then
    source ~/.git-prompt.sh
    PROMPT_COMMAND='__git_ps1 "\u@\h:\w $(jobcount)"  "\\n\$ " '
fi

#Set up history. Must be after Prompt is set
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
# Useful timestamp format
HISTTIMEFORMAT='%F %T '
shopt -s histappend                      # append to history, don't overwrite it

# Save multi-line commands as one command
shopt -s cmdhist

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


# .bashrc is empty
#[[ -s ~/.bashrc ]] && source ~/.bashrc

#CD Stuff
# Prepend cd to directory names automatically
shopt -s autocd
# Correct spelling errors during tab-completion
shopt -s dirspell
# Correct spelling errors in arguments supplied to cd
shopt -s cdspell
# Allow you to cd to popular folders
CDPATH=".:~/source:./packages"

# cdable_vars lets you run `cd var` and it will bring you into specified dir
# Saving cdable_vars for when it's needed.
#export documents="$HOME/Documents"
#shopt -s cdable_vars

# source "$HOME/bin/tmuxinator.bash"

# OS specific configuration
osname=`uname`
if [[ "$osname" == "Darwin" ]]; then
    source "$HOME/.dotfiles_osx"
elif [[ "$osname" == "Linux" ]]; then
    source "$HOME/.dotfiles_linux"
fi

# source all files that start with .bskarda_extra_
# this allows for custom configuration
for f in $HOME/.bskarda_extra_*; do source $f; done

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
# export PATH="$HOME/.jenv/bin:$PATH"
# eval "$(jenv init -)"
# export PATH="/usr/local/opt/ab/bin:$PATH"

# asdf instead of all version managers
. $(brew --prefix asdf)/asdf.sh
. $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
. ~/.asdf/plugins/java/set-java-home.bash

# homebrew rabbitmq
export PATH="$PATH:/usr/local/sbin"

#chefdk
# Disable these so you have to run them with `chef exec`.
# Causes issues with homebrew and node (pkgconfig)
#eval "$(chef shell-init bash)"

# Rustup
# export PATH="$HOME/.cargo/bin:$PATH"
# source $HOME/.cargo/env

# NVM
#export NVM_DIR="$HOME/.nvm"
#[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
#[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Old Base16 Shell
# BASE16_SHELL="$HOME/.base16-eighties.dark.sh"
# [[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Base16 Shell
# Variation on https://github.com/chriskempson/base16-shell#bashzsh
BASE16_SHELL="$HOME/.config/base16-shell/"
function base_16_setup() {
  [ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
    eval "$("$BASE16_SHELL/profile_helper.sh")"
}
if [[ -s $BASE16_SHELL ]]; then
  base_16_setup
else
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
  base_16_setup
  # run base16_eighties on first setup
fi

# Create a new directory and enter it
mkd() {
  mkdir -p "$@"
  cd "$@" || exit
}

# Make a temporary directory and enter it
tmpd() {
  local dir
  if [ $# -eq 0 ]; then
    dir=$(mktemp -d)
  else
    dir=$(mktemp -d -t "${1}.XXXXXXXXXX")
  fi
  cd "$dir" || exit
}

# TODO remove this if it's not used
#export CLI_COLORS=1
#export CLICOLOR=1

#pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"


#export PATH="$HOME/.poetry/bin:$PATH"
#export PS1="\u@\h\[$(tput sgr0)\]"

#test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# tabtab source for packages
# uninstall by removing these lines
#[ -f ~/.config/tabtab/bash/__tabtab.bash ] && . ~/.config/tabtab/bash/__tabtab.bash || true

