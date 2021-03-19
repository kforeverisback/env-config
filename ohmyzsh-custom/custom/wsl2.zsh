[[ -z $_k_help ]] && export _k_help=()
_k_help+="Useful prog: trickle"
_k_help+="WSL2 Network IP: $(wsl-ip). Use 'wsl-ip' for WSL2-IP addr"
_k_help+="Windows Virt Network IP: $(win-ip). Use 'win-ip' for VirtNetwork-IP addr"

export GOROOT="/usr/local/go/"
export PATH="$PATH:${GOROOT}/bin:/home/kushal/.dotnet/tools/:/mnt/c/Users/mekram/AppData/Local/Programs/MicrosoftVSCode/bin/"
export KUBE_EDITOR="vi"

# WSL-X11 Specific Export
export DISPLAY=$(win-ip):0
export LIBGL_ALWAYS_INDIRECT=1

# Sourcing Azure's Bash completion
source /etc/bash_completion.d/azure-cli
# Source Github ZSH Completion
source ~/.local/share/github_zsh_completion.zsh

update_clock() {
    echo '[ROOT] Updating clock (sudo hwclock --hctosys)'
    sudo hwclock -s # hwclock --hctosys
}
_k_help+="Use update_clock to synchronize clock with RTC"
