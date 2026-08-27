# Lab 00 — ภาพรวม

## เราจะเรียนอะไรวันนี้
1. **ติดตั้ง Claude Code บน Windows** (ไม่ต้องมี admin) + ต่อ SSH เข้า VM แล้วใช้งานจริง
2. **พื้นฐาน Claude Code** — สั่งงาน, แก้ไฟล์, รันคำสั่ง, git, plan mode (ทำงานบน VM ผ่าน SSH)
3. **Skills (หลัก)** — ติดตั้ง skill จาก GitHub และสร้างเอง (บน Windows notebook)
4. **Use case จริง (หลัก)** — ใช้ Claude Code สร้างโปรเจกต์ตั้งแต่ต้นจนจบ (แบบเดียวกับที่สร้าง workshop นี้) บน VM
5. **Capstone** — ให้ Claude Code ติดตั้ง DB/Grafana บน VM + ดึงข้อมูล ServiceDesk Plus

## สิ่งที่ต้องมี
- Windows notebook (ไม่ต้องมี admin) + เน็ตต่อออกอินเทอร์เน็ตได้
- `ANTHROPIC_API_KEY` (ผู้สอนแจกหน้างาน)
- ข้อมูลเข้า VM: host, user, ssh key (ผู้สอนแจก) — ใช้ตั้งแต่ lab 02 เป็นต้นไป

## สถาปัตยกรรม (ย่อ)
```
Windows notebook (Claude Code native)  ──SSH──►  Linux VM (workspace ตั้งแต่ lab 02)
        │                                             • sample-project (lab 02)
        │  ssh -L 3000 (ดู Grafana)                    • mini-project (lab 04)
        └── browser: http://localhost:3000            • PostgreSQL + Grafana +
                                                          ServiceDesk Plus/mock (lab 05)
```

> ทำไมไม่ใช้ WSL: เครื่องไม่มี admin ติดตั้ง WSL สดไม่ได้ — WSL อยู่ในเอกสาร self-study
> (`../self-study/wsl-setup-guide.md`) ไว้อ่านเองภายหลัง

## ลำดับการทำ
`01` → `02` → `03` (Skills) → `04` (Use case) → `05` (Capstone) → `06` (สรุป)
ติดปัญหาเมื่อไร เปิด [`99-troubleshooting.md`](99-troubleshooting.md)
