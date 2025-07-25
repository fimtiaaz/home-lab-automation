# 🔐 Backup & Restore Scripts

This folder contains scripts for backing up critical system files and restoring them if needed.

## 🧩 Files

- `backup.sh`: Creates compressed backups of:
  - `/etc`
  - `/home/fimtiaz`
  - `/var/log`
- `restore.sh`: Restores from the latest archive in `/archive`

## 📂 Folders

- `logs/`: Logs for each backup
- `archive/`: Timestamped `.tar.gz` backup files

## 🛠 Usage

```bash
./backup.sh      # Run backup
./restore.sh     # Restore from latest backup (asks for confirmation)

