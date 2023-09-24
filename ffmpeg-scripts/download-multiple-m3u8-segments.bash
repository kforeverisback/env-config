#!/bin/bash

usage () {
    echo "$0 <URL_FILE> <INDEX> <OUT_DIR>"
    echo "URL File should consist of a list of index.m3u8 links"
}

URL_FILE=$1
INDEX_START=$2
OUT_DIR=$3

[[ -z "$URL_FILE" || ! -f "$URL_FILE" ]] && >&2 echo "URL file not found." && usage && exit 1
[[ -z "$INDEX_START" ]] && INDEX_START=1
[[ -z "$OUT_DIR" ]] && OUT_DIR="."

echo "Downloading TS files to: $OUT_DIR"
echo "Starting index: $INDEX_START"
sleep 3

while IFS= read -r line
do
    [[ -z "$line" ]] && continue
    dir="$OUT_DIR/E$(printf '%02d' "$INDEX_START")"
    echo "Downloading: $line"
    mkdir -p "$dir"
    pushd "$dir" || (echo "pushd error" && exit)
    aria2c "$line"
    basefile=$(basename "$line")
    url=$(echo "$line" | sed "s/$basefile/{}/g")
    grep -v '#' "$basefile" | xargs -n1 -I{} echo "$url" > input
    # aria2c params: https://stackoverflow.com/questions/55166245/aria2c-parallel-download-parameters
    aria2c -Z -c -s 1 -j 5 -x 1 -k 1M --auto-file-renaming=false -i input
    INDEX_START=$((INDEX_START+1))
    popd || (echo "popd error" && exit)
done < <(cat "$URL_FILE")
