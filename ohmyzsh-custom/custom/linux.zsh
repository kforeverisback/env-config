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
