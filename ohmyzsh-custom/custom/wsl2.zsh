[[ -z $_k_help ]] && export _k_help=()
_k_help+="Useful prog: trickle"
_k_help+="WSL2 Network IP: $(wsl-ip). Use 'wsl-ip' for WSL2-IP addr"
_k_help+="Windows Virt Network IP: $(win-ip). Use 'win-ip' for VirtNetwork-IP addr"

export GOROOT="/usr/local/go/"
export PATH="$PATH:${GOROOT}/bin:$HOME/.dotnet/tools/:/mnt/c/Users/mekram/AppData/Local/Programs/MicrosoftVSCode/bin/"
export KUBE_EDITOR="vi"

# WSL-X11 Specific Export
export DISPLAY=$(win-ip):0
export LIBGL_ALWAYS_INDIRECT=1

# Kushal: For OpenSSH Agent on WSL: https://esc.sh/blog/ssh-agent-windows10-wsl2/
# https://blog.kylemanna.com/linux/use-funtoos-keyhain-insetad-of-gnome-keyring/
update_keychain() {
    if ! command -v keychain &> /dev/null; then
      echo "'keychain' not found in system."
    else
      echo 'Starting ssh-agent via keychain'
      /usr/bin/keychain -q --nogui --timeout 180 $HOME/.ssh/id_rsa $HOME/.ssh/github-key-ms
      source $HOME/.keychain/$HOST-sh
      _k_help+="Use update_keychain to add keys to ssh-agent"
    fi
}
update_keychain

# Sourcing Azure's Bash completion
source /etc/bash_completion.d/azure-cli
# Source Github ZSH Completion
source ~/.local/share/github_zsh_completion.zsh
if type "kubectl" > /dev/null; then
  source <(kubectl completion zsh)
fi

update_clock() {
    echo '[ROOT] Updating clock (sudo hwclock --hctosys)'
    sudo hwclock -s # hwclock --hctosys
}
_k_help+="Use update_clock to synchronize clock with RTC"

