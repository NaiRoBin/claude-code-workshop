#!/usr/bin/env bash
# provision-vm.sh — เตรียม Linux VM สำหรับทั้งวัน (รันด้วย sudo บน Ubuntu LTS)
# VM เป็น workspace หลักตั้งแต่ lab/02 (basics) ถึง lab/05 (capstone) — Claude Code เอง
# รันอยู่บน Windows notebook ของผู้เรียนและสั่งงานเข้ามาที่ VM นี้ผ่าน `ssh myvm "..."`
# ไม่ได้ติดตั้ง Postgres/Grafana ที่นี่ — ปล่อยให้ Claude Code เป็นคนติดตั้งในคลาสเพื่อโชว์
# ความสามารถ agentic (แต่เตรียม apt/tools ให้พร้อม)
#
# วิธีใช้:
#   sudo bash provision-vm.sh "student01 student02 student03"
#   (พารามิเตอร์ = รายชื่อ user ผู้เรียน คั่นด้วยช่องว่าง)
set -euo pipefail

STUDENTS="${1:-student01}"
PUBKEY_DIR="${PUBKEY_DIR:-./pubkeys}"   # วาง <user>.pub ไว้ในโฟลเดอร์นี้ (1 ไฟล์/คน)

echo "==> อัปเดต apt + ติดตั้ง base tools"
apt-get update -y
apt-get install -y curl ca-certificates gnupg git build-essential ufw

echo "==> ติดตั้ง Node.js LTS (system-wide) ผ่าน NodeSource"
# Node นี้ใช้รัน sample-project (lab/02, node --test) และ mock server (lab/05) บน VM
# ไม่เกี่ยวกับ Claude Code — Claude Code รันบน Windows notebook ของผู้เรียน ไม่ใช่บน VM
if ! command -v node >/dev/null 2>&1; then
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
  apt-get install -y nodejs
fi
node -v

echo "==> เตรียม repo/GPG ให้พร้อมสำหรับ Grafana (ให้ Claude Code ติดตั้งจริงในคลาส)"
mkdir -p /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/grafana.gpg ]; then
  curl -fsSL https://apt.grafana.com/gpg.key | gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
  echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" \
    > /etc/apt/sources.list.d/grafana.list
  apt-get update -y || true
fi

echo "==> เปิด openssh-server"
apt-get install -y openssh-server
systemctl enable --now ssh

echo "==> สร้าง user ผู้เรียน + วาง public key + home 700"
for u in $STUDENTS; do
  if ! id "$u" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" "$u"
  fi
  # ให้ sudo ได้ (จำเป็นสำหรับ capstone ติดตั้ง DB/Grafana) — NOPASSWD เพื่อ non-interactive ssh
  usermod -aG sudo "$u"
  echo "$u ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/90-$u"
  chmod 440 "/etc/sudoers.d/90-$u"

  install -d -m 700 -o "$u" -g "$u" "/home/$u/.ssh"
  if [ -f "$PUBKEY_DIR/$u.pub" ]; then
    install -m 600 -o "$u" -g "$u" "$PUBKEY_DIR/$u.pub" "/home/$u/.ssh/authorized_keys"
  else
    echo "   [!] ไม่พบ $PUBKEY_DIR/$u.pub — ต้องวาง public key เองภายหลัง"
  fi
  chmod 700 "/home/$u"

  # คัดลอกโปรเจกต์ตัวอย่างไว้ให้ผู้เรียนใช้ใน lab/02 (basics)
  install -d -o "$u" -g "$u" "/home/$u/cc-basics"
  if [ -d "../sample-project" ]; then
    cp -r ../sample-project/* "/home/$u/cc-basics/" 2>/dev/null || true
    chown -R "$u:$u" "/home/$u/cc-basics"
  fi

  # คัดลอก mock ServiceDesk Plus ไว้ให้ผู้เรียนใช้เป็น fallback ใน lab/05
  install -d -o "$u" -g "$u" "/home/$u/servicedesk-mock"
  if [ -d "./servicedesk-mock" ]; then
    cp ./servicedesk-mock/* "/home/$u/servicedesk-mock/" 2>/dev/null || true
    chown -R "$u:$u" "/home/$u/servicedesk-mock"
  fi
done

echo "==> เสร็จ. ตรวจด้วย: bash verify-vm.sh"
