# Extra Utilities and their aliases
#
# Built 'cp' from scratch with Advanced mod: https://github.com/jarun/advcpmvn
alias cp='cp_adv_mod_8.32 -gi'
alias mv='mv_adv_mod_8.32 -gi'
alias rm="echo Use del/trash, or the full path i.e. '/bin/rm'"
alias grm="echo Use del/trash, or the full path i.e. '/usr/local/bin/grm'"
# If you're having SpaceVim issues with NVim, disable nvim aliases
alias vim='nvim'
alias e='nvim'
alias vi='nvim'
alias vimdiff='nvim -d'
alias fd='fd -H'
alias cat='bat' # Using the Bat tool instead of cat

# Unalias ls and ll
alias ls='exa --color=auto'
