# ตารางเวลา — Claude Code Workshop (5 ชม.)

> สำหรับผู้สอน — เวลาโดยประมาณ ปรับได้ตามหน้างาน (กลุ่ม ≤ 10 คน คละระดับ)
> **โฟกัสหลัก:** Skills + Use case จริง ("เราสร้าง workshop นี้ด้วย Claude Code อย่างไร")
> **Optional:** Capstone Ivanti/DB/Grafana บน VM

## ช่วงเช้า 10:00–12:00 — พื้นฐาน

| เวลา | หัวข้อ | ไฟล์อ้างอิง | หมายเหตุผู้สอน |
|---|---|---|---|
| 10:00–10:20 | บทนำ: Claude Code คืออะไร, use case, โมเดล, ค่าใช้จ่าย & ความปลอดภัยเบื้องต้น | `slides/slides.md` | ปูภาพรวมทั้งวัน |
| 10:20–10:55 | ติดตั้งบน Windows (no-admin): Node (fnm) → Claude Code → `ANTHROPIC_API_KEY` → `claude` ครั้งแรก | `lab/01-windows-setup.md` | แจก API key ตรงนี้ · เดินช้าๆ · คนติดปัญหา → fallback A |
| 10:55–11:35 | Fundamentals บนโปรเจกต์ตัวอย่าง: prompting, แก้ไฟล์, รันคำสั่ง, `/commands`, permission, git | `lab/02-claude-code-basics.md`, `sample-project/` | ให้ลงมือทำจริงทุกคน มี checkpoint |
| 11:35–12:00 | Plan mode & workflow (ปูทางช่วงบ่าย): plan/ExitPlanMode, การให้ context, `CLAUDE.md` | `lab/02-claude-code-basics.md` §Plan | เชื่อมเข้า use-case ตอนบ่าย |

**พักเที่ยง 12:00–13:30**

## ช่วงบ่าย 13:30–16:30 — Skills + Use case (หลัก), Capstone (optional)

| เวลา | หัวข้อ | ไฟล์อ้างอิง | หมายเหตุผู้สอน |
|---|---|---|---|
| 13:30–14:15 | **Skills (หลัก):** skill คืออะไร/ทำไมดี, ติดตั้งจาก GitHub (mattpocock, karpathy) แบบ manual + `/plugin`, เรียกใช้, สร้าง skill เล็กๆ | `lab/03-skills.md` | ให้ทุกคนติดตั้ง `grilling` แล้วลองใช้ทันที |
| 14:15–15:30 | **Use case จริง (เน้นมาก):** "เราใช้ Claude Code สร้าง workshop นี้อย่างไร" — สาธิต grill-me → plan → generate files, แล้วให้ผู้เรียนทำ mini-project ด้วย workflow เดียวกัน | `lab/04-use-case-build-workshop.md`, `examples/how-we-built-this.md` | สาธิต ~20 นาที แล้วปล่อยลงมือ ~50 นาที |
| 15:30–16:15 | **(Optional) Capstone:** SSH → VM ให้ Claude Code ติดตั้ง Postgres/Grafana + (ถ้ามี) ดึง Ivanti → dashboard ผ่าน `ssh -L` · คนไม่ทำ capstone → ต่อยอด mini-project/skill ตัวเอง | `lab/05-capstone-optional.md` | แยกกลุ่ม: อยากลงลึก vs อยากฝึกต่อ |
| 16:15–16:30 | สรุป best practices, `CLAUDE.md`, security, ค่าใช้จ่าย, Q&A, แจก self-study (WSL) | `lab/06-wrapup.md`, `self-study/` | |

## จุดตัดสินใจเรื่องเวลา
- Skills + use-case คือแกน **ห้ามตัด** — ถ้าเวลาไม่พอให้ตัด/ย่อ optional capstone ก่อน
- ถ้าเช้าเกินเวลา: ย่อ fundamentals เหลือ prompting + แก้ไฟล์ + git, ยก plan mode ไปเปิดหัวช่วงบ่าย
- capstone §Ivanti หนักสุด — ช้าเมื่อไรสลับไปใช้ mock (`scripts/ivanti-mock/`) ทันที
