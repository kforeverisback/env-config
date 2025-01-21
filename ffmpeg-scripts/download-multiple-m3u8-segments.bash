#!/bin/bash

usage() {
  echo "$0 <URL_FILE> <OUT_DIR> <SLEEP_BETWEEN>"
  echo "
Params:
URL_FILE      - file containing list of index.m3u8 links
OUT_DIR       - output directory for mp4 files.
SLEEP_BETWEEN - sleep time between each output. Default: unset
"
  echo "Each line in the URL_FILE should have the format: <FILENAME><SPACE><INDEX_URL>
Do not put spaces in the file name.
Example url-file content:

Episode-01.mp4 https://example.com/index.m3u8
SomeFile.mp4 https://example.com/index2.m3u8
S01E01.mp4 https://example.com/index4.m3u8
S04E03.mp4 https://example.com/index6.m3u8
"
  echo "Params can also be specified using environment variables of the same name."
}

# DEBUGGING
/bin/rm -rf ./output
/bin/rm -rf /tmp/segments-*
_script_dir=$(dirname "$0")
URL_FILE=${1:-$URL_FILE}
OUT_DIR=${2:-$OUT_DIR}
SLEEP_BETWEEN=${3:-$SLEEP_BETWEEN}

[[ -z "$URL_FILE" || ! -f "$URL_FILE" ]] && >&2 echo "'m3u8' URL file not found." && usage && exit 1
[[ -z "$OUT_DIR" ]] && >&2 echo "'m3u8' URL file not found." && usage && exit 1

echo "Downloading files to : $OUT_DIR"

set -e
valid_url_regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
# for url_line in $(cat "$URL_FILE");
# done
mapfile -t files_n_urls <"$URL_FILE"
# exit
# while IFS= read -r url_line || [[ -n "$url_line" ]]
for url_line in "${files_n_urls[@]}"; do
  [[ -z "$url_line" ]] && continue
  echo "Processing: $url_line"
  file_name=$(echo "$url_line" | awk -F' ' '{print $1}')
  url=$(echo "$url_line" | awk -F' ' '{print $2}')
  if ! [[ $url =~ $valid_url_regex ]]; then
    echo "Invalid Index URL: $url" >&2
    continue
  fi
  OUT_FILE="$OUT_DIR/${file_name}"
  # export OUT_FILE
  # export INDEX_URL="$url"
  export RM_SEGMENTS="YES"
  echo "m3u8: $url, output: $OUT_FILE"
  "$_script_dir/download-m3u8-segments.bash" "$url" "$OUT_FILE"
  echo -e "Done: $OUT_FILE \n"
  [[ -n "$SLEEP_BETWEEN" ]] && sleep "$SLEEP_BETWEEN"
  FILE_INDEX=$((FILE_INDEX + 1))
done #<"$URL_FILE"
