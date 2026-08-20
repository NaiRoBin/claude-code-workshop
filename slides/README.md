# สไลด์สอน (Slides)

ชุดสไลด์สอนแบบ **Marp** (Markdown) แยกเป็น 1 ไฟล์ต่อ 1 ช่วง/lab เพื่อเปิดสอนทีละส่วนได้สะดวก
ทุกไฟล์มี **presenter notes** (ใน HTML comment) สำหรับผู้สอน และเก็บคำสั่ง/โค้ดจริงจาก lab ครบ

## ลำดับการสอน

| ไฟล์ | ช่วง | เนื้อหา |
|---|---|---|
| `00-overview.md` | 10:00–10:20 | บทนำ, กติกา, Claude Code คืออะไร, **harness (เทียบ Claude Code/Hermes/Antigravity)**, สถาปัตยกรรม, 4 โฟกัส, ตารางเวลา, ค่าใช้จ่าย/security |
| `01-windows-setup.md` | 10:20–10:55 | ติดตั้งบน Windows (no-admin): fnm → Node → Claude Code → API key |
| `02-basics.md` | 10:55–12:00 | พื้นฐาน: prompting, แก้ไฟล์, permission, git, plan mode, CLAUDE.md |
| `03-skills.md` **(หลัก)** | 13:30–14:15 | Skills: ติดตั้งจาก GitHub, เรียกใช้, สร้างเอง |
| `04-use-case.md` **(หลัก)** | 14:15–15:30 | Use case จริง: grill-me → plan → generate + mini-project |
| `05-capstone.md` *(optional)* | 15:30–16:15 | สั่ง Claude Code ข้าม SSH → Postgres/Grafana/Ivanti |
| `06-wrapup.md` | 16:15–16:30 | best practices, security, ค่าใช้จ่าย, Q&A |

ไฟล์ประกอบ:
- `slides.md` — เด็คภาพรวม (overview เดิม แบบสั้น) ใช้เกริ่นทั้งวันในหน้าเดียว
- `infographic.html` — สรุปทั้งวันหน้าเดียว (เปิดเบราว์เซอร์/พิมพ์ PDF)
- `cheatsheet.md` — cheat sheet คำสั่ง 1 หน้า

## วิธี render เป็น HTML / PDF / PPTX

ติดตั้ง **Marp for VS Code** (extension) เพื่อ preview สด แล้ว Export
หรือใช้ CLI:
```bash
npx @marp-team/marp-cli 03-skills.md -o 03-skills.html   # หรือ --pdf / --pptx
```
> pptx/pdf จาก Marp ต้องมี Chromium และได้สไลด์เป็น "รูปภาพ" (แก้ข้อความไม่ได้)
> ถ้าต้องการ pptx แบบ **แก้ข้อความได้** ให้แปลงด้วย pandoc (ดูวิธีในบันทึกของผู้สอน)
