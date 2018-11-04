#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# POWERLINE SETTINGS

. ~/.local/share/nvim/plugged/powerline/powerline/bindings/bash/powerline.sh

# RUBY SETTINGS

# source /usr/share/chruby/chruby.sh
# source /usr/share/chruby/auto.sh

#### ssh-agent per wiki.archlinux.org

if ! pgrep -u $USER ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.ssh-agent-thing)
fi
ssh-add -l >/dev/null || alias ssh='ssh-add -l >/dev/null || ssh-add && unalias ssh; ssh'
alias vi='emacs -nw'
alias emacs='emacs'
export EDITOR=nvim
alias pb='curl -F c=@- https://ptpb.pw/'
alias rm_nodemod='find ~/code "node_modules" -exec rm -rf "{}" +'
# below from http://www.thegeekstuff.com/2008/10/6-awesome-linux-cd-command-hacks-productivity-tip3-for-geeks/
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias bsync='browser-sync -f . --no-open'
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools export PATH=$PATH:$ANDROID_HOME/platform-tools

export GPG_TTY=$(tty)
# to prevent react scripts from opening browser
export BROWSER=none
#for cs50 library
export LD_LIBRARY_PATH=/usr/local/lib
