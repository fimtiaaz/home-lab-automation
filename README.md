Home Lab Automation Project

This project automates the setup of a local Linux-based home lab using Prometheus, Grafana, Node Exporter, Docker Compose, Ansible, and a custom backup/restore system.

---

## 📁 Project Structure

```bash
home-lab-automation/
├── ansible/
│   ├── docker.yml              # Installs Docker & Compose
│   ├── inventory               # Hosts file for Ansible
│   ├── node_exporter.yml       # Installs Node Exporter
│   ├── setup.yml               # Installs EPEL and base packages
│   └── playbooks/              # (Empty or placeholder)
│
├── backups/
│   ├── archive/                # Stores compressed .tar.gz backups
│   │   └── backup_<timestamp>.tar.gz
│   ├── logs/                   # Stores backup logs
│   │   └── backup_<timestamp>.log
│   ├── backup.sh               # Backup automation script
│   ├── restore.sh              # Restore script (coming soon)
│   └── README.md               # Notes on backup usage
│
├── monitoring/
│   ├── docker-compose.yml      # Deploys Prometheus + Grafana
│   └── prometheus.yml          # Prometheus scrape config
```

Phase 1: Monitoring Stack with Docker Compose
▶️ Services Deployed
Prometheus - Time series database for metrics

Grafana - Visualization dashboard

Node Exporter - System metrics exporter for Prometheus

docker-compose.yml

version: '3.8'
```bash
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    container_name: grafana
    ports:
      - "3000:3000"
```

prometheus.yml
```bash
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node'
    static_configs:
      - targets: ['192.168.8.171:9100']
```
Phase 2: Ansible Automation
Playbooks
setup.yml – Installs base tools and EPEL

docker.yml – Installs Docker & adds user to docker group

node_exporter.yml – Downloads, extracts, and configures node_exporter as a systemd service

inventory
```bash
localhost ansible_connection=local
```
▶️ Run Example
```bash
ansible-playbook -i inventory setup.yml
ansible-playbook -i inventory docker.yml
ansible-playbook -i inventory node_exporter.yml
```

Phase 3: Backup & Restore System
Features
Archives /etc, /home/fimtiaz, and /var/log daily

Stores .tar.gz files under backups/archive/

Logs all activity to backups/logs/

backup.sh
```bash
#!/bin/bash

DATE=$(date +"%Y-%m-%d_%H-%M")
DEST_DIR="$(dirname "$0")/archive"
LOG_FILE="$(dirname "$0")/logs/backup_$DATE.log"
BACKUP_NAME="backup_$DATE.tar.gz"
TARGETS="/etc /home/fimtiaz /var/log"

mkdir -p "$DEST_DIR" "$(dirname "$LOG_FILE")"
echo "[$(date)] Starting backup..." | tee -a "$LOG_FILE"

tar --exclude="$(dirname "$0")" --ignore-failed-read \
  -czvf "$DEST_DIR/$BACKUP_NAME" $TARGETS &>> "$LOG_FILE"

if [ $? -eq 0 ]; then
  echo "[$(date)] ✅ Backup successful: $BACKUP_NAME" | tee -a "$LOG_FILE"
else
  echo "[$(date)] ❌ Backup failed!" | tee -a "$LOG_FILE"
fi
```

Add to Crontab (Daily at 2AM)

crontab -e
```bash
0 2 * * * /home/fimtiaz/LinuxProjects/home-lab-automation/backups/backup.sh
```
Accessing the Monitoring Stack
Prometheus: http://localhost:9090

Grafana: http://localhost:3000 (Default login: admin / admin)

Requirements
OS: RHEL/CentOS 7/8 (or compatible)

Tools:

Ansible

Docker & Docker Compose

Cron

Bash

Author
Fimtiaz — Linux Admin 


