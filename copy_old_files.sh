#!/usr/bin/env bash

set -euo pipefail

usage() {
    echo "Usage: $0 -s SOURCE_DIR -d DEST_DIR -D CUTOFF_DATE [-r]"
    echo ""
    echo "  -s SOURCE_DIR    Directory to copy files from"
    echo "  -d DEST_DIR      Directory to copy files to"
    echo "  -D CUTOFF_DATE   Copy files older than this date (format: YYYY-MM-DD)"
    echo "  -r               Recurse into subdirectories (optional)"
    echo ""
    echo "Example: $0 -s /data/logs -d /archive/logs -D 2025-01-01"
    exit 1
}

SOURCE=""
DEST=""
CUTOFF_DATE=""
RECURSIVE=false

while getopts "s:d:D:r" opt; do
    case $opt in
        s) SOURCE="$OPTARG" ;;
        d) DEST="$OPTARG" ;;
        D) CUTOFF_DATE="$OPTARG" ;;
        r) RECURSIVE=true ;;
        *) usage ;;
    esac
done

# Validate required arguments
[[ -z "$SOURCE" || -z "$DEST" || -z "$CUTOFF_DATE" ]] && usage

# Validate source directory
if [[ ! -d "$SOURCE" ]]; then
    echo "Error: Source directory '$SOURCE' does not exist." >&2
    exit 1
fi

# Validate date format
if ! date -d "$CUTOFF_DATE" &>/dev/null 2>&1; then
    echo "Error: Invalid date '$CUTOFF_DATE'. Use YYYY-MM-DD format." >&2
    exit 1
fi

# Create destination directory if it doesn't exist
mkdir -p "$DEST"

# Build find command
FIND_ARGS=("$SOURCE")
if [[ "$RECURSIVE" == false ]]; then
    FIND_ARGS+=(-maxdepth 1)
fi
FIND_ARGS+=(-type f ! -newer "$CUTOFF_DATE" ! -name "$(basename "$0")")

echo "Copying files from '$SOURCE' older than '$CUTOFF_DATE' to '$DEST'..."
echo ""

COUNT=0
while IFS= read -r -d '' file; do
    # Preserve relative directory structure when recursive
    if [[ "$RECURSIVE" == true ]]; then
        rel_path="${file#$SOURCE/}"
        dest_file="$DEST/$rel_path"
        mkdir -p "$(dirname "$dest_file")"
    else
        dest_file="$DEST/$(basename "$file")"
    fi

    echo "  Copying: $file -> $dest_file"
    cp -p "$file" "$dest_file"
    (( COUNT++ )) || true
done < <(find "${FIND_ARGS[@]}" -print0)

echo ""
echo "Done. $COUNT file(s) copied."
