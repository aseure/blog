#!/usr/bin/env bash
set -e

TEXTBUNDLES_DIR='textbundles'
IFS=$(echo -en "\n\b")

for b in $(ls $TEXTBUNDLES_DIR); do
  python3 convert_textbundle.py "$TEXTBUNDLES_DIR/$b"
done

hugo
