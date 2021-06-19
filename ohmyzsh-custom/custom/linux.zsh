# Kushal: For OpenSSH Agent on WSL: https://esc.sh/blog/ssh-agent-windows10-wsl2/
# https://blog.kylemanna.com/linux/use-funtoos-keyhain-insetad-of-gnome-keyring/
alias rgv='rg -v "rg " | rg'
update_keychain() {
  if ! command -v keychain &> /dev/null; then
    echo "'keychain' not found in system."
  else
    timeout=180 # Default
    [[ -z "$1" ]] || timeout=$1
    echo 'Starting ssh-agent via keychain'
    echo SSH-Agent timeout: ${timeout} minute(s)
    #if [[ $(pgrep -a ssh-agent | sed 's/^.*-t //g') -ne $(( timeout * 60 )) ]];
    #then
    #  keychain -q -k all
    #fi
    keychain -q --nogui --timeout ${timeout} $HOME/.ssh/id_rsa $HOME/.ssh/github-key-ms
    source $HOME/.keychain/$HOST-sh
  fi
}
_k_help+="Use update_keychain to add keys to ssh-agent"
