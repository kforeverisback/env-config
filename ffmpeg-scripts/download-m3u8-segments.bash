#!/bin/bash

usage() {
	echo "$0 <INDEX_URL> <OUT_DIR>"
	echo "Params:
  INDEX_URL   - URL pointing to an m3u8 file.
                The link would serve as a base URL for downloading segments,
                unless the segments have full url
  OUT_DIR     - output directory to download m3u8 segments to.
  "
	echo "Params can also be specified using environment variables of the same name."
}

INDEX_URL=$1
OUT_DIR=$2

[[ -z "$INDEX_URL" ]] && >&2 echo "'m3u8' URL not provided." && usage && exit 1
[[ -z "$OUT_DIR" ]] && OUT_DIR="."

echo "Downloading TS/segment files to: $OUT_DIR"
sleep 3

if [[ -n "$NO_VERIFY_URL_FILE" ]]; then
	echo Aria2c will not verify the URL file.
fi

orig_index_file="aria2c-orig-abcd.m3u8"
mod_index_file="${orig_index_file/orig/mod}"
aria_dwnld_list="aria2c.download.list.abcd"
#orig_index_file="aria2c-orig-$RANDOM.m3u8"
#mod_index_file="${orig_index_file/orig/mod}"
#aria_dwnld_list="aria2c.list.$RANDOM"
echo "Orig m3u8: $orig_index_file, mod m3u8: $mod_index_file"
#aria2c -d "$(dirname $tmp_index_file)" "\"$INDEX_URL\"" --out="$(basename $tmp_index_file)"
echo aria2c "$INDEX_URL" -d "$OUT_DIR" --out="$orig_index_file"
mkdir -p "$OUT_DIR"
aria2c "$INDEX_URL" -d "$OUT_DIR" --out="$orig_index_file"

base_url=$(basename "$INDEX_URL")
echo Base Url: $base_url
valid_url_regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
while IFS= read -r line; do
	[[ -z "$line" ]] && continue
	if (grep -oE '^#.*' <<<$line >/dev/null); then
		# Its a # EXT line, not real segment link
		echo "$line" >>"$OUT_DIR/$mod_index_file"
		continue
	else
		# Its a segment link/name
		# Now check if its a full URL
		if [[ $line =~ $regex ]]; then
			echo "Link valid"
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
aria2c -Z -c -s 1 -j 5 -x 1 -k 1M --auto-file-renaming=false -d "$OUT_DIR" -i "$OUT_DIR/$aria_dwnld_list"
