alias rcluster='ssh -l bskarda rlogin.cs.vt.edu'
alias grep='grep --color=auto'
alias l="ls -lh"
alias ll="ls -lah"
alias nh="tr \"\t\" \"\n\" | cat -n"
alias g=hub
alias lastten="history | tail"
alias mdt="color_maven dependency:tree"
alias mdtv="color_maven dependency:tree -Dverbose"
alias mcv="color_maven clean verify"
alias mci="color_maven clean install"
alias mcie="color_maven clean install -Dexhaustive"
alias mcist="color_maven clean install -DskipTests"
alias remove_trailing_whitepace="git ls-files | xargs perl -pi -e 's/ +$//'"

export JVM_REMOTE_3333_ARGS='-Dcom.sun.management.jmxremote.port=3333 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false'

docker_shell() {
  docker exec -i -t $1 /bin/bash
}

docker_cleanup() {
  docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && yes | docker network prune
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
complete -o default -o nospace -F _git g

# Update window size after every command
shopt -s checkwinsize

# Turn on globstar **
shopt -s globstar

alias git=hub
# alias vim=nvim

# Git dotfiles tracking. Run at laptop setup
# git init --bare $HOME/.dotfiles
# config config status.showUntrackedFiles no
alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PAGER=less
export EDITOR=vim

export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin:~/bin:$PATH

export ECLIPSE_HOME=/opt/homebrew-cask/Caskroom/eclipse-java/4.5.2/Eclipse.app/Contents/Eclipse

export GOPATH=~/src/go
export PATH=~/src/go/bin:$PATH

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
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

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

if [[ -s ~/.git-completion.bash ]]; then
    source ~/.git-completion.bash
fi

# This stuff will give you a fancy-dancy prompt that includes the
# svn/git trunk/tags/branches part of the URL in it so you will always know
# where you are working in Subversion or Git.
PROMPT_NO_COLOR="\[\033[0m\]"
PROMPT_BLACK="\[\033[1;30m\]"
PROMPT_BOLD_RED="\[\033[1;31m\]"
PROMPT_BOLD_GREEN="\[\033[1;32m\]"
PROMPT_BOLD_YELLOW="\[\033[1;33m\]"
PROMPT_BOLD_CYAN="\[\033[1;34m\]"
PROMPT_BOLD_MAGENTA="\[\033[1;35m\]"
PROMPT_BOLD_GREY="\[\033[1;36m\]"
PROMPT_BOLD_WHITE="\[\033[1;37m\]"
PROMPT_RED="\[\033[0;31m\]"
PROMPT_GREEN="\[\033[0;32m\]"
PROMPT_YELLOW="\[\033[0;33m\]"
PROMPT_CYAN="\[\033[0;34m\]"
PROMPT_MAGENTA="\[\033[0;35m\]"
PROMPT_TEAL="\[\033[0;36m\]"
PROMPT_WHITE="\[\033[0;37m\]"

# Default SVN and Git colors
SVN_TRUNK_COLOR_DEFAULT=$PROMPT_YELLOW
SVN_BRANCH_COLOR_DEFAULT=$PROMPT_GREEN
GIT_MASTER_COLOR_DEFAULT=$PROMPT_YELLOW
GIT_BRANCH_COLOR_DEFAULT=$PROMPT_GREEN

# Set SVN and Git colors if not already set
# To set you own SVN_TRUNK_COLOR, define SVN_TRUNK_COLOR before sourcing pose.bash
SVN_TRUNK_COLOR=${SVN_TRUNK_COLOR:-$SVN_TRUNK_COLOR_DEFAULT}
SVN_BRANCH_COLOR=${SVN_BRANCH_COLOR:-$SVN_BRANCH_COLOR_DEFAULT}
GIT_MASTER_COLOR=${GIT_MASTER_COLOR:-$GIT_MASTER_COLOR_DEFAULT}
GIT_BRANCH_COLOR=${GIT_BRANCH_COLOR:-$GIT_BRANCH_COLOR_DEFAULT}

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

function prompt {
if [[ -s ~/.git-prompt.sh ]]; then
    source ~/.git-prompt.sh
    # TODO Use this in PS1/Prompt command
    if [[ -s ~/.rvm/bin/rvm-prompt ]]; then
        #PROMPT_COMMAND='__git_ps1 "\u@\h:\w [\$(~/.rvm/bin/rvm-prompt)]"  "\\n\$ " '
        PS1='\u@\h:\w [$(~/.rvm/bin/rvm-prompt)] $(__scm_branch)  \n\$ '
    else
        PROMPT_COMMAND='__git_ps1 "\u@\h:\w"  "\\n\$ " '
    fi
fi
}

function jobcount {
local stopped=$(jobs -s | wc -l | tr -d " ")
local running=$(jobs -r | wc -l | tr -d " ")
if [[ $((stopped + running)) -gt 0 ]]; then
    echo -n "[${PROMPT_YELLOW}${stopped}s|${running}r${PROMPT_NO_COLOR}] "
fi
}


if [[ -s ~/.git-prompt.sh ]]; then
    source ~/.git-prompt.sh
    # TODO Use this in PS1/Prompt command
    if [[ -s ~/.rvm/bin/rvm-prompt ]]; then
        PROMPT_COMMAND='__git_ps1 "\u@\h:\w $(jobcount)[\$(~/.rvm/bin/rvm-prompt)]"  "\\n\$ " '
        #PS1='\u@\h:\w [$(~/.rvm/bin/rvm-prompt)] $(__scm_branch)  \n\$ '
    else
        PROMPT_COMMAND='__git_ps1 "\u@\h:\w $(jobcount)"  "\\n\$ " '
    fi
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

# Maven
function color_maven() {
  # TODO centralize colors
  local BLUE="[0;34m"
  local RED="[0;31m"
  local LIGHT_RED="[1;31m"
  local LIGHT_GRAY="[0;37m"
  local LIGHT_GREEN="[1;32m"
  local LIGHT_BLUE="[1;34m"
  local LIGHT_CYAN="[1;36m"
  local YELLOW="[1;33m"
  local WHITE="[1;37m"
  local NO_COLOUR="[0m"
  mvn "$@" | sed \
    -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${LIGHT_GREEN}Tests run: \1$NO_COLOUR, Failures: $RED\2$NO_COLOUR, Errors: $YELLOW\3$NO_COLOUR, Skipped: $LIGHT_BLUE\4$NO_COLOUR/g" \
    -e "s/\(\[\{0,1\}WARN\(ING\)\{0,1\}\]\{0,1\}.*\)/$YELLOW\1$NO_COLOUR/g" \
    -e "s/\(\[ERROR\].*\)/$RED\1$NO_COLOUR/g" \
    -e "s/\(\(BUILD \)\{0,1\}FAILURE.*\)/$RED\1$NO_COLOUR/g" \
    -e "s/\(\(BUILD \)\{0,1\}SUCCESS.*\)/$LIGHT_GREEN\1$NO_COLOUR/g"
    return $PIPESTATUS
}

alias mvn=color_maven

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
CDPATH=".:~/source"

# cdable_vars lets you run `cd var` and it will bring you into specified dir
# Saving cdable_vars for when it's needed.
#export documents="$HOME/Documents"
#shopt -s cdable_vars

source "$HOME/bin/tmuxinator.bash"

# OS specific configuration
osname=`uname`
if [[ "$osname" == "Darwin" ]]; then
    source "$HOME/.dotfiles_osx"
elif [[ "$osname" == "Linux" ]]; then
    source "$HOME/.dotfiles_linux"
fi

# Base16 Shell
BASE16_SHELL="$HOME/.base16-eighties.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# source all files that start with .bskarda_extra_
# this allows for custom configuration
for f in $HOME/.bskarda_extra_*; do source $f; done

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export PATH="/usr/local/opt/ab/bin:$PATH"

#chefdk
eval "$(chef shell-init bash)"
PATH=/Users/b.skarda/.chefdk/gem/ruby/2.1.0/bin:$PATH
