#!/usr/bin/env zsh
#
# ZShell Configuration
# https://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter
autoload -U select-word-style
select-word-style bash
# Most flexible solution of
#WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes
bindkey '^U' backward-kill-line
bindkey '^Y' yank
