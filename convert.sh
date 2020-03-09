#!/usr/bin/env bash
set -e

TEXTBUNDLES_DIR='textbundles'
IFS=$(echo -en "\n\b")

if [ -x "$(command -v python3.8)" ]; then
  PYTHON='python3.8'
elif [ -x "$(command -v python3)" ]; then
  PYTHON='python3'
else
  PYTHON='python'
fi

for b in $(ls $TEXTBUNDLES_DIR); do
  $PYTHON convert_textbundle.py "$TEXTBUNDLES_DIR/$b"
done
