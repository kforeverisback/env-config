[[ -z $_k_help ]] && export _k_help=()

# Kushal: For OpenSSH Agent on WSL: https://esc.sh/blog/ssh-agent-windows10-wsl2/
# https://blog.kylemanna.com/linux/use-funtoos-keyhain-insetad-of-gnome-keyring/
function update_keychain {
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

function update_clock {
  echo '[ROOT] Updating clock (sudo hwclock --hctosys)'
  sudo hwclock -s # hwclock --hctosys
}

# Copy from WSL terminal to Windows Clipboard
# Sort of a xclip alternative
function clip {
  clip_path=$(wslpath 'c:\Windows\System32\');
  pushd $clip_path > /dev/null;
  ${clip_path}clip.exe < "${1:-/dev/stdin}";
  popd > /dev/null;
}

#function clip {
#  local clip_path=/mnt/c/Windows/System32/Clip.exe
#  local in=$1
#  [ ! -f ${clip_path} ] && echo "${clip_path} binary not found" && return 1
#  [ -z "$in" ] && in=`cat` # read everything from pipe stdin
#  #echo ${in} | tr '\n' '\r\n' | ${clip_path} # replace newline to windows format
#  echo ${in} | sed 's#\n$#\r\n#g' | ${clip_path} # replace newline to windows format
#}

# Mount Home dir of current Distro to be accessible from all Distro
# https://stackoverflow.com/questions/65815011/moving-files-between-different-wsl2-instances
function wsl_mount_home {
  local wsl_path=/mnt/c/Windows/System32/wsl.exe
  [ ! -f ${wsl_path} ] && echo "${wsl_path} binary not found" && return 1
  [ -z $WSL_DISTRO_NAME ] && echo "Proper WSL environment (env WSL_DISTRO_NAME) not found" && return 1
  local mount_path=/mnt/wsl/${WSL_DISTRO_NAME}_$(echo ${USER})
  if [[ "$(mount -l | grep "${mount_path}")" != '' ]]; then
    echo "Mount at ${mount_path} already exists" && return 1
  fi

  mkdir ${mount_path}
  echo "Mounting '$HOME' to ${mount_path}"
  ${wsl_path} -d "${WSL_DISTRO_NAME}" -u root mount --bind ${HOME} ${mount_path}
}
# ------------------- Export ----------------------
#export GOROOT="/usr/local/go/"
[[ "${PATH#*:/mnt/c/Users/mekram/AppData/Local/Programs/MicrosoftVSCode/bin}" == "$PATH" ]] && export PATH="$PATH:/mnt/c/Users/mekram/AppData/Local/Programs/MicrosoftVSCode/bin"
which winget &> /dev/null || ln -s /mnt/c/Users/mekram/AppData/Local/Microsoft/WindowsApps/winget.exe $HOME/.local/bin/winget
[[ "${PATH#*:$HOME/.dotnet/tools/}" == "$PATH" ]] && export PATH="$PATH:$HOME/.dotnet/tools/"
# WSL-X11 Specific Export
function setDisplay {
  export DISPLAY_OLD="${DISPLAY}"
  export DISPLAY=$(win-ip):0
}
export LIBGL_ALWAYS_INDIRECT=1
# Important for WSL to automatically open default browser 
export BROWSER=wslview

_k_help+=("Useful prog: trickle")
_k_help+=("Useful functions:")
_k_help+=("  wsl-ip : wsl2 network ip")
_k_help+=("  win-ip : windows virt network IP")
_k_help+=("  clip   : copy terminal buffer to clipboard")
_k_help+=("  update_keychain : add ssh keys to keychain")
_k_help+=("  update_clock    : synchronize clock with RTC")
_k_help+=("  wsl_mount_home  : mount home dir is current Distro")
_k_help+=("                    to be accessible from all distros")
_k_help+=("  Check wslu packages (wslview, wslvar etc)")
