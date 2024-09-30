#!/bin/bash

usage () {
    echo "$0 <URL_FILE> <OUT_DIR> <FILE_INDEX> <NAME_PREFIX>"
    echo "Params:
    URL_FILE    - file containing list of index.m3u8 links
    OUT_DIR     - output directory for mp4 files.
    FILE_INDEX  - starting index value (default: 1)
    NAME_PREFIX - Prefix of each file name (deafult: E).
    "
    echo "Params can also be specified using environment variables of the same name."
}

# DEBUGGING
# /bin/rm -rf ./output
# /bin/rm -rf /tmp/segments-*

URL_FILE=${1:-urls}
OUT_DIR=${2:-output}
FILE_INDEX=${3:-1}
NAME_PREFIX=${4:-E}

[[ -z "$URL_FILE" ]] && >&2 echo "'m3u8' URL file not provided." && usage && exit 1

[[ -z "$URL_FILE" || ! -f "$URL_FILE" ]] && >&2 echo "'m3u8' URL file not found." && usage && exit 1
[[ -z "$FILE_INDEX" ]] && FILE_INDEX=1
[[ -z "$OUT_DIR" ]] && OUT_DIR="."

echo "Downloading files to : $OUT_DIR"
echo "Starting index       : $FILE_INDEX"
sleep 3

set -e
# for line in $(cat urls);do
# done
while IFS= read -r line
do
    [[ -z "$line" ]] && continue
    OUT_FILE="$OUT_DIR/${NAME_PREFIX}$(printf '%02d' "$FILE_INDEX").mp4"
    export OUT_FILE
    export INDEX_URL="$line"
    export RM_SEGMENTS="YES"
    echo "  m3u8: $INDEX_URL, output: $OUT_FILE"
    bash download-m3u8-segments.bash
    FILE_INDEX=$((FILE_INDEX+1))
done< <(cat urls)
