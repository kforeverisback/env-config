#!/usr/bin/env bash

[[ -z $BUILD ]] && BUILD=insider || BUILD=$(echo "$BUILD" | tr '[:upper:]' '[:lower:]')
[[ -z $CODE_DIR ]] && CODE_DIR="/opt/microsoft" && [[ $(id -u) -gt 0 ]] && echo "$0 needs sudo to write to $CODE_DIR" && exit 1

url="https://code.visualstudio.com/sha/download?build=${BUILD}&os=linux-x64"

echo "Using VSCode URL: $url"

code_tmp_dir=$(mktemp -d)
wget -c "$url" -O- | tar -xz -C "$code_tmp_dir"

code_parent_dir="$CODE_DIR/VSCode-linux-x64"
tmp_code_dir="$code_tmp_dir/VSCode-linux-x64"

[[ -d "$code_parent_dir" ]] && rm -r "$code_parent_dir"
mkdir -p "$code_parent_dir"
mv "$tmp_code_dir" "$code_parent_dir"

bin_names=("$code_parent_dir/VSCode-linux-x64/bin/code" "$code_parent_dir/VSCode-linux-x64/bin/code-insiders")
for i in "${bin_names[@]}"; do
    [[ -f "$i" ]] && ln -fns "$i" "/usr/local/bin/code"
done
