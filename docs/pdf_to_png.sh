#!/bin/bash

usage() {
    echo "Usage: $0 <filename.pdf>"
    echo "Converts a PDF file to PNG format"
    exit 1
}

[ $# -eq 0 ] && { echo "Error: No input file specified"; usage; }
[ ! -f "$1" ] && { echo "Error: File '$1' not found"; exit 1; }
[[ "$1" != *.pdf ]] && { echo "Error: Input must be a .pdf file"; usage; }
! command -v convert &> /dev/null && { echo "Error: ImageMagick not installed"; exit 1; }

convert -density 300 "$1" -background white -flatten -alpha off "${1%.pdf}.png" && \
    echo "Success: Created ${1%.pdf}.png" || \
    { echo "Error: Conversion failed"; exit 1; }