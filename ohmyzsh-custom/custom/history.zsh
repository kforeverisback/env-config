# See documentation on these HIST variables at http://zsh.sourceforge.net/Doc/Release/Options.html#History-Options
# https://kevinjalbert.com/more-shell-history/#:~:text=HISTSIZE%20indicates%20how%20many%20commands,which%20houses%20your%20previous%20commands
HISTSIZE=5000
SAVEHIST=10000
HISTFILESIZE=100000
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
#setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt SHARE_HISTORY             # Share History Between sessions
#setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
#setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
