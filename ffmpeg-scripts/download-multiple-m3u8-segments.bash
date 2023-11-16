#!/bin/bash

usage () {
    echo "$0 <URL_FILE> <FILE_INDEX> <OUT_DIR>"
    echo "Params:
    URL_FILE    - file containing list of index.m3u8 links
    FILE_INDEX  - starting file index to download in 'URL_FILE'
    OUT_DIR     - output directory to download m3u8 segments to.
    "
    echo "Params can also be specified using environment variables of the same name."
}

URL_FILE=$1
FILE_INDEX=$2
OUT_DIR=$3

[[ -z "$URL_FILE" || ! -f "$URL_FILE" ]] && >&2 echo "'m3u8' URL file not found." && usage && exit 1
[[ -z "$FILE_INDEX" ]] && FILE_INDEX=1
[[ -z "$OUT_DIR" ]] && OUT_DIR="."

echo "Downloading TS files to: $OUT_DIR"
echo "Starting index: $FILE_INDEX"
sleep 3

if [[ -n "$NO_VERIFY_URL_FILE" ]]; then
    echo Aria2c will not verify the URL file.
fi

while IFS= read -r line
do
    [[ -z "$line" ]] && continue
    dir="$OUT_DIR/E$(printf '%02d' "$FILE_INDEX")"
    echo "Downloading: $line"
    mkdir -p "$dir"
    pushd "$dir" || (echo "pushd error" && exit)
    aria2c "$line"
    basefile=$(basename "$line")
    url=$(echo "$line" | sed "s/$basefile/{}/g")
    grep -v '#' "$basefile" | xargs -n1 -I{} echo "$url" > input
    # aria2c will download multiple files in parallel from "input" file, but it will only download one segment at a time
    # aria2c params: https://stackoverflow.com/questions/55166245/aria2c-parallel-download-parameters
    aria2c -Z -c -s 1 -j 5 -x 1 -k 1M --auto-file-renaming=false -i "input"
    FILE_INDEX=$((FILE_INDEX+1))
    popd || (echo "popd error" && exit)
done < <(cat "$URL_FILE")
