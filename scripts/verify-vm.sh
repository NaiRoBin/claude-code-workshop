#!/usr/bin/env bash
# verify-vm.sh — health check ของ VM ก่อนวันอบรม (รันบน VM)
# วิธีใช้: bash verify-vm.sh
set -uo pipefail

pass=0; fail=0
check() { # check "ชื่อ" "คำสั่ง"
  if eval "$2" >/dev/null 2>&1; then
    echo "  [OK]   $1"; pass=$((pass+1))
  else
    echo "  [FAIL] $1"; fail=$((fail+1))
  fi
}

echo "== ตรวจสอบ VM =="
check "node ใช้งานได้"              "command -v node"
check "npm ใช้งานได้"               "command -v npm"
check "git ใช้งานได้"               "command -v git"
check "ssh server ทำงาน"            "systemctl is-active ssh"
check "apt update ได้"              "sudo apt-get update -y"
check "sample-project พร้อม (lab/02)" "test -f ~/cc-basics/package.json"
check "servicedesk-mock พร้อม (lab/05)" "test -f ~/servicedesk-mock/mock-server.js"
check "Grafana apt repo พร้อม"      "test -f /etc/apt/sources.list.d/grafana.list"
check "พอร์ต 3000 ยังว่าง"          "! (ss -ltn | grep -q ':3000 ')"
check "ต่อออก api.anthropic.com"    "curl -sSf -o /dev/null https://api.anthropic.com/ || true"

echo "----------------------------------------"
echo "ผ่าน: $pass  |  ไม่ผ่าน: $fail"
[ "$fail" -eq 0 ] && echo "พร้อมสำหรับ lab 02-05 (VM คือ workspace หลักของทั้งวัน) ✅" || echo "มีข้อไม่ผ่าน — ดู lab/99-troubleshooting.md"
