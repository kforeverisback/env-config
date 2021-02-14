# Zsh Confir
#
# https://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter
autoload -U select-word-style
select-word-style bash
# Most flexible solution of
#WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

export _k_custom_alias_k=()
export _k_custom_func=()
export _k_help=()
# ------ Alias -------
alias_k() { _k_custom_alias_k+="$@"; alias "$@" }
#alias_k cp='cp -iv'                           # Preferred 'cp' implementation
alias_k cp='cp_adv_mod_8.32 -gi'             # Built 'cp' from scratch with Advanced mod: https://github.com/jarun/advcpmvn
alias_k mv='mv_adv_mod_8.32 -gi'             # Built 'mv' from scratch with Advanced mod: https://github.com/jarun/advcpmvn
alias_k mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
# Check whether --color=auto is available then add --color=auto or add -G
ls --color=auto &> /dev/null && alias_k ls='ls --color=auto' || alias_k ls='ls -G'
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=31:cd=31:su=31:sg=31:tw=31:ow=31'
alias_k ll='ls -FlAhp --color=auto'                       # Preferred 'ls' implementation
alias_k less='less -FSRXc'                    # Preferred 'less' implementation
#cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias_k c='clear'                             # c:            Clear terminal display
#alias_k which='type -all'                     # which:        Find executables
alias_k path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias_k show_options='shopt'                  # Show_options: display bash options settings
alias_k fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias_k rm="echo Use del/trash, or the full path i.e. '/bin/rm'"
alias_k grm="echo Use del/trash, or the full path i.e. '/usr/local/bin/grm'"
# In mac auto completion is a little differnt
#alias_k cic='bind "set completion-ignore-case On";bind "set show-all-if-ambiguous on"'  # cic:          Make tab-completion case-insensitive
#alias_k cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
_k_custom_func+="mcd"
alias_k brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'
alias_k brewclean='brew prune; brew cleanup; brew doctor'
alias_k cls=clear
alias_k llrt='ll -lrt'
alias_k pwdln='pwd -P'
alias_k vim='nvim'
alias_k e='nvim'
alias_k vi='nvim'
alias_k dkr='docker'
alias_k d=docker
alias_k dokcer='docker'
alias_k kctl='kubectl'

myalias() {
    echo "Custom Aliases:"
    printf '%s\n' "${_k_custom_alias_k[@]}"
    _k_custom_func+="${funcstack[1]}"
    _k_help+="Check alias: myalias"
}
# ------ Alias -------

#[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# Setting the brew proxy according to this stackoverflow
# https://apple.stackexchange.com/questions/228865/how-to-install-an-homebrew-package-behind-a-proxy
setGitProxy () {
    git config --global http.proxy http://proxy-chain.XXXX.com:911 && \
    git config --global https.proxy https://proxy-chain.XXXX.com:912 && \
    git config --global core.sshCommand "ssh -i ~/.ssh/bitbucket-key -o ProxyCommand='nc -X 5 -x proxy-us.XXXX.com:1080 %h %p' -F /dev/null"
    _k_custom_func+="${funcstack[1]}"
}
resetGitProxy () {
    git config --global --unset http.proxy && \
    git config --global --unset https.proxy && \
    git config --global --unset core.sshCommand
    _k_custom_func+="${funcstack[1]}" 
}
sshproxy () { ssh -o ProxyCommand="nc -X 5 -x proxy-us.XXXX.com:1080 %h %p" "$@";_k_custom_func+="${funcstack[1]}" }
scpproxy () { scp -o ProxyCommand="nc -X 5 -x proxy-us.XXXX.com:1080 %h %p" "$@";_k_custom_func+="${funcstack[1]}" }

scpjump() { local host=$(getHost "$@"); echo $host; scp -o ProxyCommand="ssh jumpbox nc $host 22" "$@";_k_custom_func+="${funcstack[1]}" }
sshjump() { ssh -X -J jumpbox "$@"; _k_custom_func+="${funcstack[1]}" }

scpjumpmbs() { local host=$(getHost "$@") && scp -o ProxyCommand="ssh jumpbox-mbs nc $host 22" "$@";_k_custom_func+="${funcstack[1]}" }
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
    _k_custom_func+="${funcstack[1]}"
}
resetProxy() {
    unset HTTPS_PROXY;unset HTTP_PROXY;unset http_proxy;unset https_proxy;unset ALL_PROXY;
    # BASH
    #export PS1="${PS1/$PROXY_PRFX/}";
    # ZSH
    export PROMPT=${PROMPT/${PROXY_PRFX}/}
    _k_custom_func+="${funcstack[1]}"
}
restartNet() {
    if [ $# -eq 1 ]; then
        sudo ifconfig $1 down; sleep 0.1;
        sudo ifconfig $1 up;
    else
        echo "restartNet NetworkAdapterName"
    fi
    _k_custom_func+="${funcstack[1]}"
}
# Go development
# Kushal: Instead of "brew --prefix golang" we are replacing this command with output of "brew --prefix golang"
#export GOROOT="$(brew --prefix golang)/libexec"
export GOPATH="${HOME}/Go"
export GOROOT="/usr/lib/go/"
#test -d "${GOPATH}" || mkdir "${GOPATH}"
#test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"
export PATH="$PATH:${GOPATH}/bin/:/home/kushal/.bin"
export KUBE_EDITOR="vi"

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
bindkey \^U backward-kill-line

_k_help+="$GOPATH/bin to path"
_k_help+="FileMan: ranger(terminal), thunar"
_k_help+="ImgView:viewnior, VDO:vlc,mpv Aud:audacious"

# Kushal
# Apparently enabling gnu-utils is not enough, so have to run hash -r to add gnu-utils alias
hash -r
_k_help+="Enabled zsh Plugins '$(printf -- '%s ' ${plugins[@]})'"
_k_help+="We are using Starship for Themeing!"
myhelp() {
    _k_custom_func+="${funcstack[1]}"
    printf '%s\n' "${_k_help[@]}"
}
echo "Check myhelp for initialization notice"
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
