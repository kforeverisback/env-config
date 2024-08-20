#!/bin/bash
shopt -os nounset pipefail errexit errtrace
__DEFAULT_FILE_INDEX=1
__DEFAULT_FILE_OUT_DIR="/var/tmp"
__DEFAULT_SLEEP_IN_BETWEEN=60
usage() {
  echo "$0 <URL_FILE> <FILE_NAME_PREFIX> [SLEEP_IN_BETWEEN] [FILE_INDEX] [FILE_OUT_DIR]"
  echo "Params:
    URL_FILE    - file containing list of m3u8 links (required)
    FILE_NAME_PREFIX - output name prefix (required)
    FILE_INDEX  - starting file index to download in 'URL_FILE' (default: $__DEFAULT_FILE_INDEX)
    FILE_OUT_DIR     - output directory to download m3u8 segments to (default: $__DEFAULT_FILE_OUT_DIR).
    SLEEP_IN_BETWEEN - Sleep (sec) in between each link download (default: $__DEFAULT_SLEEP_IN_BETWEEN seconds)
    "
  echo "Params can also be specified using environment variables of the same name."
}

URL_FILE="$1"
FILE_NAME_PREFIX="$2"
FILE_INDEX="$3"
FILE_OUT_DIR="$4"

[[ -z "$FILE_INDEX" ]] && FILE_INDEX="$__DEFAULT_FILE_INDEX"
[[ -z "$SLEEP_IN_BETWEEN" ]] && SLEEP_IN_BETWEEN="$__DEFAULT_SLEEP_IN_BETWEEN"
[[ -z "$FILE_OUT_DIR" ]] && FILE_OUT_DIR="$__DEFAULT_FILE_OUT_DIR"
_script_dir=$(dirname $0)

[[ -z "$URL_FILE" || ! -f "$URL_FILE" ]] && >&2 echo "'m3u8' URL file not found." && usage && exit 1
[[ -z "$FILE_NAME_PREFIX" ]] && >&2 echo "Provide a file name prefix for output" && usage && exit 1

echo "URL list: $URL_FILE"
echo "Each m3u8 file output prefix: $FILE_NAME_PREFIX"
echo "Starting index: $FILE_INDEX"
#sleep 3

if [[ -n "$NO_VERIFY_URL_FILE" ]]; then
  echo Aria2c will not verify the URL file.
fi

declare -a urls=($(cat "$URL_FILE"))
for line in "${urls[@]}"; do
  [[ -z "$line" ]] && continue
  filename="$FILE_NAME_PREFIX.E$(printf '%02d' "$FILE_INDEX")"
  output_ext="mp4"
  dir="$FILE_OUT_DIR/$filename"
  echo "Downloading: $line"
  echo "  to $dir"
  export INDEX_URL="$line"
  export OUT_DIR="$dir"
  export OUT_FFMPEG_FILE="${filename}.${output_ext}"
  "$_script_dir/download-m3u8-segments.bash"
  FILE_INDEX=$((FILE_INDEX + 1))
  echo "Sleeping for $SLEEP_IN_BETWEEN seconds" && sleep "$SLEEP_IN_BETWEEN"
done
