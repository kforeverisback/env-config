# Extra Utilities and their aliases
#
# Built 'cp' from scratch with Advanced mod: https://github.com/jarun/advcpmvn
#alias cp='cp_adv_mod_8.32 -g'
#alias mv='mv_adv_mod_8.32 -g'
alias rm="echo Use del/trash. /bin/rm is aliased to xxrm"
alias xxrm='/bin/rm'
alias grm="echo Use del/trash, or the full path i.e. '/usr/local/bin/grm'"
# If you're having SpaceVim issues with NVim, disable nvim aliases
alias vim='nvim'
alias e='nvim'
alias vi='nvim'
alias vimdiff='nvim -d'

## Awesome Rusted Tools
alias fd='fd -H'
alias cat='bat' # Using the Bat tool instead of cat

# Unalias ls and ll
alias ls='exa --color=auto'
alias ps='procs' # https://github.com/dalance/procs
alias top='btm' # Completion installed in ~/.oh-my-zsh/completions
alias sd='sd' # Sed replacement https://github.com/chmln/sd
alias du='dust' # https://github.com/bootandy/dust
# Another one https://github.com/nachoparker/dutree
alias cloc='tokei'
alias bench='hyperfine'
alias q='pueue'
alias rgv='rg -v "rg " | rg'
alias rgi='rg -i'
alias pdfview='evince'
_k_help+='Added Rusted tools:'
_k_help+='    fd, bat, exa, procs, btm, sd, dust, toeki, hyperfine, pueue, git-delta'
