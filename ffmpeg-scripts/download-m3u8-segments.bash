#!/bin/bash
shopt -os nounset pipefail errexit errtrace
usage() {
  echo "$0 <INDEX_URL> <OUT_FILE> <SEGMENTS_OUT_DIR> <RM_SEGMENTS>
Params:
      INDEX_URL        - URL pointing to an m3u8 file.
                       The link would serve as a base URL for downloading segments,
                       unless the segments have full url
      OUT_FILE         - If set, in addition to downloading segment files,
                       an OUT_FILE file will be created from the segments.
      SEGMENTS_OUT_DIR - output directory to download m3u8 segments to.
			     	           Default: /tmp/segments-\$RANDOM.
      RM_SEGMENTS      - If set, will remove the downloaded segments after creating OUT_FILE.
				               Default: not set.
      PARALLEL_FILES   - Number of parallel segments to download
"
  echo "Params can also be specified using environment variables of the same name."
}
set +u # Don't check for unbound variables
INDEX_URL="${1:-$INDEX_URL}"
OUT_FILE="${2:-$OUT_FILE}"
SEGMENTS_OUT_DIR="${3:-$SEGMENTS_OUT_DIR}"
RM_SEGMENTS="${4:-$RM_SEGMENTS}"
PARALLEL_FILES="${5:-$PARALLEL_FILES}"
set -u

[[ -z "$INDEX_URL" ]] && >&2 echo "'m3u8' URL not provided." && usage && exit 1
[[ -z "$SEGMENTS_OUT_DIR" ]] && SEGMENTS_OUT_DIR="/tmp/segments-$(basename "$OUT_FILE")-$(md5sum <<<"$INDEX_URL" | head -c 32)"
[[ -z "$OUT_FILE" ]] && >&2 echo "Output file not provided." && usage && exit 1
[[ -z "$RM_SEGMENTS" ]] && RM_SEGMENTS=""
[[ -z "$PARALLEL_FILES" ]] && PARALLEL_FILES="5"
# No quotes on regex in a script!!
if [[ -z $OUT_FILE ]] || ! [[ $OUT_FILE =~ .*\.(mp4|mkv|mp3) ]]; then
  >&2 echo "Specify an output file with mp4|mkv extension"
  exit 1
fi

orig_index_file="aria2c-orig.m3u8"
mod_index_file="${orig_index_file/orig/mod}"
aria_dwnld_list="aria2c.download.list"
#orig_index_file="aria2c-orig-$RANDOM.m3u8"
#mod_index_file="${orig_index_file/orig/mod}"
#aria_dwnld_list="aria2c.list.$RANDOM"
# echo "Following files will be created/replaced:
#    orig m3u8: $orig_index_file
#     mod m3u8: $SEGMENTS_OUT_DIR/$mod_index_file
#   dwnld list: $SEGMENTS_OUT_DIR/$aria_dwnld_list"
echo "Downloading segment files to: $SEGMENTS_OUT_DIR"
echo "Output file: $OUT_FILE"

sleep 3
/bin/rm -f "$SEGMENTS_OUT_DIR/$orig_index_file"
/bin/rm -f "$SEGMENTS_OUT_DIR/$mod_index_file"
/bin/rm -f "$SEGMENTS_OUT_DIR/$aria_dwnld_list"
set -e
mkdir -p "$SEGMENTS_OUT_DIR"
mkdir -p "$(dirname "$OUT_FILE")"
#aria2c -d "$(dirname $tmp_index_file)" "\"$INDEX_URL\"" --out="$(basename $tmp_index_file)"
# echo aria2c "$INDEX_URL" -d "$SEGMENTS_OUT_DIR" --out="$orig_index_file"
aria2c "$INDEX_URL" -d "$SEGMENTS_OUT_DIR" --console-log-level=warn --out="$orig_index_file" --download-result=hide
echo
base_url=$(dirname "$INDEX_URL")
echo "Base m3u8 Url: ${base_url}"
valid_url_regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if (grep -oE '^#.*' <<<"$line" >/dev/null); then
    # Its a # EXT line, not real segment link
    echo "$line" >>"$SEGMENTS_OUT_DIR/$mod_index_file"
    continue
  else
    # Its a segment link/name
    # Now check if its a full URL
    if [[ $line =~ $valid_url_regex ]]; then
      # echo "Link valid"
      # only output the base-file-name
      segment_name_out="$(basename "$line")"
      segment_url="$line"
    else
      # Its not a full url, but just a filename
      segment_name_out="$line"
      segment_url="${base_url}/${line}"
    fi
    echo "$segment_name_out" >>"$SEGMENTS_OUT_DIR/$mod_index_file"
    echo "$segment_url" >>"$SEGMENTS_OUT_DIR/$aria_dwnld_list"
  fi
  #continue
done <"$SEGMENTS_OUT_DIR/$orig_index_file"

# aria2c will download multiple files in parallel from "input" file, but it will only download one segment at a time
# aria2c params: https://stackoverflow.com/questions/55166245/aria2c-parallel-download-parameters
aria2c -Z -c -s 1 -j $PARALLEL_FILES -x 1 -k 1M --console-log-level=warn --auto-file-renaming=false -d "$SEGMENTS_OUT_DIR" -i "$SEGMENTS_OUT_DIR/$aria_dwnld_list" --download-result=hide
echo
if [[ -n "$OUT_FILE" ]]; then
  echo "Running FFmpeg (output: $OUT_FILE)"
  ffmpeg -hide_banner -loglevel error -protocol_whitelist file,http,https,tcp,tls,crypto -allowed_extensions ALL -i "$SEGMENTS_OUT_DIR/$mod_index_file" -c copy "$OUT_FILE"
fi

if [[ -n "$RM_SEGMENTS" ]]; then
  echo "Removing $SEGMENTS_OUT_DIR"
  /bin/rm -rf "$SEGMENTS_OUT_DIR"
fi
