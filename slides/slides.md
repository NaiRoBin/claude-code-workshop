---
marp: true
title: Claude Code Workshop (1 วัน)
paginate: true
theme: default
class: lead
---

<!--
วิธีใช้ไฟล์นี้ (สำหรับผู้สอน):
- นี่คือสไลด์ Marp (Markdown) — render เป็น HTML/PDF/PPTX ได้
- ติดตั้ง Marp for VS Code (extension) เพื่อดู preview สด
- หรือใช้ CLI:  npx @marp-team/marp-cli slides.md -o slides.html   (หรือ --pdf / --pptx)
- ข้อความในบล็อกคอมเมนต์แบบนี้คือ presenter notes — ไม่ขึ้นบนจอ (โหมด presenter ใน Marp)
- "---" คั่นแต่ละสไลด์
-->

# Claude Code Workshop
## เรียนใช้งานจริงใน 1 วัน

10:00–12:00 · 13:30–16:30

<!-- แนะนำตัว + เป้าหมายวันนี้: จบวันแล้วใช้ Claude Code ทำงานจริงได้ และรู้จัก Skills -->

---

## กติกาและบรรยากาศ

- ถามได้ตลอด — กลุ่มเราคละระดับ ไม่มีคำถามโง่
- มี **Checkpoint** ท้ายแต่ละช่วง — ทำไม่ทันบอกได้ เดี๋ยวรอกัน
- ติดตั้งไม่ได้จริง ๆ มี **แผนสำรอง (Fallback)** เสมอ
- ลงมือทำเองเยอะ ๆ — ดูอย่างเดียวไม่พอ

<!--
ย้ำ safety: เราคุม Claude ได้เสมอ (permission), ไม่ commit secret.
บอกว่าจะจับคู่ dev ช่วย non-dev.
-->

---

## ตารางวันนี้

**เช้า (พื้นฐาน)**
1. บทนำ Claude Code
2. ติดตั้งบน Windows (ไม่ต้องมี admin)
3. พื้นฐาน: สั่งงาน แก้ไฟล์ รันคำสั่ง git
4. Plan mode

**บ่าย (แกนหลักทั้งหมด)**
5. **Skills** — ติดตั้งจาก GitHub + สร้างเอง
6. **Use case จริง** — สร้างโปรเจกต์ด้วย Claude Code (บน VM)
7. **Capstone** — สั่ง Claude Code ข้าม SSH ไปคุม Linux VM ตัวเดิม (Postgres/Grafana/ServiceDesk Plus)
8. สรุป & best practices

---

<!-- _class: lead -->
# 1. บทนำ
## Claude Code คืออะไร

---

## Claude Code คืออะไร

- **AI coding agent** ที่ทำงานใน terminal
- ทำได้จริง: อ่าน/แก้ไฟล์ · รันคำสั่ง · ใช้ git · เชื่อมเครื่องมือ
- ทำงานเป็น "เพื่อนร่วมงาน" ที่ **วางแผนแล้วลงมือ** ให้เรา
- **เราคุม permission ได้เสมอ** — Claude ขออนุญาตก่อนทำสิ่งที่กระทบระบบ

<!--
เปรียบเทียบกับ autocomplete: Claude Code ทำงานเป็นขั้นตอน ไม่ใช่แค่เติมโค้ด.
ยกตัวอย่าง use case: refactor, เขียนเทสต์, ตั้ง service, สรุป log, ทำ automation.
-->

---

## ใช้ทำอะไรได้บ้าง (ตัวอย่าง)

| งาน | ตัวอย่าง |
|---|---|
| เขียน/แก้โค้ด | เพิ่มฟีเจอร์ แก้บั๊ก refactor |
| งานประจำ | สรุป log ร่างเอกสาร แปลงไฟล์ |
| DevOps/ops | ติดตั้ง service ตั้งค่า server (ผ่าน SSH) |
| เรียนรู้ codebase | "อธิบายว่าโปรเจกต์นี้ทำงานยังไง" |

<!-- ถามผู้เรียน: งานประจำอะไรที่อยากให้ช่วย? เก็บไว้ใช้เป็นโจทย์ mini-project ตอนบ่าย -->

---

## สถาปัตยกรรมของแลปวันนี้

```
Windows notebook (no admin)            Linux VM (workspace ตั้งแต่ lab 02)
  • Claude Code (native)   ──SSH──►      • sample-project / mini-project
  • ssh client                            • PostgreSQL / Grafana
  • browser ◄──── ssh -L 3000 ────       • ServiceDesk Plus หรือ mock
```

- Claude Code รัน **บน Windows** เป็นหลัก (ไม่ต้องมี admin, ไม่ต้องมี Node/npm)
- ตั้งแต่ lab 02 เป็นต้นไป: Claude Code **สั่งงานข้าม SSH** ไปทำงานจริงบน VM ตัวเดิม

<!--
อธิบายว่าทำไมไม่ใช้ WSL: เครื่องไม่มี admin → เปิด WSL ไม่ได้ → WSL อยู่ในเอกสาร self-study.
VM ไม่ใช่ของแถมเฉพาะ capstone อีกต่อไป — ใช้ต่อเนื่องตั้งแต่ lab 02 ถึง lab 05.
-->

---

## เรื่องเงินและความปลอดภัย (รู้ไว้ก่อน)

- auth ด้วย **API key** (`ANTHROPIC_API_KEY`) — ผมแจกให้
- key มี **spend limit** — ระวังงานที่วน/รันยาว
- **อย่าแชร์ key · อย่า commit key ลง git**
- อ่าน diff/คำสั่ง ก่อนกด allow เสมอ

<!-- เน้นย้ำ: นี่คือเงินจริง แต่มี limit กันไว้แล้ว. ปลายทางถ้าทำ capstone มี root ระวังคำสั่งอันตราย -->

---

<!-- _class: lead -->
# 2. ติดตั้งบน Windows
## ไม่ต้องมี admin

📄 ทำตาม `lab/01-windows-setup.md`

---

## ขั้นตอนติดตั้ง (3 ก้าว)

```powershell
# 1) Claude Code (native install — ไม่ต้อง admin, ไม่ต้องมี Node/npm, อัปเดตตัวเองอัตโนมัติ)
irm https://claude.ai/install.ps1 | iex

# 2) ต่อ SSH ไป VM ให้ non-interactive (ใช้ตั้งแต่ lab 02)
ssh-keygen -t ed25519 -C "workshop"
# ตั้ง ~/.ssh/config ให้มี Host myvm ... StrictHostKeyChecking accept-new
ssh myvm "uname -a"      # ต้องได้ผลทันที ไม่ถาม yes/no ไม่ถามรหัส

# 3) API key
setx ANTHROPIC_API_KEY "sk-ant-xxxx"   # เปิด terminal ใหม่
```

<!--
เดินช้า ๆ ตรงนี้ รอทุกคน. ถ้า irm ไม่รู้จัก แสดงว่าอยู่ใน CMD ไม่ใช่ PowerShell → ใช้ install.cmd แทน (ดู lab 01).
SSH ต้อง non-interactive จริง ๆ เพราะ lab 02 เป็นต้นไปทุก lab สั่งงานผ่าน ssh myvm ทั้งหมด
-->

---

## ✅ Checkpoint: ติดตั้งสำเร็จ

```powershell
claude --version           # เห็นเวอร์ชัน Claude Code
ssh myvm "hostname"        # ไม่ถามอะไรเลย

mkdir hello-claude; cd hello-claude; claude
# แล้วพิมพ์: สร้างไฟล์ hello.txt ที่มีข้อความ "สวัสดี Claude Code"
```

> ⚠️ ลง Claude Code บน Windows ไม่ได้จริง ๆ? → **Fallback A**: ssh เข้า VM แล้วลง Claude Code
> (native install แบบเดียวกัน) บน VM แทน จากนั้นรัน `claude` บน VM ทำ lab ที่เหลือทั้งวัน

<!-- คนที่ติดปัญหา จดชื่อไว้ จับกลุ่มช่วยตอนพัก / ใช้ fallback A ได้ทันทีตั้งแต่ตอนนี้ -->

---

<!-- _class: lead -->
# 3. พื้นฐาน Claude Code

📄 `lab/02-claude-code-basics.md` · โปรเจกต์ `sample-project/` (provision ไว้บน VM แล้ว, ทำงานผ่าน `ssh myvm "..."`)

---

## 4 อย่างที่ต้องเป็น

1. **สั่งงาน (prompt)** — บอกเป้าหมาย + บริบท + ตัวอย่าง
2. **แก้ไฟล์** — ดู **diff** ก่อนกด allow
3. **รันคำสั่ง** — Claude ขออนุญาตก่อน (permission)
4. **git** — commit ผ่าน Claude ได้

```
เพิ่มฟังก์ชัน multiply(a, b) ใน src/calculator.js พร้อมคอมเมนต์ไทย
รันเทสต์ให้หน่อย
git init แล้ว commit งานปัจจุบัน
```

<!-- ให้ทุกคนลงมือทำจริงบน sample-project (บน VM ผ่าน ssh myvm). เดินดูรอบ ๆ ห้อง -->

---

## Slash commands ที่ใช้บ่อย

| คำสั่ง | ทำอะไร |
|---|---|
| `/help` | ความช่วยเหลือ + รายการคำสั่ง |
| `/clear` | ล้าง context เริ่มใหม่ |
| `/plan` | วางแผนก่อนลงมือ |
| `/reload-plugins` | โหลด skill ใหม่ |
| `Esc` | หยุดสิ่งที่ Claude กำลังทำ |

<!-- พิมพ์ / แล้วให้ดูรายการที่โผล่. เดี๋ยวช่วงบ่ายจะมี /grilling /tdd เพิ่ม -->

---

## Plan mode — คิดก่อนทำ

งานใหญ่ → ให้ Claude **ร่างแผนก่อน** แล้วเราตรวจ/แก้ ก่อนอนุมัติ

```
ฉันอยากเพิ่มฟีเจอร์อ่าน CSV เข้ามาใน calculator
ช่วยวางแผนก่อน (plan mode) อย่าเพิ่งแก้โค้ด
```

**`CLAUDE.md`** = ความจำของโปรเจกต์ (กติกา/บริบทที่อยากให้ Claude จำทุกครั้ง)

<!-- นี่คือสะพานสู่ช่วงบ่าย: use case ก็ใช้ grill-me + plan mode แบบนี้ -->

---

<!-- _class: lead -->
# 4. Skills 🧩
## หัวข้อหลักช่วงบ่าย

📄 `lab/03-skills.md`

---

## Skill คืออะไร

- ชุด **workflow/แนวทาง** ที่แพ็กไว้ใช้ซ้ำ (ไฟล์ `SKILL.md`)
- Claude **เรียกอัตโนมัติ** เมื่อบริบทตรง `description` หรือเราพิมพ์ `/<ชื่อ>`

```markdown
---
name: my-skill
description: อธิบายว่า skill นี้ทำอะไร ใช้เมื่อไร
---
เขียนขั้นตอน/แนวทางที่อยากให้ Claude ทำ ...
```

- **personal:** `~/.claude/skills/<ชื่อ>/SKILL.md` (ทุกโปรเจกต์)
- **project:** `<project>/.claude/skills/<ชื่อ>/SKILL.md` (แชร์ทีมผ่าน git)

<!-- Windows: ~ คือ C:\Users\<you> -->

---

## ติดตั้ง skill จาก GitHub (วิธีชัวร์)

```bash
git clone https://github.com/mattpocock/skills.git /tmp/mp
cp -r /tmp/mp/skills/grilling ~/.claude/skills/grilling
cp -r /tmp/mp/skills/tdd      ~/.claude/skills/tdd

git clone https://github.com/multica-ai/andrej-karpathy-skills.git /tmp/kp
cp -r /tmp/kp/skills/karpathy-guidelines ~/.claude/skills/karpathy-guidelines
```

จากนั้น `/reload-plugins` (หรือเปิด `claude` ใหม่)

<!--
2 repo นี้เป็นชุด skill ธรรมดา ไม่ใช่ marketplace → ใช้ clone+copy.
ทางเลือก: /plugin marketplace add <owner>/<repo> ถ้า repo เป็น marketplace.
-->

---

## ✅ Checkpoint: ลองใช้ skill

```
/grilling ฉันอยากสร้าง REST API สำหรับ todo list
```

Claude เริ่ม **ซักถามออกแบบ** ให้ = ติดตั้งสำเร็จ 🎉

**สร้าง skill เองก็ได้:**
```
สร้าง skill ชื่อ commit-msg ที่ ~/.claude/skills/commit-msg/SKILL.md
ให้ช่วยเขียน git commit แบบ conventional commits จาก diff ที่ staged
```

<!-- ให้ทุกคนติดตั้ง grilling แล้วลองเรียก. ใครอยากลอง สร้าง skill เองได้ -->

---

<!-- _class: lead -->
# 5. Use case จริง 🚀
## "เราสร้าง workshop นี้ด้วย Claude Code อย่างไร"

📄 `lab/04-use-case-build-workshop.md` · `examples/how-we-built-this.md`

---

## Workflow ที่ใช้จริง

```
grill-me   →   plan mode   →   ExitPlanMode   →   generate   →   วนแก้
(ซักสเปก)      (ร่างแผน)        (อนุมัติ)          (สร้างไฟล์)
```

ทุกไฟล์ใน workshop นี้ถูกสร้างแบบนี้จริง ๆ

<!--
เล่าเรื่อง: โจทย์ตั้งต้นคลุมเครือ ("ไม่มี admin แต่ให้ติดตั้ง WSL") →
grill-me จับข้อขัดแย้งได้ตั้งแต่คำถามแรก → ปรับ design → plan → สร้าง.
เปิด examples/how-we-built-this.md ประกอบ.
-->

---

## บทเรียนสำคัญจาก use case

1. **อย่ารีบเขียนโค้ด** — ให้ซักจนสเปกชัดก่อน (`/grilling`)
2. **plan mode กับงานใหญ่** — เห็นภาพรวม ตรวจก่อน ลดการรื้อ
3. **ให้ feedback เป็นรอบ** — เปลี่ยน scope กลางทางได้
4. **`CLAUDE.md`** จำบริบทให้เรา
5. ทำซ้ำได้เองทุกเมื่อ

---

## ถึงตาคุณ: mini-project (~50 นาที)

เลือก 1 โจทย์ (หรือคิดเอง) แล้วทำด้วย workflow เดียวกัน:

- **A (non-dev):** สคริปต์อ่าน CSV → สรุปสถิติ → เขียน Markdown report
- **B:** REST API todo list + เทสต์ (ลองใช้ `/tdd`)
- **C:** เขียน skill ช่วยงานประจำของคุณ

```
claude   (เปิดบน Windows ตามเดิม บอก Claude ว่าทำงานผ่าน ssh myvm)
ssh myvm "mkdir -p ~/my-mini"
/grilling <โจทย์ของคุณ>
→ plan → อนุมัติ → สร้าง (บน ~/my-mini ใน VM) → /commit-msg
```

<!-- ปล่อยลงมือ. เดินช่วย. ใครเสร็จเร็วให้ต่อยอด mini-project ต่อระหว่างรอเพื่อน แล้วไปทำ capstone พร้อมกัน -->

---

<!-- _class: lead -->
# 6. Capstone
## Claude Code สั่งงานข้าม SSH ไปคุม VM ตัวเดิม

📄 `lab/05-capstone.md`

---

## โจทย์ capstone

ให้ **Claude Code (บน Windows)** สั่งงานข้าม SSH ไปที่ VM ตัวเดิมที่ใช้มาตั้งแต่ lab 02 เพื่อ:

1. ติดตั้ง **PostgreSQL** + สร้างตาราง `requests`
2. ดึงข้อมูลจาก **ServiceDesk Plus** (หรือ mock) → โหลดเข้า DB
3. ติดตั้ง **Grafana** + สร้าง dashboard
4. เปิดดูผ่าน `ssh -L 3000` บน browser

> Claude Code = **agent orchestrate remote Linux**

---

## กุญแจสำคัญ: SSH ต้องไม่ค้าง

Claude สั่งงานผ่าน `ssh myvm "..."` → ต้อง **non-interactive**

`~/.ssh/config`:
```
Host myvm
    HostName <VM_IP>
    User <student-user>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking accept-new
```
ทดสอบ: `ssh myvm "uname -a"` ต้องได้ผลทันที ไม่ถามอะไร

<!-- ถ้าไม่ตั้ง accept-new + key → ssh ค้างรอ prompt → Claude ค้าง. นี่คือจุดพลาดที่พบบ่อยสุด -->

---

## ตัวอย่าง prompt + fallback

```
เราทำงานบน remote VM ผ่าน `ssh myvm "..."`
ติดตั้ง PostgreSQL, สร้าง db itsm + ตาราง requests,
รันทีละขั้น ตรวจผลก่อนไปต่อ
```

**ServiceDesk Plus ล่ม/ช้า?** สลับ mock ทันที:
```bash
node ~/servicedesk-mock/mock-server.js   # http://localhost:8080/requests
```

ดู Grafana: `ssh -L 3000:localhost:3000 myvm` → `http://localhost:3000`

<!-- ทุกคนทำ capstone นี้ต่อเนื่องจาก lab 04 เสมอ ไม่มี branch ให้ข้าม -->

---

<!-- _class: lead -->
# 7. สรุป & Best practices

📄 `lab/06-wrapup.md`

---

## Best practices ที่ควรจำ

1. ให้ **context ดี** (เป้าหมาย + ข้อจำกัด + ตัวอย่าง)
2. ใช้ **plan mode** กับงานใหญ่
3. **`CLAUDE.md`** = ความจำโปรเจกต์
4. **อ่าน diff ก่อน allow**
5. ทำงานเป็น **รอบเล็ก** · commit บ่อย
6. แพ็ก workflow ประจำเป็น **skill** แล้วแชร์ทีม

---

## ความปลอดภัย & ค่าใช้จ่าย

- ❌ อย่า commit secret (API key/token) → ใช้ env var
- 💰 API key มี spend limit — ระวังงานวน/ยาว
- 🔒 อ่านคำสั่งก่อนให้รันบนเครื่องที่มี root

## เรียนต่อ
- `self-study/wsl-setup-guide.md` — ติดตั้ง WSL (ต้องมี admin)
- `examples/how-we-built-this.md` — ทบทวน workflow

---

<!-- _class: lead -->
# ขอบคุณครับ 🙌
## Q&A

เปิดพื้นที่ถาม-ตอบ + เก็บ feedback

<!-- ถาม: จะเอา Claude Code ไปใช้กับงานอะไรต่อ? เก็บไว้ปรับ workshop ครั้งหน้า -->
