# Claude Code Workshop (1 วัน) — ชุดสื่อการสอน

ชุดสื่อ + สคริปต์ + คู่มือ พร้อมใช้จัดอบรมการใช้งาน **Claude Code** แบบ 1 วัน
(10:00–12:00 และ 13:30–16:30 รวม 5 ชั่วโมง) สำหรับผู้เรียนกลุ่มคละระดับ (dev / non-dev) ≤ 10 คน

## โฟกัสหลักของ workshop
1. **พื้นฐาน Claude Code** — ติดตั้งบน Windows (no-admin) + ต่อ SSH เข้า VM + ใช้งานบนโปรเจกต์จริง
2. **Skills** — ติดตั้ง & ใช้งาน skill จาก GitHub (mattpocock, karpathy) + สร้างเอง (บน Windows notebook)
3. **Use case จริง (เน้นมาก)** — "เราใช้ Claude Code เตรียม workshop นี้อย่างไร" step-by-step
   ให้ผู้เรียนทำตาม workflow เดียวกัน (grill-me → plan → ให้ Claude Code สร้างไฟล์) บน VM
4. **Capstone** — ต่อจาก VM เดิม ให้ Claude Code ติดตั้ง DB/Grafana +
   ดึงข้อมูล ServiceDesk Plus (หรือ mock) — เป็นส่วนหนึ่งของ flow หลัก ไม่ใช่ของเสริม

## สถาปัตยกรรมของแลป (อ่านก่อนเริ่ม)

เครื่องผู้เรียนเป็น **Windows notebook ที่ไม่มีสิทธิ์ admin** จึง **ติดตั้ง WSL สดในคลาสไม่ได้**
(การเปิด WSL ต้องใช้ admin) เราจึงออกแบบดังนี้ (VM เป็น workspace กลางตั้งแต่ lab 02):

```
┌────────────────────────┐        SSH         ┌───────────────────────┐
│  Windows notebook      │  ───────────────▶  │  Linux VM (1 ตัว/คน)  │
│  (no admin)            │   ssh myvm "..."   │  มี root               │
│                        │                    │                       │
│  • Claude Code (native)│                    │  • sample-project      │
│  • ssh client          │   ssh -L 3000      │    (lab02) / mini-     │
│  • browser  ◀──────────┼────────────────────┤    project (lab04)    │
│                        │                    │  • PostgreSQL/Grafana/ │
│                        │                    │    ServiceDesk Plus    │
│                        │                    │    หรือ mock (lab05)  │
└────────────────────────┘                    └───────────────────────┘
```

- **Claude Code รัน native บน Windows** (ติดตั้งแบบ no-admin, ไม่ต้องมี Node/npm) — เส้นทางหลัก
- ตั้งแต่ **lab 02** เป็นต้นไป Claude Code **สั่งงานข้าม SSH** ไปทำงานจริงบน Linux VM ส่วนตัวของผู้เรียน
  (ทำหน้าที่เป็น agent orchestrate remote server) — VM ไม่ใช่ของแถมเฉพาะ capstone อีกต่อไป
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
| `lab/01-windows-setup.md` | ผู้เรียน | ติดตั้ง Claude Code บน Windows (no-admin) + ต่อ SSH เข้า VM |
| `lab/02-claude-code-basics.md` | ผู้เรียน | พื้นฐาน Claude Code + plan mode (บน VM ผ่าน SSH) |
| `lab/03-skills.md` | ผู้เรียน | **(หลัก)** ติดตั้ง & ใช้ Skills จาก GitHub + สร้างเอง (บน Windows notebook) |
| `lab/04-use-case-build-workshop.md` | ผู้เรียน | **(หลัก)** ใช้ Claude Code เตรียม workshop นี้ + mini-project (บน VM) |
| `lab/05-capstone.md` | ผู้เรียน | SSH→VM: Postgres → ServiceDesk Plus → Grafana |
| `lab/06-wrapup.md` | ผู้เรียน | สรุป + best practices |
| `lab/99-troubleshooting.md` | ทุกคน | ปัญหาที่พบบ่อย |
| `examples/how-we-built-this.md` | ทุกคน | use case จริง: ใช้ Claude Code เตรียมการสอนนี้อย่างไร |
| `slides/` | ผู้สอน | สไลด์ + cheat sheet |
| `scripts/` | ผู้สอน | สคริปต์ provision VM + mock ServiceDesk Plus |
| `sample-project/` | ผู้เรียน | โปรเจกต์ตัวอย่างสำหรับฝึก lab 02 (provision ขึ้น VM ให้แต่ละคนก่อนวันอบรม) |
| `self-study/wsl-setup-guide.md` | ผู้เรียน | ติดตั้ง WSL (อ่านเองภายหลัง) |

## Quick start สำหรับผู้สอน
1. อ่าน `instructor/pre-class-checklist.md` แล้วเตรียมล่วงหน้า (สร้าง API key, provision VM,
   ยืนยัน ServiceDesk Plus token) — VM ต้องพร้อมก่อนวันอบรมเสมอ ใช้ตั้งแต่ lab 02
2. รัน `scripts/provision-vm.sh` บน VM แต่ละเครื่อง → ตรวจด้วย `scripts/verify-vm.sh`
3. Dry-run เดินตาม `lab/01` → `lab/06` ทั้งเส้นด้วยตัวเองก่อนวันจริง

> หมายเหตุ: ค่าจริง (ServiceDesk Plus endpoint/token, API key) **ห้าม commit** — ใช้ผ่าน environment variable หรือแจกหน้างาน
