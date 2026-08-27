#!/bin/bash
# aws-user-data.sh — เทมเพลต EC2 user-data สำหรับ 1 VM/คน
# ทั้งคลาสใช้ SSH key เดียวกัน (1 EC2 key pair ตัวเดียว สร้างครั้งเดียวก่อนวันอบรม) —
# STUDENT_PUBKEY ด้านล่างจะเป็นค่า**เดียวกันทุกเครื่อง** แก้แค่ STUDENT_USER ทุกครั้งก่อน
# launch แต่ละเครื่อง (1 instance ต่อ 1 คน) แล้ว paste ทั้งไฟล์นี้ลงช่อง "User data"
#
# ก่อน launch ต้องเตรียมแล้ว:
#   - AMI: Ubuntu Server LTS (22.04/24.04)
#   - Security group: เปิด inbound TCP 22 (SSH) และ TCP 3000 (Grafana)
#   - Instance type: t3.small ขึ้นไป (ดู scripts/provision-vm.sh)
#   - EC2 key pair 1 ตัวสำหรับทั้งคลาส — ดึง public key ด้วย
#     `ssh-keygen -y -f workshop-key.pem` แล้วเอามาใส่ STUDENT_PUBKEY ด้านล่าง
#     (ค่าเดียวกันทุกเครื่อง ไม่ต้องเปลี่ยนต่อคน) — แจก .pem ตัวเดียวกันนี้ให้ผู้เรียนทุกคน
#     ก่อนวันอบรม (ดู instructor/pre-class-checklist.md)
#
# EC2 รัน user-data นี้เป็น root ตอน boot ครั้งแรกโดยอัตโนมัติ (cloud-init) — ไม่ต้อง
# ssh เข้าไปรันเอง ดู log ได้ที่ /var/log/claude-workshop-provision.log บน VM ถ้ามีปัญหา

set -euo pipefail

# ===== STUDENT_PUBKEY เหมือนกันทุกเครื่อง — แก้แค่ STUDENT_USER ก่อน launch แต่ละครั้ง =====
STUDENT_USER="student01"
STUDENT_PUBKEY="ssh-ed25519 AAAA... เปลี่ยนเป็น public key ของ EC2 key pair ตัวเดียวที่ใช้ทั้งคลาส"
# ==========================================================================================

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
