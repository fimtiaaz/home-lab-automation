#!/bin/bash

# === CONFIG ===
DATE=$(date +"%Y-%m-%d_%H-%M")
DEST_DIR="$(dirname "$0")/archive"
LOG_FILE="$(dirname "$0")/logs/backup_$DATE.log"
BACKUP_NAME="backup_$DATE.tar.gz"

# === DIRECTORIES TO BACKUP ===
TARGETS="/etc /home/fimtiaz /var/log"

# === CREATE DEST FOLDERS ===
mkdir -p "$DEST_DIR" "$(dirname "$LOG_FILE")"

# === EXECUTE BACKUP ===
echo "[$(date)] Starting backup..." | tee -a "$LOG_FILE"
tar --exclude="$(pwd)" --ignore-failed-read -czvf "$DEST_DIR/$BACKUP_NAME" $TARGETS &>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[$(date)] ✅ Backup successful: $BACKUP_NAME" | tee -a "$LOG_FILE"
else
    echo "[$(date)] ❌ Backup failed!" | tee -a "$LOG_FILE"
fi

