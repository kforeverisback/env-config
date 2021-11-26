# Extra Utilities and their aliases
#

[[ -z $_k_help ]] && export _k_help=()
# ---------------- Alias -----------------
#
alias mkdir='mkdir -pv'                    # Preferred 'mkdir' implementation
#alias cp='cp -iv'                         # Preferred 'cp' implementation
# Check whether --color=auto is available then add --color=auto or add -G
if [[ $(alias ls) == *"exa"* ]] # We want to use exa instead of standard ls
then
  # If not found then lets use this
  ls --color=auto &> /dev/null && alias ls='ls --color=auto' || alias ls='ls -G'
fi
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=31:cd=31:su=31:sg=31:tw=31:ow=31'
alias ll='ls -Flh'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
#cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias c='clear'                             # c:            Clear terminal display
#alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
# In mac auto completion is a little differnt
#alias cic='bind "set completion-ignore-case On";bind "set show-all-if-ambiguous on"'  # cic:          Make tab-completion case-insensitive
#alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () {mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
alias cd..='cd ..'
alias cls=clear
alias pwdln='pwd -P'
alias dkr='docker'
alias d=docker
alias dokcer='docker'
alias kctl='kubectl'
alias k='kubectl'
alias g='git'
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
# ---------------- Alias -------------------

# ----------------- Func -------------------

# Setting the brew proxy according to this stackoverflow
# https://apple.stackexchange.com/questions/228865/how-to-install-an-homebrew-package-behind-a-proxy
setGitProxy () {
  git config --global http.proxy http://proxy-chain.XXXX.com:911 && \
  git config --global https.proxy https://proxy-chain.XXXX.com:912 && \
  git config --global core.sshCommand "ssh -i ~/.ssh/bitbucket-key -o ProxyCommand='nc -X 5 -x proxy-us.XXXX.com:1080 %h %p' -F /dev/null"
}
resetGitProxy () {
  git config --global --unset http.proxy && \
  git config --global --unset https.proxy && \
  git config --global --unset core.sshCommand
}
sshproxy () { ssh -o ProxyCommand="nc -X 5 -x proxy-us.XXXX.com:1080 %h %p" "$@"; }
scpproxy () { scp -o ProxyCommand="nc -X 5 -x proxy-us.XXXX.com:1080 %h %p" "$@"; }

scpjump() { local host=$(getHost "$@"); echo $host; scp -o ProxyCommand="ssh jumpbox nc $host 22" "$@"; }
sshjump() { ssh -X -J jumpbox "$@";  }

scpjumpmbs() { local host=$(getHost "$@") && scp -o ProxyCommand="ssh jumpbox-mbs nc $host 22" "$@"; }
sshjumpmbs() { ssh -X -J jumpbox-mbs "$@"; }

export PROXY_PRFX="(XXXX)"
setProxy() {
  export HTTPS_PROXY="http://proxy-fm.XXXX.com:911";
  export HTTP_PROXY=$HTTPS_PROXY; export http_proxy=$HTTPS_PROXY;
  export https_proxy=$HTTPS_PROXY; export ALL_PROXY=$HTTPS_PROXY;
  # BASH
  #export PS1="$PROXY_PRFX$PS1";
  # ZSH
  export PROMPT="$PROXY_PRFX $PROMPT";
}
resetProxy() {
  unset HTTPS_PROXY;unset HTTP_PROXY;unset http_proxy;unset https_proxy;unset ALL_PROXY;
  # BASH
  #export PS1="${PS1/$PROXY_PRFX/}";
  # ZSH
  export PROMPT=${PROMPT/${PROXY_PRFX}/}
}
restartNet() {
  if [ $# -eq 1 ]; then
    sudo ifconfig $1 down; sleep 0.1;
    sudo ifconfig $1 up;
  else
    echo "restartNet NetworkAdapterName"
  fi
}

myhelp() {
    printf '%s\n' "${_k_help[@]}"
}

# ----------------------- Exports ----------------------
# Go development
# Kushal: Instead of "brew --prefix golang" we are replacing this command with output of "brew --prefix golang"
#export GOROOT="$(brew --prefix golang)/libexec"
export GOPATH="${HOME}/Go"
export GOROOT="/usr/lib/go/"
#test -d "${GOPATH}" || mkdir "${GOPATH}"
#test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
[ "${PATH#*:${GOPATH}/bin}" == "$PATH" ] && export PATH="$PATH:${GOPATH}/bin"
[ "${PATH#*:$HOME/.local/bin}" == "$PATH" ] && export PATH="$PATH:$HOME/.local/bin"
export KUBE_EDITOR="vi"
# ----------------------- Exports ----------------------
# Apparently enabling gnu-utils is not enough, so have to run hash -r to add gnu-utils alias
# hash -r
_k_help+="Enabled zsh Plugins '$(printf -- '%s ' ${plugins[@]})'"
_k_help+="We are using Starship for Themeing!"

_k_help+="Added $GOPATH/bin to path"
_k_help+="FileMan: ranger(terminal)"
_k_help+='Added Rusted tools:'
_k_help+='    fd, bat, exa, procs, btm, sd, dust, toeki, hyperfine, pueue, git-delta'
echo "Check myhelp for initialization notice"

