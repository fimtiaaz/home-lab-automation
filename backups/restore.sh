#!/bin/bash

ARCHIVE_DIR="$(dirname "$0")/archive"
LATEST=$(ls -t "$ARCHIVE_DIR"/backup_*.tar.gz 2>/dev/null | head -n1)

if [ -z "$LATEST" ]; then
  echo "❌ No backup archive found in $ARCHIVE_DIR"
  exit 1
fi

echo "⚠️ This will extract $LATEST to the root of the system. Continue? [y/N]"
read CONFIRM
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    sudo tar -xzvf "$LATEST" -C /
    echo "✅ Restore complete from $LATEST"
else
    echo "❌ Aborted."
fi

