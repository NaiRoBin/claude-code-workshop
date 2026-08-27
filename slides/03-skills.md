---
marp: true
title: "Lab 03 — Skills (หลัก)"
paginate: true
theme: default
---

<!-- _class: lead -->
# Lab 03 — Skills
## ติดตั้งและใช้งาน (หัวข้อหลัก)

<!--
เปิด session: นี่คือหัวข้อหลักของ workshop ทั้งหมด เน้นย้ำผู้เรียนว่าเลบนี้สำคัญ
ให้เวลาเยอะกว่าเลบอื่น เพราะเนื้อหาแน่นและต้องลงมือทำจริงหลายขั้น
-->

---

## ภาพรวม Lab นี้

- เวลา ~45 นาที · ทำบน Windows notebook (Claude Code native)
- เป้าหมาย:
  - เข้าใจว่า **skill** คืออะไร
  - ติดตั้ง skill จาก GitHub ได้
  - เรียกใช้ skill ได้
  - สร้าง skill เล็กๆ เองได้

> หมายเหตุ: lab นี้ทำบน Windows laptop เหมือนเดิม ไม่ใช่บน VM เพราะ personal skills
> (`~/.claude/skills/...`) ผูกกับเครื่องที่รัน `claude` จริง (laptop ของคุณ) ไม่ใช่เครื่องที่
> Claude Code สั่งงานไปถึงผ่าน SSH (VM) แบบที่ lab 02/04/05 ใช้

<!--
บอกผู้เรียนว่ามี 6 หัวข้อหลัก: (1) skill คืออะไร (2) personal vs project (3) ติดตั้งจาก GitHub
(4) marketplace ทางเลือก (5) เรียกใช้ (6) สร้างเอง — แต่ละหัวข้อมี checkpoint ให้เช็คว่าทำถูก
-->

---

<!-- _class: lead -->
# 1. Skill คืออะไร

<!--
เริ่มหัวข้อแรก ใช้เวลาประมาณ 5 นาทีตามต้นฉบับ อธิบายแนวคิดพื้นฐานก่อนลงมือทำ
-->

---

## Skill คืออะไร

**Skill** = ชุดคำสั่ง/แนวทางที่แพ็กไว้ให้ Claude Code หยิบมาใช้ซ้ำได้

- เขียนในไฟล์ `SKILL.md`
- มี frontmatter YAML + เนื้อหา Markdown
- Claude จะ **เรียกใช้อัตโนมัติ** เมื่อบริบทตรงกับ `description`
- หรือเราพิมพ์ `/<ชื่อ-skill>` เรียกเองก็ได้

<!--
เน้นสองวิธีการเรียกใช้: อัตโนมัติ (Claude ตัดสินใจเองจาก description) กับเรียกเอง (slash command)
ทั้งสองวิธีจะกลับมาอธิบายละเอียดอีกครั้งในหัวข้อ 5
-->

---

## โครงไฟล์ skill

```
.claude/skills/
└── my-skill/
    └── SKILL.md          # จำเป็น: frontmatter + เนื้อหา
        (แนบไฟล์ช่วย เช่น .sh / .js / templates ได้)
```

- ทุก skill อยู่ในโฟลเดอร์ของตัวเอง ชื่อโฟลเดอร์ = ชื่อ skill
- ไฟล์ `SKILL.md` เป็นไฟล์บังคับเพียงไฟล์เดียว
- สามารถแนบไฟล์เสริม เช่น script `.sh` / `.js` / template ไว้ในโฟลเดอร์เดียวกันได้

<!--
ชี้ให้เห็นโครง directory ให้ชัดเจนก่อนไปดูตัวอย่างเนื้อหาไฟล์จริง
-->

---

## ตัวอย่าง SKILL.md แบบสั้นที่สุด

```markdown
---
name: my-skill
description: อธิบายว่า skill นี้ทำอะไร ใช้เมื่อไร (Claude ใช้บรรทัดนี้ตัดสินใจเรียก)
---

เขียนขั้นตอน/แนวทางที่อยากให้ Claude ทำที่นี่ ...
```

> `description` สำคัญมาก เพราะ Claude ใช้บรรทัดนี้ตัดสินใจว่าจะเรียก skill นี้อัตโนมัติเมื่อไร

<!--
ให้ผู้เรียนสังเกต frontmatter: name และ description เป็นฟิลด์หลัก
เน้นว่า description ต้องเขียนให้ชัดว่า "ใช้เมื่อไร" เพราะมีผลต่อการเรียกอัตโนมัติ
-->

---

<!-- _class: lead -->
# 2. Skill อยู่ที่ไหน
## personal vs project

<!--
หัวข้อที่ 2 ใช้เวลาสั้นๆ ประมาณ 3 นาที เป็นการปูพื้นก่อนไปติดตั้งจริงในหัวข้อ 3
-->

---

## personal vs project

| ขอบเขต | ตำแหน่ง | ใช้เมื่อ |
|---|---|---|
| **Personal (ทุกโปรเจกต์)** | `~/.claude/skills/<ชื่อ>/SKILL.md` | อยากใช้ส่วนตัวทุกที่ |
| **Project (แชร์ทีม)** | `<project>/.claude/skills/<ชื่อ>/SKILL.md` | commit เข้า git ให้ทั้งทีมใช้ |

> บน Windows: `~` คือ `C:\Users\<you>` → path คือ `C:\Users\<you>\.claude\skills\`

<!--
เน้นความแตกต่าง: personal ใช้ทุกโปรเจกต์ในเครื่องตัวเอง ส่วน project จะอยู่ใน repo และ commit เข้า git
ให้ผู้เรียน (ที่ทำบน Windows) จำ path ของ personal ให้ได้ก่อนไปหัวข้อ 3 ที่จะติดตั้งจริง
-->

---

<!-- _class: lead -->
# 3. ติดตั้ง skill จาก GitHub
## วิธีหลัก (manual clone + copy)

<!--
หัวข้อที่ใช้เวลามากที่สุด ~15 นาที เป็นแกนหลักของ lab นี้ ให้ผู้เรียนลงมือทำจริงทุกคำสั่ง
-->

---

## เราจะติดตั้งจาก 2 repo

- **mattpocock/skills** — รวม skill หลายตัว (tdd, prototype, code-review, grilling, writing-for-agents ฯลฯ) อยู่ใต้ `skills/`
- **multica-ai/andrej-karpathy-skills** — มี skill เดียวที่ `skills/karpathy-guidelines/`

> ทั้งสอง repo เป็น **ชุด skill ธรรมดา** (ไม่ใช่ marketplace) → วิธีที่ชัวร์สุดคือ clone แล้ว copy โฟลเดอร์เข้า `~/.claude/skills/`

<!--
อธิบายว่าทำไมต้องใช้วิธี manual clone แทน marketplace: เพราะทั้งสอง repo ไม่ได้เป็น marketplace
วิธี clone + copy จะใช้ได้กับ repo ทุกแบบ เป็นวิธีที่ชัวร์ที่สุด
-->

---

## 3.1 ติดตั้ง `grilling` จาก mattpocock/skills

```bash
# clone ไปที่ temp
git clone https://github.com/mattpocock/skills.git /tmp/mp-skills

# copy skill ที่ต้องการเข้า personal skills (เลือกได้หลายตัว)
cp -r /tmp/mp-skills/skills/grilling ~/.claude/skills/grilling
cp -r /tmp/mp-skills/skills/tdd      ~/.claude/skills/tdd
```

<!--
ให้ผู้เรียนรัน clone ก่อน แล้ว copy เฉพาะโฟลเดอร์ skill ที่ต้องการ (ไม่ต้อง copy ทั้ง repo)
ในตัวอย่างนี้ copy สองตัว: grilling และ tdd
-->

---

## 3.1 (ต่อ) Windows (PowerShell) เทียบเท่า

```powershell
git clone https://github.com/mattpocock/skills.git $env:TEMP\mp-skills
Copy-Item -Recurse $env:TEMP\mp-skills\skills\grilling $env:USERPROFILE\.claude\skills\grilling
```

> ผู้เรียนทำบน Windows notebook ให้ใช้คำสั่ง PowerShell นี้แทน bash

<!--
ผู้เรียนกลุ่มนี้ทำบน Windows native จริง เน้นให้ใช้บรรทัดนี้แทน bash โดยตรง
สังเกตว่า path เทียบเท่า: /tmp -> $env:TEMP, ~ -> $env:USERPROFILE
-->

---

## 3.2 ติดตั้ง `karpathy-guidelines`

```bash
git clone https://github.com/multica-ai/andrej-karpathy-skills.git /tmp/karpathy
cp -r /tmp/karpathy/skills/karpathy-guidelines ~/.claude/skills/karpathy-guidelines
```

<!--
ทำซ้ำ pattern เดียวกันกับ repo ที่สอง เพื่อให้ผู้เรียนคุ้นเคยกับขั้นตอน clone -> copy
-->

---

## 3.3 โหลด skill ให้ Claude Code เห็น

- ถ้าเปิด `claude` อยู่แล้ว: พิมพ์ `/reload-plugins` (ถ้ามี)
- **หรือ** ออกแล้วเปิด `claude` ใหม่ (ชัวร์สุด)

<!--
ย้ำว่าวิธีที่ชัวร์ที่สุดคือปิดแล้วเปิด claude ใหม่ เพราะ /reload-plugins อาจไม่มีในบางเวอร์ชัน
-->

---

## ✅ Checkpoint 3

```bash
ls ~/.claude/skills/
```

ควรเห็นโฟลเดอร์ `grilling`, `tdd`, `karpathy-guidelines`
— และใน `claude` พิมพ์ `/` แล้วเห็นชื่อ skill โผล่ในรายการ

<!--
ให้ผู้เรียนรัน ls จริงและเช็คว่าเห็นสามโฟลเดอร์ครบ จากนั้นเปิด claude แล้วพิมพ์ / เพื่อดูว่า skill โผล่ในลิสต์
ถ้ายังไม่เห็นให้เช็คว่า copy ผิด path หรือยังไม่ได้ restart claude
-->

---

<!-- _class: lead -->
# 4. ทางเลือก
## ติดตั้งผ่าน Plugin marketplace

<!--
หัวข้อทางเลือก ใช้เวลาสั้นๆ ~5 นาที ไม่บังคับต้องทำจริง เพราะสอง repo ที่ใช้ในเลบนี้ไม่ใช่ marketplace
-->

---

## ติดตั้งผ่าน Plugin marketplace

ถ้า repo เป็น marketplace (มีไฟล์ `.claude-plugin/marketplace.json`) ทำได้แบบนี้:

```
/plugin marketplace add <owner>/<repo>
/plugin                       # เปิด browser เลือกจากแท็บ Discover
/plugin install <plugin>@<marketplace>
```

> สำหรับ 2 repo ข้างบนที่ไม่ใช่ marketplace ให้ใช้วิธี manual (ข้อ 3) จะชัวร์กว่า

<!--
อธิบายว่านี่เป็นทางเลือกสำหรับ repo ที่ตั้งค่าเป็น marketplace โดยเฉพาะ (มีไฟล์ .claude-plugin/marketplace.json)
ไม่เกี่ยวกับสอง repo ที่ใช้ในเลบนี้ ให้ผู้เรียนรู้จักไว้เผื่อเจอ repo แบบนี้ในอนาคต
-->

---

<!-- _class: lead -->
# 5. เรียกใช้ skill

<!--
หัวข้อที่ 5 ใช้เวลา ~5 นาที กลับมาขยายความเรื่องการเรียกใช้ที่พูดถึงคร่าวๆ ในหัวข้อ 1
-->

---

## เรียกใช้ skill

- **อัตโนมัติ:** Claude เรียกเองเมื่อบริบทตรงกับ `description`
- **เรียกเอง:** พิมพ์ `/<ชื่อ-skill>` เช่น `/grilling` หรือส่ง argument `/tdd เขียนเทสต์ให้ฟังก์ชัน add`

<!--
ย้ำอีกครั้งสองวิธีเรียกใช้ พร้อมตัวอย่างการส่ง argument ต่อท้าย slash command เช่น /tdd เขียนเทสต์ให้ฟังก์ชัน add
-->

---

## ลองทำ

เปิดโปรเจกต์ตัวอย่าง แล้วพิมพ์:

```
/grilling ฉันอยากสร้าง REST API สำหรับ todo list
```

ดูว่า Claude เริ่มซักถามออกแบบให้อย่างไร

<!--
ให้ผู้เรียนลองพิมพ์คำสั่งนี้จริงในโปรเจกต์ตัวอย่าง สังเกตว่า Claude จะเริ่มถามคำถามเพื่อ grill แนวคิด
-->

---

## ✅ Checkpoint 5

เรียก `/grilling` แล้ว Claude เริ่มถามคำถามกลับ = ติดตั้งสำเร็จและใช้งานได้

<!--
เกณฑ์ผ่าน checkpoint นี้ง่ายมาก: แค่ Claude ตอบกลับด้วยคำถาม (ไม่ใช่ error ว่าไม่รู้จักคำสั่ง)
ถ้า error แสดงว่า skill ยังไม่ถูกโหลด ให้กลับไปเช็ค checkpoint 3
-->

---

<!-- _class: lead -->
# 6. สร้าง skill เล็กๆ ของเราเอง

<!--
หัวข้อสุดท้าย ~10 นาที ให้ผู้เรียนสร้าง skill เองโดยให้ Claude Code ช่วยเขียนให้
-->

---

## ให้ Claude Code สร้างให้เลย

ลองพิมพ์:

```
สร้าง skill ชื่อ commit-msg ไว้ที่ ~/.claude/skills/commit-msg/SKILL.md
ให้ช่วยเขียน git commit message แบบ conventional commits จาก diff ที่ staged
```

<!--
ไม่ต้องเขียน SKILL.md มือ ให้ Claude Code เขียนให้เองตามคำอธิบาย
ผู้เรียนแค่บอกชื่อ path และหน้าที่ของ skill
-->

---

## ตรวจผล

```bash
cat ~/.claude/skills/commit-msg/SKILL.md
```

แล้วรีสตาร์ท `claude` → ลอง `/commit-msg`

<!--
ให้ผู้เรียนเปิดดูไฟล์ที่ Claude สร้างให้ ดูว่ามี frontmatter (name, description) ครบไหม
จากนั้น restart claude แล้วลองเรียก /commit-msg จริง
-->

---

## ✅ Checkpoint 6

มีไฟล์ `~/.claude/skills/commit-msg/SKILL.md` และเรียก `/commit-msg` ได้

<!--
เกณฑ์ผ่าน: ไฟล์มีอยู่จริง และ slash command /commit-msg เรียกได้โดยไม่ error
ถ้าผ่านทั้ง 3 checkpoint (3, 5, 6) แสดงว่าผู้เรียนเข้าใจ lifecycle เต็มของ skill: ติดตั้ง -> เรียกใช้ -> สร้างเอง
-->

---

<!-- _class: lead -->
# ทำต่อ →

## Lab 04 — Use case build workshop

เราจะใช้ skill (เช่น grilling) + plan mode สร้างโปรเจกต์จริง
เหมือนที่เราสร้าง workshop นี้ขึ้นมา

<!--
ปิด lab นี้ด้วยการเชื่อมไปเลบถัดไป (04-use-case-build-workshop.md)
เน้นว่าเลบถัดไปจะเอา skill ที่ติดตั้งวันนี้ (โดยเฉพาะ grilling) มาใช้จริงร่วมกับ plan mode
-->
