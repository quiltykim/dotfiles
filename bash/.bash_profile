#
# ~/.bash_profile
#
export PATH=$PATH:~/.local/share/nvim/plugged/powerline/scripts/
[[ -f ~/.bashrc ]] && . ~/.bashrc
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# OPAM configuration
. /home/qkay/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
