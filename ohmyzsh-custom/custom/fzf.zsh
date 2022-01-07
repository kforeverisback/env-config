# Enable fzf if available

[[ $(hash fzf) != '' ]] && echo "fzf Not found in system" && return
zzz=/usr/share/doc/fzf/examples/key-bindings.zsh && [[ -f $zzz ]] && source $zzz
zzz=/usr/share/doc/fzf/examples/completion.zsh && [[ -f $zzz ]] && source $zzz
unset zzz
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# # command for listing path candidates.
# # - The first argument to the function ($1) is the base path to start traversal
# # - See the source code (completion.{bash,zsh}) for the details.
function _fzf22_compgen_path {
  fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
function _fzf22_compgen_dir {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
