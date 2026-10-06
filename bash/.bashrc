# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
# fastfetch intro (skip in tmux and non-interactive shells)
if [[ $- == *i* && -z $TMUX ]]; then
  fastfetch --pipe | tte wipe --final-gradient-stops 00e5ff 7aa2f7 --final-gradient-direction diagonal
fi
export PATH="$HOME/.cargo/bin:$PATH"
alias matrix='unimatrix -s 96 -c cyan'
