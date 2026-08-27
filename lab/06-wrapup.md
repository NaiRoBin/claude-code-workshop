# Lab 06 — สรุป & Best practices

## สิ่งที่ได้เรียนวันนี้
- ติดตั้ง & ใช้ Claude Code บน Windows (ไม่ต้องมี admin) + ต่อ SSH เข้า VM
- พื้นฐาน: prompting, แก้ไฟล์, รันคำสั่ง, permission, git, **plan mode** (บน VM ผ่าน SSH)
- **Skills**: ติดตั้งจาก GitHub + สร้างเอง (บน Windows notebook)
- **Use case จริง**: ใช้ Claude Code สร้างโปรเจกต์ผ่าน grill-me → plan → generate (บน VM)
- **Capstone**: ให้ Claude Code สั่งงานข้าม SSH ไปติดตั้ง DB/Grafana + ดึง ServiceDesk Plus บน VM ตัวเดิม

## Best practices ที่ควรจำ
1. **ให้ context ดี** — เป้าหมาย, ข้อจำกัด, ตัวอย่าง input/output
2. **ใช้ plan mode กับงานใหญ่** — ตรวจแผนก่อน ลดการรื้อ ประหยัดเวลา/โทเคน
3. **`CLAUDE.md`** — บันทึกกติกา/บริบทให้ Claude จำทุกครั้ง
4. **อ่าน diff ก่อน allow** — เข้าใจการเปลี่ยนแปลงเสมอ (เราคุมได้)
5. **ทำงานเป็นรอบเล็ก ๆ** — commit บ่อย, ทบทวนบ่อย
6. **ใช้ skill ซ้ำงานประจำ** — แพ็ก workflow ที่ทำบ่อยเป็น skill

## ความปลอดภัย & ค่าใช้จ่าย
- **อย่า commit secret** (API key, token) — ใช้ environment variable
- API key มี **spend limit** — ระวังงานที่วน/รันยาว
- อ่าน diff/permission ก่อนให้รันคำสั่งที่กระทบระบบ (โดยเฉพาะบน VM ที่มี root)

## เรียนต่อด้วยตัวเอง
- `../self-study/wsl-setup-guide.md` — ติดตั้ง WSL (ต้องมี admin) แล้วรัน Claude Code บน WSL
- `../examples/how-we-built-this.md` — ทบทวน workflow ที่ใช้สร้าง workshop นี้
- ลองแพ็ก workflow ประจำวันของคุณเป็น skill แล้วแชร์ทีมผ่าน `.claude/skills/` ใน repo

## Q&A
เปิดพื้นที่ถาม-ตอบ + เก็บ feedback สำหรับปรับ workshop ครั้งหน้า
