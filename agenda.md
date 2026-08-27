# ตารางเวลา — Claude Code Workshop (5 ชม.)

> สำหรับผู้สอน — เวลาโดยประมาณ ปรับได้ตามหน้างาน (กลุ่ม ≤ 10 คน คละระดับ)
> **โฟกัสหลัก:** Skills + Use case จริง ("เราสร้าง workshop นี้ด้วย Claude Code อย่างไร") + Capstone
> **สถาปัตยกรรม:** VM เป็น workspace กลางตั้งแต่ lab 02 — Capstone (ServiceDesk Plus/DB/Grafana)
> เป็นส่วนหนึ่งของ flow หลัก ไม่ใช่ของเสริมอีกต่อไป

## ช่วงเช้า 10:00–12:00 — พื้นฐาน

| เวลา | หัวข้อ | ไฟล์อ้างอิง | หมายเหตุผู้สอน |
|---|---|---|---|
| 10:00–10:20 | บทนำ: Claude Code คืออะไร, use case, โมเดล, ค่าใช้จ่าย & ความปลอดภัยเบื้องต้น | `slides/slides.md` | ปูภาพรวมทั้งวัน |
| 10:20–10:55 | ติดตั้งบน Windows (no-admin): Claude Code (native install) → ต่อ SSH เข้า VM → `ANTHROPIC_API_KEY` → `claude` ครั้งแรก | `lab/01-windows-setup.md` | แจก API key ตรงนี้ · เดินช้าๆ · คนติดปัญหา → fallback A |
| 10:55–11:35 | Fundamentals บนโปรเจกต์ตัวอย่าง (บน VM ผ่าน SSH): prompting, แก้ไฟล์, รันคำสั่ง, `/commands`, permission, git | `lab/02-claude-code-basics.md`, `sample-project/` (provision ไว้บน VM แล้ว) | ให้ลงมือทำจริงทุกคน มี checkpoint |
| 11:35–12:00 | Plan mode & workflow (ปูทางช่วงบ่าย): plan/ExitPlanMode, การให้ context, `CLAUDE.md` | `lab/02-claude-code-basics.md` §Plan | เชื่อมเข้า use-case ตอนบ่าย |

**พักเที่ยง 12:00–13:30**

## ช่วงบ่าย 13:30–16:30 — Skills + Use case + Capstone (ทั้งหมดเป็นหลัก)

| เวลา | หัวข้อ | ไฟล์อ้างอิง | หมายเหตุผู้สอน |
|---|---|---|---|
| 13:30–14:15 | **Skills (หลัก):** skill คืออะไร/ทำไมดี, ติดตั้งจาก GitHub (mattpocock, karpathy) แบบ manual + `/plugin`, เรียกใช้, สร้าง skill เล็กๆ (บน Windows notebook) | `lab/03-skills.md` | ให้ทุกคนติดตั้ง `grilling` แล้วลองใช้ทันที |
| 14:15–15:30 | **Use case จริง (เน้นมาก):** "เราใช้ Claude Code สร้าง workshop นี้อย่างไร" — สาธิต grill-me → plan → generate files, แล้วให้ผู้เรียนทำ mini-project ด้วย workflow เดียวกันบน VM | `lab/04-use-case-build-workshop.md`, `examples/how-we-built-this.md` | สาธิต ~20 นาที แล้วปล่อยลงมือ ~50 นาที |
| 15:30–16:15 | **Capstone:** ต่อบน VM เดิม ให้ Claude Code ติดตั้ง Postgres/Grafana + ดึงข้อมูล ServiceDesk Plus (หรือ mock) → dashboard ผ่าน `ssh -L` | `lab/05-capstone.md` | ทุกคนทำต่อเนื่องจาก lab 04 ไม่มี branch ให้ข้าม |
| 16:15–16:30 | สรุป best practices, `CLAUDE.md`, security, ค่าใช้จ่าย, Q&A, แจก self-study (WSL) | `lab/06-wrapup.md`, `self-study/` | |

## จุดตัดสินใจเรื่องเวลา
- Skills + use-case + capstone คือแกนหลักทั้งหมด — ถ้าเวลาไม่พอ ให้ย่อความลึกของ Skills
  (สอน skill เดียวพอ) หรือลดโจทย์ mini-project ของ use-case แทน ไม่ตัด capstone
- ถ้าเช้าเกินเวลา: ย่อ fundamentals เหลือ prompting + แก้ไฟล์ + git, ยก plan mode ไปเปิดหัวช่วงบ่าย
- capstone §ServiceDesk Plus หนักสุด — ช้าเมื่อไรสลับไปใช้ mock (`scripts/servicedesk-mock/`) ทันที
