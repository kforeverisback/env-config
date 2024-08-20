#!/bin/bash
shopt -os nounset pipefail errexit errtrace
usage() {
  echo "$0 <INDEX_URL> <OUT_FFMPEG_FILE> [OUT_DIR]
Params:
  INDEX_URL   - URL pointing to an m3u8 file.
                The link would serve as a base URL for downloading segments,
                unless the segments have full url
  OUT_FFMPEG_FILE  - If set, in addition to downloading segment files,
                an OUT_FFMPEG_FILE file will be created from the segments.
  OUT_DIR     - output directory to download m3u8 segments to.
  CONCURRENT_DOWNLOAD - number of concurrent download. default: 2
  "
  echo "Params can also be specified using environment variables of the same name."
}

INDEX_URL="${1:-$INDEX_URL}"
OUT_DIR="${3:-$OUT_DIR}"
OUT_FFMPEG_FILE="${2:-$OUT_FFMPEG_FILE}"
CONCURRENT_DOWNLOAD="${CONCURRENT_DOWNLOAD:-2}"

# No quotes on regex in a script!!
[[ $OUT_FFMPEG_FILE =~ .*\.(mp4|mkv) ]] || (>&2 echo "Specify an output file with mp4|mkv extension" && exit 1)
[[ -z "$INDEX_URL" ]] && >&2 echo "'m3u8' URL not provided." && usage && exit 1
[[ -z "$OUT_DIR" ]] && OUT_DIR="."
echo "Downloading TS/segment files to: $OUT_DIR"

orig_index_file="aria2c-orig.m3u8"
mod_index_file="${orig_index_file/orig/mod}"
aria_dwnld_list="aria2c.download.list"
#orig_index_file="aria2c-orig-$RANDOM.m3u8"
#mod_index_file="${orig_index_file/orig/mod}"
#aria_dwnld_list="aria2c.list.$RANDOM"
echo "Following files will be created/replaced:
   orig m3u8: $OUT_DIR/$orig_index_file
    mod m3u8: $OUT_DIR/$mod_index_file
  dwnld list: $OUT_DIR/$aria_dwnld_list"
[[ -n "$OUT_FFMPEG" ]] && echo "FFmpeg output file: $OUT_FFMPEG"

sleep 3
/bin/rm -f "$OUT_DIR/$orig_index_file"
/bin/rm -f "$OUT_DIR/$mod_index_file"
/bin/rm -f "$OUT_DIR/$aria_dwnld_list"
#aria2c -d "$(dirname $tmp_index_file)" "\"$INDEX_URL\"" --out="$(basename $tmp_index_file)"
echo aria2c "$INDEX_URL" -d "$OUT_DIR" --out="$orig_index_file"
mkdir -p "$OUT_DIR"
aria2c "$INDEX_URL" -d "$OUT_DIR" --out="$orig_index_file"

base_url=$(dirname "$INDEX_URL")
echo "Base m3u8 Url: ${base_url}"
valid_url_regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'

while IFS= read -r line; do
  [[ -z "$line" ]] && continue
  if (grep -oE '^#.*' <<<"$line" >/dev/null); then
    # Its a # EXT line, not real segment link
    echo "$line" >>"$OUT_DIR/$mod_index_file"
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
    echo "$segment_name_out" >>"$OUT_DIR/$mod_index_file"
    echo "$segment_url" >>"$OUT_DIR/$aria_dwnld_list"
  fi
  #continue
done < <(cat "$OUT_DIR/$orig_index_file")

# aria2c will download multiple files in parallel from "input" file, but it will only download one segment at a time
# aria2c params: https://stackoverflow.com/questions/55166245/aria2c-parallel-download-parameters
aria2c -Z -c -s 1 -j "$CONCURRENT_DOWNLOAD" -x 1 -k 1M --console-log-level=error --download-result=hide --auto-file-renaming=false -d "$OUT_DIR" -i "$OUT_DIR/$aria_dwnld_list"

if [[ -n "$OUT_FFMPEG_FILE" ]]; then
  echo "FFmpeg output file: $OUT_FFMPEG_FILE"
  ffmpeg -hide_banner -loglevel error -stats -protocol_whitelist file,http,https,tcp,tls,crypto -allowed_extensions ALL -i "$OUT_DIR/$mod_index_file" -c copy "$OUT_FFMPEG_FILE"
fi
