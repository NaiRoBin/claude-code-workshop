---
marp: true
title: "Claude Code Workshop — บทนำ & ภาพรวม"
paginate: true
theme: default
class: lead
---

<!--
วิธีใช้ไฟล์นี้ (สำหรับผู้สอน):
- สไลด์ Marp (Markdown) — render เป็น HTML/PDF/PPTX ได้ด้วย @marp-team/marp-cli
- ข้อความในบล็อกคอมเมนต์แบบนี้คือ presenter notes — ไม่ขึ้นบนจอ
- ไฟล์นี้คือ "บทนำ + ภาพรวมทั้งวัน" ใช้เปิดคลาสช่วง 10:00–10:20
- อ้างอิงจาก README.md, agenda.md, lab/00-overview.md — ไม่มีข้อมูลเกินจากต้นฉบับ
-->

# Claude Code Workshop
## บทนำ & ภาพรวมทั้งวัน

Workshop 1 วัน (10:00–12:00 และ 13:30–16:30 รวม 5 ชั่วโมง)
สำหรับผู้เรียนกลุ่มคละระดับ (dev / non-dev) ≤ 10 คน

<!--
เปิดคลาส: แนะนำตัวผู้สอน, บอกกรอบเวลารวม 5 ชม., เน้นว่ากลุ่มคละระดับได้ไม่ต้องกังวล
ถ้าไม่ใช่ dev ก็ตามได้ เพราะจะมีจับคู่ช่วยกัน
-->

---

<!-- _class: lead -->
# กติกา & บรรยากาศคลาส

---

## กติกา & บรรยากาศคลาส

- ถามได้ตลอด — กลุ่มคละระดับ (dev / non-dev) ไม่มีคำถามโง่
- ลงมือทำเองเยอะ ๆ — ดูอย่างเดียวไม่พอ ทุก lab มี checkpoint ให้ทำจริง
- ทำไม่ทันบอกได้ เดี๋ยวรอกัน / จับคู่ dev ช่วย non-dev
- ติดตั้งไม่ได้จริง ๆ มีแผนสำรอง (Fallback) เสมอ ไม่มีใครตกขบวน
- ค่าใช้จ่าย (API key) และความปลอดภัย (secret ห้าม commit) จะพูดถึงตลอดวัน

<!--
ย้ำ safety ตั้งแต่ต้น: เราคุม Claude ได้เสมอผ่าน permission, ไม่ commit secret
บอกว่าจะจับคู่ dev ช่วย non-dev ตั้งแต่ตอนติดตั้ง
สร้างบรรยากาศสบาย ๆ ไม่กดดัน เพราะกลุ่มคละระดับ
-->

---

<!-- _class: lead -->
# Claude Code คืออะไร

---

## Claude Code คืออะไร

- AI coding agent ที่ทำงานผ่าน terminal / CLI
- สั่งงานได้จริง: อ่าน/แก้ไฟล์, รันคำสั่ง, ใช้ git, ติดตั้ง & คุมเครื่องมือ
- ทำงานแบบ agent ที่ "ออกแบบ workflow" ให้เราได้ เช่น
  - grill-me (ซักถามจนได้แผนชัด) → plan → สั่งให้สร้างไฟล์จริง
- เชื่อม Skills จาก GitHub เพื่อขยายความสามารถ (ไม่ต้องเขียนเองทุกอย่าง)

<!--
เกริ่นว่า Claude Code ไม่ใช่แค่ autocomplete ในโค้ด แต่ทำงานเป็นขั้นตอน
ตัวอย่าง workflow ที่จะสอนบ่าย: grill-me -> plan -> generate files
คือ workflow เดียวกับที่ผู้สอนใช้เตรียม workshop นี้เอง (เป็น use case จริงตอนบ่าย)
-->

---

## Claude Code ใช้ทำอะไรได้บ้าง (ตัวอย่างในคลาสนี้)

| โฟกัส | ตัวอย่างการใช้งานในวันนี้ |
|---|---|
| พื้นฐาน | ติดตั้งบน Windows (no-admin), สั่งงาน, แก้ไฟล์, รันคำสั่ง, git |
| Skills | ติดตั้ง skill จาก GitHub (mattpocock, karpathy) + สร้าง skill เอง |
| Use case จริง | ใช้ Claude Code เตรียม workshop นี้เอง — grill-me → plan → สร้างไฟล์ |
| Capstone (optional) | สั่งงานข้าม SSH ไปติดตั้ง DB/Grafana บน Linux VM + ดึงข้อมูล Ivanti |

<!--
ตารางนี้คือภาพรวม 4 โฟกัสของวัน จะขยายรายละเอียดในสไลด์ถัดไป
เน้นว่า Use case จริง (แถวที่ 3) คือแกนที่เน้นที่สุดของวัน — ห้ามตัดเวลาช่วงนี้
-->

---

<!-- _class: lead -->
# Claude Code กับ "harness" อื่น ๆ
## Claude Code · Hermes · Antigravity

---

## "harness" คืออะไร

- **harness** = โครงร่างที่ครอบ LLM ให้ "ลงมือทำงานจริง" ไม่ใช่แค่ตอบแชต
- องค์ประกอบสำคัญ:
  - **agent loop** — คิด → ใช้เครื่องมือ → อ่านผล → ทำต่อ
  - **tools** — อ่าน/แก้ไฟล์, รัน shell, git, เปิดเว็บ
  - จัดการ **context / memory**, ระบบ **permission / ความปลอดภัย**, **skills** ต่อยอด
- เปรียบเทียบง่าย ๆ: **โมเดล = สมอง · harness = ร่างกาย + มือ + เครื่องมือ**
- Claude Code คือ harness ตัวหนึ่ง — ยังมีเจ้าอื่นแนวเดียวกัน (Hermes, Antigravity)

<!--
ปูแนวคิดก่อนเทียบตาราง: ผู้เรียนจะเข้าใจว่าทำไม Claude Code ทำงานได้จริง (มี loop + tools + permission)
เน้นประโยค "โมเดล = สมอง, harness = ร่างกาย" เป็น mental model หลักของสไลด์นี้
-->

---

## เทียบ 3 harness

| หัวข้อ | Claude Code | Hermes | Antigravity |
|---|---|---|---|
| ผู้สร้าง | Anthropic | Nous Research | Google |
| รูปแบบ | CLI / terminal เน้นงาน dev | agent generalist อยู่ได้หลาย platform (Telegram, Discord, Slack, Email, CLI) + desktop | แพลตฟอร์มเต็ม: IDE + CLI + SDK + ตัวจัดการ agent หลายตัว |
| โมเดล | Claude | Nous ecosystem (300+ โมเดลผ่าน Nous Portal) | Gemini |
| โอเพนซอร์ส | ไคลเอนต์แบบปิด | เปิด (MIT) | แบบปิด |
| จุดเด่น | dev workflow ใน terminal, skills, plan mode | memory ข้ามช่องทาง, auto-generate skills, subagent, รันได้หลาย backend (local/Docker/SSH/Modal) | จัดการ agent หลายตัว, ทำงานข้าม editor/terminal/browser |

<!--
ข้อมูล ณ ปลายปี 2025–2026 — ผลิตภัณฑ์กลุ่มนี้เปลี่ยนเร็ว ควรตรวจซ้ำก่อนวันสอน
Hermes อ้างอิง hermes-agent.nousresearch.com · Antigravity อ้างอิง antigravity.google
ไม่ต้องลงรายละเอียดทุกช่อง — ชี้ให้เห็น "ต่างที่โมเดล + พื้นผิวการใช้งาน + ความเปิด"
-->

---

## เหมือน / ต่าง — สรุป

- **เหมือน:** ทั้งสามเป็น *agentic harness* — LLM + เครื่องมือ + loop ที่ลงมือทำได้จริง (รันคำสั่ง, แก้ไฟล์, ทำงานหลายขั้น) และมีแนวคิด skills / subagent
- **ต่าง:**
  - **โมเดล** เบื้องหลัง — Claude / Nous / Gemini
  - **พื้นผิว** — Claude Code เน้น terminal สาย dev · Antigravity เป็น IDE/แพลตฟอร์มเต็ม · Hermes เป็น generalist อยู่หลายแอป
  - **ความเปิด** — Hermes เปิดซอร์ส (MIT) ส่วนอีกสองตัวเป็นไคลเอนต์แบบปิด
- 💡 แนวคิดสำคัญ: **harness ≠ model** — โมเดลเดียวรันได้หลาย harness และ harness เลือกโมเดลได้
- วันนี้เราโฟกัส **Claude Code** แต่แนวคิด (agent loop, skills, permission) ใช้ร่วมกับตัวอื่นได้

<!--
takeaway ที่อยากให้ติดตัวผู้เรียน: "harness ≠ model" — เลือก harness ให้เหมาะงาน/ทีม
ไม่ต้องเชียร์ตัวใดตัวหนึ่ง แค่ให้เห็นภาพว่า Claude Code อยู่ในตระกูลเดียวกับ Hermes/Antigravity
เชื่อมเข้าสไลด์ถัดไป: วันนี้เราเลือก Claude Code แล้วมาดูสถาปัตยกรรมของแลปกัน
-->

---

<!-- _class: lead -->
# สถาปัตยกรรมของแลป
## อ่านก่อนเริ่ม

---

## ทำไมต้องออกแบบแบบนี้

- เครื่องผู้เรียนเป็น **Windows notebook ที่ไม่มีสิทธิ์ admin**
- จึง **ติดตั้ง WSL สดในคลาสไม่ได้** (เปิด WSL ต้องใช้ admin)
- ทางออก: รัน Claude Code **native บน Windows** แบบ no-admin เป็นเส้นทางหลัก
- ส่วน Linux VM ใช้เฉพาะ **optional capstone** เท่านั้น
- WSL เป็นเอกสาร self-study (`self-study/wsl-setup-guide.md`) — ไม่สอนสดในคลาส

<!--
อธิบายเหตุผลเชิง constraint ก่อนโชว์ diagram: ถ้าไม่มีข้อจำกัด admin เราอาจใช้ WSL ตรง ๆ
แต่เพราะ noteBook บริษัท/องค์กรมักไม่ให้ admin เราเลยออกแบบ native Windows + SSH ไป VM แทน
-->

---

## แผนภาพสถาปัตยกรรม

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

- Claude Code รัน **native บน Windows** (ติดตั้งแบบ no-admin) — เส้นทางหลัก
- Claude Code **สั่งงานข้าม SSH** ไปติดตั้ง/คุม Linux VM ของผู้เรียน (agent orchestrate remote server)
- ดู Grafana ผ่าน `ssh -L 3000` แล้วเปิด browser ที่ `http://localhost:3000`

<!--
เดินอธิบาย diagram ทีละลูกศร: ซ้ายคือเครื่องผู้เรียน (Windows, no admin)
ขวาคือ VM ส่วนตัวของผู้เรียนแต่ละคน (มี root) ที่ใช้เฉพาะ optional capstone
Claude Code บน Windows เป็นตัวสั่งงานหลัก ยิง SSH ไปทำงานบน VM แทนเรา
-->

---

## Fallback (แผนสำรอง)

- **Auth:** ใช้ Anthropic Console API key (`ANTHROPIC_API_KEY`) — 1 key/คน จาก workspace เดียว + ตั้ง spend limit รวม
- **Fallback (แบบ A):** ใครติดตั้ง Claude Code บน Windows ไม่ได้ → SSH เข้า VM แล้วรัน Claude Code บน VM แทน
- ผลคือทุกคนมีทางไปต่อได้ ไม่ว่าเครื่อง Windows จะติดตั้งได้หรือไม่

<!--
เน้น Fallback A ให้ชัด เพราะเป็นจุดกู้สถานการณ์เวลาเจอปัญหาช่วงติดตั้ง 10:20-10:55
ถ้าใครติดปัญหาช่วงติดตั้ง Windows ให้สลับไปเส้นทางนี้ทันทีไม่ต้องเสียเวลา debug นาน
-->

---

<!-- _class: lead -->
# 4 โฟกัสหลักของ Workshop

---

## โฟกัสที่ 1 — พื้นฐาน Claude Code

- ติดตั้งบน Windows (no-admin) + ใช้งานบนโปรเจกต์จริง
- Node (fnm) → Claude Code → `ANTHROPIC_API_KEY` → `claude` ครั้งแรก
- Fundamentals: prompting, แก้ไฟล์, รันคำสั่ง, `/commands`, permission, git
- Plan mode & workflow — ปูทางเข้าช่วงบ่าย

<!-- ช่วงนี้คือ 10:00-12:00 ทั้งเช้า อธิบายว่าเป็นฐานที่ต้องมีก่อนไปทำ Skills/Use case ช่วงบ่าย -->

---

## โฟกัสที่ 2 — Skills (หลัก)

- Skill คืออะไร / ทำไมดี
- ติดตั้งจาก GitHub (mattpocock, karpathy) แบบ manual + ผ่าน `/plugin`
- เรียกใช้ skill ที่ติดตั้งแล้ว
- สร้าง skill เล็กๆ ของตัวเอง
- กิจกรรม: ให้ทุกคนติดตั้ง `grilling` แล้วลองใช้ทันที

<!-- นี่คือหนึ่งในสองแกนหลักช่วงบ่าย (13:30-14:15) เน้นว่า "ห้ามตัด" ตามจุดตัดสินใจเรื่องเวลา -->

---

## โฟกัสที่ 3 — Use case จริง (เน้นมากที่สุด)

- หัวข้อ: **"เราใช้ Claude Code เตรียม workshop นี้อย่างไร"** แบบ step-by-step
- Workflow ที่สาธิต: **grill-me → plan → ให้ Claude Code สร้างไฟล์**
- ผู้เรียนทำตาม workflow เดียวกันกับ mini-project ของตัวเอง
- สาธิตโดยผู้สอน ~20 นาที แล้วปล่อยให้ผู้เรียนลงมือ ~50 นาที

<!--
นี่คือแกนที่เน้นที่สุดของทั้งวัน (13.30-15.30 รวม ~1 ชม. 15 นาที)
ย้ำว่านี่ไม่ใช่ตัวอย่างสมมติ แต่เป็น workflow จริงที่ใช้เตรียมสื่อการสอนชุดนี้เอง
อ้างอิงเพิ่มที่ examples/how-we-built-this.md
-->

---

## โฟกัสที่ 4 — Capstone (Optional)

- SSH ไป Linux VM (1 ตัว/คน) แล้วให้ Claude Code ติดตั้ง PostgreSQL + Grafana
- ดึงข้อมูลจาก Ivanti (เสริม สำหรับคนอยากลงลึก remote orchestration)
- ดู dashboard ผ่าน `ssh -L 3000` แล้วเปิด browser
- คนไม่ทำ capstone → ต่อยอด mini-project หรือ skill ของตัวเองต่อ

<!--
ย้ำว่าเป็น optional จริง ๆ — สำหรับคนที่ทำ use case เสร็จเร็วและอยากลงลึกเรื่อง remote orchestration
คนที่ไม่ถนัดหรือเวลาไม่พอ ไปต่อยอด mini-project ของตัวเองแทนได้ ไม่มีใครเสียโอกาส
ถ้าเวลาไม่พอในวันจริง capstone คือส่วนแรกที่ตัด/ย่อ
-->

---

<!-- _class: lead -->
# ตารางเวลาทั้งวัน

---

## ช่วงเช้า 10:00–12:00 — พื้นฐาน

| เวลา | หัวข้อ | ไฟล์อ้างอิง | หมายเหตุผู้สอน |
|---|---|---|---|
| 10:00–10:20 | บทนำ: Claude Code คืออะไร, use case, โมเดล, ค่าใช้จ่าย & ความปลอดภัยเบื้องต้น | `slides/slides.md` | ปูภาพรวมทั้งวัน |
| 10:20–10:55 | ติดตั้งบน Windows (no-admin): Node (fnm) → Claude Code → `ANTHROPIC_API_KEY` → `claude` ครั้งแรก | `lab/01-windows-setup.md` | แจก API key ตรงนี้ · เดินช้าๆ · คนติดปัญหา → fallback A |
| 10:55–11:35 | Fundamentals บนโปรเจกต์ตัวอย่าง: prompting, แก้ไฟล์, รันคำสั่ง, `/commands`, permission, git | `lab/02-claude-code-basics.md`, `sample-project/` | ให้ลงมือทำจริงทุกคน มี checkpoint |
| 11:35–12:00 | Plan mode & workflow (ปูทางช่วงบ่าย): plan/ExitPlanMode, การให้ context, `CLAUDE.md` | `lab/02-claude-code-basics.md` §Plan | เชื่อมเข้า use-case ตอนบ่าย |

**พักเที่ยง 12:00–13:30**

<!--
ตารางนี้คือ agenda.md ช่วงเช้าเป๊ะ ๆ — เดินตามลำดับนี้ ห้ามข้าม
ย้ำว่า 10:20-10:55 คือช่วงแจก API key และมักเป็นช่วงที่มีคนติดปัญหาการติดตั้ง ให้เผื่อเวลา
-->

---

## ช่วงบ่าย 13:30–16:30 — Skills + Use case (หลัก), Capstone (optional)

| เวลา | หัวข้อ | ไฟล์อ้างอิง | หมายเหตุผู้สอน |
|---|---|---|---|
| 13:30–14:15 | **Skills (หลัก):** skill คืออะไร/ทำไมดี, ติดตั้งจาก GitHub (mattpocock, karpathy) แบบ manual + `/plugin`, เรียกใช้, สร้าง skill เล็กๆ | `lab/03-skills.md` | ให้ทุกคนติดตั้ง `grilling` แล้วลองใช้ทันที |
| 14:15–15:30 | **Use case จริง (เน้นมาก):** "เราใช้ Claude Code สร้าง workshop นี้อย่างไร" — สาธิต grill-me → plan → generate files, แล้วให้ผู้เรียนทำ mini-project ด้วย workflow เดียวกัน | `lab/04-use-case-build-workshop.md`, `examples/how-we-built-this.md` | สาธิต ~20 นาที แล้วปล่อยลงมือ ~50 นาที |
| 15:30–16:15 | **(Optional) Capstone:** SSH → VM ให้ Claude Code ติดตั้ง Postgres/Grafana + (ถ้ามี) ดึง Ivanti → dashboard ผ่าน `ssh -L` · คนไม่ทำ capstone → ต่อยอด mini-project/skill ตัวเอง | `lab/05-capstone-optional.md` | แยกกลุ่ม: อยากลงลึก vs อยากฝึกต่อ |
| 16:15–16:30 | สรุป best practices, `CLAUDE.md`, security, ค่าใช้จ่าย, Q&A, แจก self-study (WSL) | `lab/06-wrapup.md`, `self-study/` | |

<!--
ตารางนี้คือ agenda.md ช่วงบ่ายเป๊ะ ๆ — Skills กับ Use case คือแกนหลัก ห้ามตัดเวลา
capstone คือส่วนแรกที่ตัด/ย่อถ้าเวลาไม่พอ ให้แยกกลุ่มตามความสนใจตอน 15:30
-->

---

## จุดตัดสินใจเรื่องเวลา

- **Skills + use-case คือแกน — ห้ามตัด**
- ถ้าเวลาไม่พอ ให้ตัด/ย่อ **optional capstone ก่อน**
- ถ้าเช้าเกินเวลา: ย่อ fundamentals เหลือ prompting + แก้ไฟล์ + git, ยก plan mode ไปเปิดหัวช่วงบ่ายแทน
- capstone ส่วน Ivanti หนักสุด — ช้าเมื่อไรสลับไปใช้ mock (`scripts/ivanti-mock/`) ทันที

<!--
สไลด์นี้สำหรับผู้สอนโดยเฉพาะ ใช้เป็น decision tree เวลาคุมเวลาหน้างาน
ท่องไว้: ตัด capstone ก่อนเสมอ ไม่ตัด skills/use-case
-->

---

<!-- _class: lead -->
# ค่าใช้จ่าย & ความปลอดภัยเบื้องต้น

---

## ค่าใช้จ่าย & ความปลอดภัยเบื้องต้น

- **Auth:** Anthropic Console API key (`ANTHROPIC_API_KEY`) — 1 key ต่อคน จาก workspace เดียวกัน
- ตั้ง **spend limit รวม** ของ workspace ไว้ล่วงหน้า เพื่อคุมค่าใช้จ่าย
- ผู้สอนแจก API key หน้างาน (ช่วง 10:20–10:55)
- **ห้าม commit** ค่าจริง เช่น Ivanti endpoint/token, API key — ใช้ผ่าน environment variable หรือแจกหน้างานเท่านั้น
- เราคุม permission ของ Claude Code ได้เสมอ ก่อนให้ทำสิ่งที่กระทบระบบ

<!--
ย้ำเรื่องนี้ตั้งแต่บทนำ และจะย้ำอีกครั้งตอนสรุปท้ายวัน (lab/06-wrapup.md)
เตือนผู้เรียนอย่า commit .env หรือ secret ใด ๆ ขึ้น git โดยเฉพาะช่วงทำ use-case/capstone
-->

---

<!-- _class: lead -->
# เริ่มกันเลย → Lab 01

<!--
เปิด lab/01-windows-setup.md ต่อทันที
เช็คว่าทุกคนมีเน็ต + เครื่อง Windows พร้อมก่อนเริ่มติดตั้ง
-->
