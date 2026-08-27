#!/usr/bin/env bash
# สร้างไฟล์ .pptx (ข้อความแก้ไขได้) จากสไลด์ Marp ทุกเด็คในโฟลเดอร์นี้
# ต้องมี pandoc (ถ้าไม่มีในเครื่อง ดูวิธีลง user-level ที่ท้ายไฟล์)
#
# ใช้งาน:  bash slides/build-pptx.sh
set -euo pipefail

cd "$(dirname "$0")"
export PATH="$HOME/.local/bin:$PATH"

if ! command -v pandoc >/dev/null; then
  echo "ไม่พบ pandoc — ติดตั้ง user-level (ไม่ต้อง admin):"
  echo "  curl -sL https://github.com/jgm/pandoc/releases/download/3.10.2/pandoc-3.10.2-linux-amd64.tar.gz | tar xz -C /tmp"
  echo "  mkdir -p ~/.local/bin && cp /tmp/pandoc-3.10.2/bin/pandoc ~/.local/bin/ && chmod +x ~/.local/bin/pandoc"
  exit 1
fi

# เด็คที่จะแปลง (ไฟล์ Marp เท่านั้น — ไม่รวม README.md/cheatsheet.md)
DECKS=(00-overview 01-windows-setup 02-basics 03-skills 04-use-case 05-capstone 06-wrapup slides)

for d in "${DECKS[@]}"; do
  src="$d.md"
  [ -f "$src" ] || { echo "ข้าม $src (ไม่พบ)"; continue; }
  tmp="$(mktemp --suffix=.md)"
  # ปรับ Marp -> pandoc: ตัด frontmatter, ตัด directive/usage comment,
  # แปลง presenter-note comment เป็น speaker notes, ตัดเส้นคั่น ---
  perl -0777 -pe '
    s/^---\n.*?\n---\n//s;
    s/<!--\s*_class:[^>]*-->//gs;
    s/<!--.*?marp-team.*?-->//gs;
    s/<!--(.*?)-->/\n\n::: notes\n$1\n:::\n\n/gs;
  ' "$src" > "$tmp"
  perl -i -ne 'print unless /^---\s*$/' "$tmp"

  title="$(grep -m1 '^title:' "$src" | sed -E 's/^title:\s*"?([^"]*)"?\s*$/\1/')"
  [ -n "$title" ] || title="$d"

  pandoc "$tmp" -t pptx --slide-level=2 -M title="$title" -o "$d.pptx"
  rm -f "$tmp"
  echo "✓ $d.pptx"
done

echo "เสร็จ — ได้ไฟล์ .pptx ในโฟลเดอร์ slides/"
