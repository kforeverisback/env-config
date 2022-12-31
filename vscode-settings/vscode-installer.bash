#!/usr/bin/env bash

[[ -z $BUILD ]] && BUILD=insider || BUILD=$(echo "$BUILD" | tr '[:upper:]' '[:lower:]')
[[ -z $CODE_DIR ]] && CODE_DIR="/opt/microsoft" && [[ $(id -u) -gt 0 ]] && echo "$0 needs sudo to write to $CODE_DIR" && exit 1

url="https://code.visualstudio.com/sha/download?build=${BUILD}&os=linux-x64"

echo "Using VSCode URL: $url"

code_tmp_dir=$(mktemp -d)
wget -c "$url" -O- | tar -xz -C "$code_tmp_dir"

code_parent_dir="$CODE_DIR/VSCode-linux-x64"

[[ -d "$code_parent_dir" ]] && rm -r "$code_parent_dir"
mkdir -p "$CODE_DIR"
mv "$code_tmp_dir/VSCode-linux-x64" "$CODE_DIR/"

bin_names=("$code_parent_dir/bin/code" "$code_parent_dir/bin/code-insiders")
for i in "${bin_names[@]}"; do
    if [[ -f "$i" ]];then
        echo "Bin: $i"
        ln -sf "$i" /usr/local/bin/code
        ln -sf "$code_parent_dir" "$CODE_DIR/$(basename $i)"
    fi
done
