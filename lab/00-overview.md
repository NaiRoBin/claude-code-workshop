# Lab 00 — ภาพรวม

## เราจะเรียนอะไรวันนี้
1. **ติดตั้ง Claude Code บน Windows** (ไม่ต้องมี admin) แล้วใช้งานจริง
2. **พื้นฐาน Claude Code** — สั่งงาน, แก้ไฟล์, รันคำสั่ง, git, plan mode
3. **Skills (หลัก)** — ติดตั้ง skill จาก GitHub และสร้างเอง
4. **Use case จริง (หลัก)** — ใช้ Claude Code สร้างโปรเจกต์ตั้งแต่ต้นจนจบ (แบบเดียวกับที่สร้าง workshop นี้)
5. **(Optional) Capstone** — SSH ไป Linux VM แล้วให้ Claude Code ติดตั้ง DB/Grafana + ดึงข้อมูล Ivanti

## สิ่งที่ต้องมี
- Windows notebook (ไม่ต้องมี admin) + เน็ตต่อออกอินเทอร์เน็ตได้
- `ANTHROPIC_API_KEY` (ผู้สอนแจกหน้างาน)
- (เฉพาะ optional capstone) ข้อมูลเข้า VM: host, user, ssh key (ผู้สอนแจก)

## สถาปัตยกรรม (ย่อ)
```
Windows notebook (Claude Code native)  ──SSH──►  Linux VM (optional capstone)
        │                                             • PostgreSQL
        │  ssh -L 3000 (ดู Grafana)                    • Grafana
        └── browser: http://localhost:3000            • ข้อมูลจาก Ivanti
```

> ทำไมไม่ใช้ WSL: เครื่องไม่มี admin ติดตั้ง WSL สดไม่ได้ — WSL อยู่ในเอกสาร self-study
> (`../self-study/wsl-setup-guide.md`) ไว้อ่านเองภายหลัง

## ลำดับการทำ
`01` → `02` → `03` (Skills) → `04` (Use case) → `05` (optional) → `06` (สรุป)
ติดปัญหาเมื่อไร เปิด [`99-troubleshooting.md`](99-troubleshooting.md)
