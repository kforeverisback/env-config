[[ -z $_k_help ]] && export _k_help=()

# Kushal: For OpenSSH Agent on WSL: https://esc.sh/blog/ssh-agent-windows10-wsl2/
# https://blog.kylemanna.com/linux/use-funtoos-keyhain-insetad-of-gnome-keyring/
update_keychain() {
  if ! command -v keychain &> /dev/null; then
    echo "'keychain' not found in system."
  else
    timeout=180 # Default
    [[ -z "$1" ]] || timeout=$1
    echo "Starting ssh-agent with ${timeout}m timeout via keychain"
    if [[ $(pgrep -a ssh-agent | sed 's/^.*-t //g') -ne $(( timeout * 60 )) ]];
    then
      keychain -q -k all
    fi
    keychain -q --nogui --timeout ${timeout} $HOME/.ssh/id_rsa $HOME/.ssh/github-key-ms
    source $HOME/.keychain/$HOST-sh
  fi
}
_k_help+="Use update_keychain to add keys to ssh-agent"
update_keychain

# If WSL2
if [[ $(uname -a | grep -iE '.WSL|.microsoft') != '' ]]; then
    # In WSL2 Microsoft Kernel
    wsl-ip() { ip a show eth0 | grep --color=never -oP '(?<=inet\s)\d+(\.\d+){3}' }
    win-ip() { cat /etc/resolv.conf | grep nameserver | awk '{print $2}' }
fi

# Sourcing Azure's Bash completion
[ -f /etc/bash_completion.d/azure-cli ] && source /etc/bash_completion.d/azure-cli
# Source Github ZSH Completion
[ -f ~/.local/share/github_zsh_completion.zsh ] && source ~/.local/share/github_zsh_completion.zsh
if type "kubectl" > /dev/null; then
  source <(kubectl completion zsh)
fi

update_clock() {
  echo '[ROOT] Updating clock (sudo hwclock --hctosys)'
  sudo hwclock -s # hwclock --hctosys
}
_k_help+="Use update_clock to synchronize clock with RTC"

clip () {
  local clip_path=/mnt/c/Windows/System32/Clip.exe
  local in=$1
  [ ! -f ${clip_path} ] && echo "${clip_path} binary not found" && exit 1
  [ -z "$in" ] && in=`cat` # read everything from pipe stdin
  echo ${in} | tr '\n' '\r\n' | ${clip_path} # replace newline to windows format
}

# ------------------- Export ----------------------
#export GOROOT="/usr/local/go/"
[[ "${PATH#*:/mnt/c/Users/mekram/AppData/Local/Programs/MicrosoftVSCode/bin}" == "$PATH" ]] && export PATH="$PATH:/mnt/c/Users/mekram/AppData/Local/Programs/MicrosoftVSCode/bin"
[[ "${PATH#*:$HOME/.dotnet/tools/}" == "$PATH" ]] && export PATH="$PATH:$HOME/.dotnet/tools/"
# WSL-X11 Specific Export
export DISPLAY=$(win-ip):0
export LIBGL_ALWAYS_INDIRECT=1

_k_help+="Useful prog: trickle"
_k_help+="WSL2 Network IP: $(wsl-ip). Use 'wsl-ip' for WSL2-IP addr"
_k_help+="Windows Virt Network IP: $(win-ip). Use 'win-ip' for VirtNetwork-IP addr"

