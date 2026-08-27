#!/bin/bash
# aws-user-data.sh — เทมเพลต EC2 user-data สำหรับ 1 VM/คน
# วาง STUDENT_USER + STUDENT_PUBKEY ของแต่ละคนแล้ว paste ทั้งไฟล์นี้ลงช่อง
# "User data" ตอน launch instance (1 instance ต่อ 1 คน — แก้ค่า 2 ตัวนี้ทุกครั้งก่อน launch)
#
# ก่อน launch ต้องเตรียมแล้ว:
#   - AMI: Ubuntu Server LTS (22.04/24.04)
#   - Security group: เปิด inbound TCP 22 (SSH) และ TCP 3000 (Grafana)
#   - Instance type: t3.small ขึ้นไป (ดู scripts/provision-vm.sh)
#
# EC2 รัน user-data นี้เป็น root ตอน boot ครั้งแรกโดยอัตโนมัติ (cloud-init) — ไม่ต้อง
# ssh เข้าไปรันเอง ดู log ได้ที่ /var/log/claude-workshop-provision.log บน VM ถ้ามีปัญหา

set -euo pipefail

# ===== แก้ 2 ค่านี้ก่อน launch แต่ละเครื่อง =====
STUDENT_USER="student01"
STUDENT_PUBKEY="ssh-ed25519 AAAA... เปลี่ยนเป็น public key จริงของคนนี้"
# ================================================

REPO_URL="https://github.com/NaiRoBin/claude-code-workshop.git"
REPO_DIR="/opt/claude-code-workshop"
LOG_FILE="/var/log/claude-workshop-provision.log"

exec > >(tee -a "$LOG_FILE") 2>&1
echo "==> [$(date)] เริ่ม provision สำหรับ $STUDENT_USER"

echo "==> ติดตั้ง git (repo เป็น public ไม่ต้อง auth)"
apt-get update -y
apt-get install -y git

echo "==> clone workshop repo"
if [ ! -d "$REPO_DIR" ]; then
  git clone --depth 1 "$REPO_URL" "$REPO_DIR"
fi

echo "==> วาง public key ของ $STUDENT_USER"
mkdir -p "$REPO_DIR/scripts/pubkeys"
echo "$STUDENT_PUBKEY" > "$REPO_DIR/scripts/pubkeys/$STUDENT_USER.pub"

echo "==> รัน provision-vm.sh"
cd "$REPO_DIR/scripts"
bash provision-vm.sh "$STUDENT_USER"

echo "==> [$(date)] provision เสร็จสำหรับ $STUDENT_USER — ตรวจด้วย: ssh เข้าไปรัน bash verify-vm.sh"
