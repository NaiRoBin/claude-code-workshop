# Lab 03 — Skills: ติดตั้งและใช้งาน (หัวข้อหลัก)

> เวลา ~45 นาที · ทำบน Windows notebook (Claude Code native)
> เป้าหมาย: เข้าใจว่า skill คืออะไร, ติดตั้ง skill จาก GitHub ได้, เรียกใช้ได้, และสร้าง skill เล็กๆ เองได้

> หมายเหตุ: lab นี้ทำบน Windows laptop เหมือนเดิม ไม่ใช่บน VM เพราะ personal skills
> (`~/.claude/skills/...`) ผูกกับเครื่องที่รัน `claude` จริง (laptop ของคุณ) ไม่ใช่เครื่องที่
> Claude Code สั่งงานไปถึงผ่าน SSH (VM) แบบที่ lab 02/04/05 ใช้

---

## 1. Skill คืออะไร (5 นาที)

**Skill** = ชุดคำสั่ง/แนวทางที่แพ็กไว้ให้ Claude Code หยิบมาใช้ซ้ำได้ เขียนในไฟล์ `SKILL.md`
(มี frontmatter YAML + เนื้อหา Markdown) Claude จะ **เรียกใช้อัตโนมัติ** เมื่อบริบทตรงกับ `description`
หรือเราพิมพ์ `/<ชื่อ-skill>` เรียกเองก็ได้

โครงไฟล์ skill:
```
.claude/skills/
└── my-skill/
    └── SKILL.md          # จำเป็น: frontmatter + เนื้อหา
        (แนบไฟล์ช่วย เช่น .sh / .js / templates ได้)
```

ตัวอย่าง `SKILL.md` แบบสั้นที่สุด:
```markdown
---
name: my-skill
description: อธิบายว่า skill นี้ทำอะไร ใช้เมื่อไร (Claude ใช้บรรทัดนี้ตัดสินใจเรียก)
---

เขียนขั้นตอน/แนวทางที่อยากให้ Claude ทำที่นี่ ...
```

---

## 2. Skill อยู่ที่ไหน (personal vs project) (3 นาที)

| ขอบเขต | ตำแหน่ง | ใช้เมื่อ |
|---|---|---|
| **Personal (ทุกโปรเจกต์)** | `~/.claude/skills/<ชื่อ>/SKILL.md` | อยากใช้ส่วนตัวทุกที่ |
| **Project (แชร์ทีม)** | `<project>/.claude/skills/<ชื่อ>/SKILL.md` | commit เข้า git ให้ทั้งทีมใช้ |

> บน Windows: `~` คือ `C:\Users\<you>` → path คือ `C:\Users\<you>\.claude\skills\`

---

## 3. ติดตั้ง skill จาก GitHub — วิธีหลัก (manual clone + copy) (15 นาที)

เราจะติดตั้งจาก 2 repo:
- **mattpocock/skills** — รวม skill หลายตัว (tdd, prototype, code-review, grilling, writing-for-agents ฯลฯ) อยู่ใต้ `skills/`
- **multica-ai/andrej-karpathy-skills** — มี skill เดียวที่ `skills/karpathy-guidelines/`

> ทั้งสอง repo เป็น **ชุด skill ธรรมดา** (ไม่ใช่ marketplace) → วิธีที่ชัวร์สุดคือ clone แล้ว copy โฟลเดอร์เข้า `~/.claude/skills/`

### 3.1 ติดตั้ง `grilling` จาก mattpocock/skills
```bash
# clone ไปที่ temp
git clone https://github.com/mattpocock/skills.git /tmp/mp-skills

# copy skill ที่ต้องการเข้า personal skills (เลือกได้หลายตัว)
cp -r /tmp/mp-skills/skills/grilling ~/.claude/skills/grilling
cp -r /tmp/mp-skills/skills/tdd      ~/.claude/skills/tdd
```

> Windows (PowerShell) เทียบเท่า:
> ```powershell
> git clone https://github.com/mattpocock/skills.git $env:TEMP\mp-skills
> Copy-Item -Recurse $env:TEMP\mp-skills\skills\grilling $env:USERPROFILE\.claude\skills\grilling
> ```

### 3.2 ติดตั้ง `karpathy-guidelines`
```bash
git clone https://github.com/multica-ai/andrej-karpathy-skills.git /tmp/karpathy
cp -r /tmp/karpathy/skills/karpathy-guidelines ~/.claude/skills/karpathy-guidelines
```

### 3.3 โหลด skill ให้ Claude Code เห็น
- ถ้าเปิด `claude` อยู่แล้ว: พิมพ์ `/reload-plugins` (ถ้ามี) **หรือ** ออกแล้วเปิด `claude` ใหม่ (ชัวร์สุด)

### ✅ Checkpoint 3
```bash
ls ~/.claude/skills/
```
ควรเห็นโฟลเดอร์ `grilling`, `tdd`, `karpathy-guidelines` — และใน `claude` พิมพ์ `/` แล้วเห็นชื่อ skill โผล่ในรายการ

---

## 4. ทางเลือก: ติดตั้งผ่าน Plugin marketplace (5 นาที, ทางเลือก)

ถ้า repo เป็น marketplace (มีไฟล์ `.claude-plugin/marketplace.json`) ทำได้แบบนี้:
```
/plugin marketplace add <owner>/<repo>
/plugin                       # เปิด browser เลือกจากแท็บ Discover
/plugin install <plugin>@<marketplace>
```
> สำหรับ 2 repo ข้างบนที่ไม่ใช่ marketplace ให้ใช้วิธี manual (ข้อ 3) จะชัวร์กว่า

---

## 5. เรียกใช้ skill (5 นาที)

- **อัตโนมัติ:** Claude เรียกเองเมื่อบริบทตรงกับ `description`
- **เรียกเอง:** พิมพ์ `/<ชื่อ-skill>` เช่น `/grilling` หรือส่ง argument `/tdd เขียนเทสต์ให้ฟังก์ชัน add`

ลองทำ: เปิดโปรเจกต์ตัวอย่าง แล้วพิมพ์
```
/grilling ฉันอยากสร้าง REST API สำหรับ todo list
```
ดูว่า Claude เริ่มซักถามออกแบบให้อย่างไร

### ✅ Checkpoint 5
เรียก `/grilling` แล้ว Claude เริ่มถามคำถามกลับ = ติดตั้งสำเร็จและใช้งานได้

---

## 6. สร้าง skill เล็กๆ ของเราเอง (10 นาที)

ให้ Claude Code สร้างให้เลยก็ได้ ลองพิมพ์:
```
สร้าง skill ชื่อ commit-msg ไว้ที่ ~/.claude/skills/commit-msg/SKILL.md
ให้ช่วยเขียน git commit message แบบ conventional commits จาก diff ที่ staged
```

ตรวจผล:
```bash
cat ~/.claude/skills/commit-msg/SKILL.md
```
แล้วรีสตาร์ท `claude` → ลอง `/commit-msg`

### ✅ Checkpoint 6
มีไฟล์ `~/.claude/skills/commit-msg/SKILL.md` และเรียก `/commit-msg` ได้

---

## ทำต่อ
ไปที่ [`04-use-case-build-workshop.md`](04-use-case-build-workshop.md) —
เราจะใช้ skill (เช่น grilling) + plan mode สร้างโปรเจกต์จริง เหมือนที่เราสร้าง workshop นี้ขึ้นมา
