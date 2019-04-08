#!/usr/bin/env bash
set -e

function write_front_matter() {
  local filename=$1
  local title=$2
  cat <<- EOF > $filename
	---
	title: "$title"
	date: "$(date '+%F')"
	---
	EOF
}

function does_dir_exist() {
  if [ -d "$1" ]; then return 0; else return 1; fi
}

function get_extension() {
  echo "$1" | sed 's/.*\.\([^.]*$\)/\1/'
}

function url_encode() {
  echo "$1" | sed 's/ /%20/g'
}

if ! does_dir_exist bundles/; then
  exit 0
fi

for bundle_dir in bundles/*.textbundle; do
  bundle="$(basename "$bundle_dir")"
  bundle_md="$bundle_dir/text.markdown"
  bundle_assets_dir="$bundle_dir/assets"

  title="$(echo "$bundle" | cut -f 1 -d '.')"
  title_with_dashes="$(echo $title | sed 's/ /-/g')"

  post_dir="content/posts/$title_with_dashes"
  post_md="$post_dir/index.md"

  rm -rf $post_dir
  mkdir -p $post_dir

  write_front_matter "$post_md" "$title"
  cat "$bundle_md" >> "$post_md"

  if does_dir_exist "$bundle_assets_dir"; then
    i=0
    for bundle_asset_path in "$bundle_assets_dir"/*; do
      i=$((i+1))
      bundle_asset="$(basename "$bundle_asset_path")"
      extension="$(get_extension "$bundle_asset")"
      post_asset="image_$i.$extension"
      post_asset_path="$post_dir/$post_asset"
      bundle_asset_encoded="$(url_encode "$bundle_asset")"

      cp "$bundle_asset_path" "$post_asset_path"
      gsed -i "s/assets\/$bundle_asset_encoded/$post_asset/" "$post_md"
    done
  fi

done
