# Zsh Config
#
# https://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter
autoload -U select-word-style
select-word-style bash
# Most flexible solution of
#WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export _k_help=()
# ------ Alias -------
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
# If WSL2
if [[ $(uname -a | grep -iE '.WSL|.microsoft') != '' ]]; then
    # In WSL2 Microsoft Kernel
    alias wsl-ip="ip a show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
    alias win-ip='cat /etc/resolv.conf | grep nameserver | awk "{print \$2}"'
fi
alias cd..='cd ..'
alias cls=clear
alias pwdln='pwd -P'
alias dkr='docker'
alias d=docker
alias dokcer='docker'
alias kctl='kubectl'
alias k='kubectl'
# ------ Alias -------

#[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

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
# Go development
# Kushal: Instead of "brew --prefix golang" we are replacing this command with output of "brew --prefix golang"
#export GOROOT="$(brew --prefix golang)/libexec"
export GOPATH="${HOME}/Go"
export GOROOT="/usr/lib/go/"
#test -d "${GOPATH}" || mkdir "${GOPATH}"
#test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
export PATH="$PATH:${GOPATH}/bin/:$HOME/.local/bin"
export KUBE_EDITOR="vi"

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
bindkey '^U' backward-kill-line
bindkey '^Y' yank

# Apparently enabling gnu-utils is not enough, so have to run hash -r to add gnu-utils alias
# hash -r
_k_help+="Enabled zsh Plugins '$(printf -- '%s ' ${plugins[@]})'"
_k_help+="We are using Starship for Themeing!"

_k_help+="$GOPATH/bin to path"
_k_help+="FileMan: ranger(terminal)"
myhelp() {
    printf '%s\n' "${_k_help[@]}"
}
echo "Check myhelp for initialization notice"

