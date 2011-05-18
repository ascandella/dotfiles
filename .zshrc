HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd beep extendedglob nomatch
unsetopt notify
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/echo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export OPSCODE_USER="aidenscandella"

alias dante='ssh scandac@dante.u.washington.edu'
alias tf='ssh scandac@techfee.washington.edu'
alias lions='ssh lions'
alias attu='ssh aiden@attu.cs.washington.edu'
alias vpn='ssh lvpn'
alias ll='ls -l'
alias ltr='ls -ltr'
alias drop='cd ~/Dropbox/'
alias t='tmux -u'

alias socia='cd ~/src/socia'
alias vihosts='sudo mvim /etc/hosts'
alias diffed='git diff --cached | pbcopy'

alias 'pa'='ps aux | grep '

# alias scp='noglob scp'
alias socra='cd ~/src/socrata'
alias sfr='cd ~/src/socrata/frontend'
alias scr='cd ~/src/socrata/core'
alias chef='cd ~/src/socrata/chef'
alias ws='cd ~/src'
alias g='noglob git'
alias c='gitx -c'
alias gco='git checkout'
alias testbt='sbt-test.rb'

# -- Socrata aliases --
export SOCRATA_CREDENTIALS='aiden:nediaa'
export MAVEN_OPTS=-Xmx2048m
alias psqlprod='psql -h metadbm.sea1.socrata.com -U echo -W blist_prod'
alias shuffle='git stash && git pull --rebase && git stash pop'
#source ~/src/socrata-toolbox/etc/aliases
# -- End Socrata aliases --

#export PS1="[%n]%~%# "
# DELUXE-USR-LOCAL-BIN-INSERT
# (do not remove this comment)
##
echo $PATH | grep -q -s "/usr/local/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/usr/local/bin
    export PATH
fi


export ANT_OPTS="-Xms900m -Xmx900m"

export SVN_EDITOR="vim"
#source .rake_completion.zsh
export NODE_PATH=/usr/local/lib/node

# Directory bookmarking
alias m1='alias g1="cd `pwd`"'
alias m2='alias g2="cd `pwd`"'
alias m3='alias g3="cd `pwd`"'
alias m4='alias g4="cd `pwd`"'
alias m5='alias g5="cd `pwd`"'
alias m6='alias g6="cd `pwd`"'
alias m7='alias g7="cd `pwd`"'
alias m8='alias g8="cd `pwd`"'
alias m9='alias g9="cd `pwd`"'
alias mdump='alias|grep -e "alias g[0-9]"|grep -v "alias m" > ~/.bookmarks'
alias lma='alias | grep -e "alias g[0-9]"|grep -v "alias m"|sed "s/alias //"'
touch ~/.bookmarks
source ~/.bookmarks

HOST=`hostname -s`
test -r ~/.zshrc.$HOST && . ~/.zshrc.$HOST
test -r ~/.zshrc.local && . ~/.zshrc.local

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
case $HOST {
    # simba|brooke) export ZSH_THEME="candy" ;;
    simba|brooke) export ZSH_THEME="nanotech" ;;
    crunchy|aiden-u10) export ZSH_THEME="daveverwer" ;;
    util[0-9]{2}) export ZSH_THEME="Soliah" ;;
    *) export ZSH_THEME="daveverwer" ;;
    # daveverwer candy Soliah kennethreitz random
}
#
# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew gem)

source $ZSH/oh-my-zsh.sh

# This line is to fix some RVM/ZSH interactions for determining the current path
unsetopt auto_name_dirs
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

export PATH=$HOME/src/scripts:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:$HOME/.rvm/bin

echo $PATH | grep -q -s "/Users/echo/Library/Haskell/bin"
if [ $? -eq 1 ] ; then
    PATH=$PATH:/Users/echo/Library/Haskell/bin
    export PATH
fi
