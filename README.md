# Claude Code Workshop (1 วัน) — ชุดสื่อการสอน

ชุดสื่อ + สคริปต์ + คู่มือ พร้อมใช้จัดอบรมการใช้งาน **Claude Code** แบบ 1 วัน
(10:00–12:00 และ 13:30–16:30 รวม 5 ชั่วโมง) สำหรับผู้เรียนกลุ่มคละระดับ (dev / non-dev) ≤ 10 คน

## โฟกัสหลักของ workshop
1. **พื้นฐาน Claude Code** — ติดตั้งบน Windows (no-admin) + ใช้งานบนโปรเจกต์จริง
2. **Skills** — ติดตั้ง & ใช้งาน skill จาก GitHub (mattpocock, karpathy) + สร้างเอง
3. **Use case จริง (เน้นมาก)** — "เราใช้ Claude Code เตรียม workshop นี้อย่างไร" step-by-step
   ให้ผู้เรียนทำตาม workflow เดียวกัน (grill-me → plan → ให้ Claude Code สร้างไฟล์)
4. **(Optional) Capstone** — SSH ไป Linux VM แล้วให้ Claude Code ติดตั้ง DB/Grafana +
   ดึงข้อมูล Ivanti (เสริม สำหรับคนอยากลงลึก remote orchestration)

## สถาปัตยกรรมของแลป (อ่านก่อนเริ่ม)

เครื่องผู้เรียนเป็น **Windows notebook ที่ไม่มีสิทธิ์ admin** จึง **ติดตั้ง WSL สดในคลาสไม่ได้**
(การเปิด WSL ต้องใช้ admin) เราจึงออกแบบดังนี้ (ส่วน VM ใช้เฉพาะ optional capstone):

```
┌────────────────────────┐        SSH         ┌───────────────────────┐
│  Windows notebook      │  ───────────────▶  │  Linux VM (1 ตัว/คน)  │
│  (no admin)            │   ssh myvm "..."   │  มี root               │
│                        │                    │                       │
│  • Claude Code (native)│                    │  • PostgreSQL          │
│  • ssh client          │   ssh -L 3000      │  • Grafana             │
│  • browser  ◀──────────┼────────────────────┤  • ข้อมูลจาก Ivanti   │
└────────────────────────┘                    └───────────────────────┘
```

- **Claude Code รัน native บน Windows** (ติดตั้งแบบ no-admin) — เส้นทางหลัก
- Claude Code **สั่งงานข้าม SSH** ไปติดตั้ง/คุม Linux VM ส่วนตัวของผู้เรียน (ทำหน้าที่เป็น agent orchestrate remote server)
- **Fallback (แบบ A):** ใครลง Claude Code บน Windows ไม่ได้ → SSH เข้า VM แล้วรัน Claude Code บน VM แทน
- **Auth:** Anthropic Console API key (`ANTHROPIC_API_KEY`) — 1 key/คน จาก workspace เดียว + ตั้ง spend limit รวม
- **WSL:** เป็นเอกสาร self-study (`self-study/`) ไม่สอนสดในคลาส

## สารบัญ

| โฟลเดอร์ / ไฟล์ | สำหรับใคร | เนื้อหา |
|---|---|---|
| `agenda.md` | ผู้สอน | ตารางเวลาละเอียด 5 ชม. |
| `instructor/instructor-guide.md` | ผู้สอน | คู่มือผู้สอน + จุดที่มักติด + วิธีกู้ |
| `instructor/pre-class-checklist.md` | ผู้สอน | เช็คลิสต์ก่อนวันงาน |
| `lab/00-overview.md` | ผู้เรียน | ภาพรวมแลป |
| `lab/01-windows-setup.md` | ผู้เรียน | ติดตั้ง Node + Claude Code บน Windows (no-admin) |
| `lab/02-claude-code-basics.md` | ผู้เรียน | พื้นฐาน Claude Code + plan mode |
| `lab/03-skills.md` | ผู้เรียน | **(หลัก)** ติดตั้ง & ใช้ Skills จาก GitHub + สร้างเอง |
| `lab/04-use-case-build-workshop.md` | ผู้เรียน | **(หลัก)** ใช้ Claude Code เตรียม workshop นี้ + mini-project |
| `lab/05-capstone-optional.md` | ผู้เรียน | **(optional)** SSH→VM: Postgres → Ivanti → Grafana |
| `lab/06-wrapup.md` | ผู้เรียน | สรุป + best practices |
| `lab/99-troubleshooting.md` | ทุกคน | ปัญหาที่พบบ่อย |
| `examples/how-we-built-this.md` | ทุกคน | use case จริง: ใช้ Claude Code เตรียมการสอนนี้อย่างไร |
| `slides/` | ผู้สอน | สไลด์ + cheat sheet |
| `scripts/` | ผู้สอน | สคริปต์ provision VM + mock Ivanti |
| `sample-project/` | ผู้เรียน | โปรเจกต์ตัวอย่างสำหรับฝึกช่วงเช้า |
| `self-study/wsl-setup-guide.md` | ผู้เรียน | ติดตั้ง WSL (อ่านเองภายหลัง) |

## Quick start สำหรับผู้สอน
1. อ่าน `instructor/pre-class-checklist.md` แล้วเตรียมล่วงหน้า (สร้าง API key; ถ้าจะทำ optional capstone: provision VM + ยืนยัน Ivanti token)
2. (เฉพาะ optional capstone) รัน `scripts/provision-vm.sh` บน VM แต่ละเครื่อง → ตรวจด้วย `scripts/verify-vm.sh`
3. Dry-run เดินตาม `lab/01` → `lab/06` ทั้งเส้นด้วยตัวเองก่อนวันจริง

> หมายเหตุ: ค่าจริง (Ivanti endpoint/token, API key) **ห้าม commit** — ใช้ผ่าน environment variable หรือแจกหน้างาน
