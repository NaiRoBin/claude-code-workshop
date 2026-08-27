---
marp: true
title: "Lab 01 — ติดตั้งบน Windows"
paginate: true
theme: default
---

<!-- _class: lead -->
# Lab 01 — ติดตั้ง Claude Code บน Windows
### (ไม่ต้องมี admin)

<!--
เปิด lab ด้วยการบอกภาพรวมก่อน: เวลาที่ใช้ ~35 นาที และเป้าหมายสุดท้ายคือทุกคนต้องมี
Node + Claude Code รันได้ และ auth ผ่าน API key สำเร็จ
เน้นย้ำ selling point ของ lab นี้: ทุกขั้นตอนออกแบบมาให้ทำได้โดยไม่ต้องมีสิทธิ์ admin
บนเครื่อง Windows ขององค์กร/บริษัท ซึ่งมักเป็นข้อจำกัดจริงของผู้เรียนในห้อง
-->

---

## ภาพรวม Lab 01

- ⏱ เวลา ~35 นาที
- 🎯 เป้าหมาย: มี **Node + Claude Code** ใช้งานได้ และ **auth ผ่าน API key**
- 🔑 หลักการสำคัญ: **ทุกขั้นตอนออกแบบให้ทำได้โดยไม่ต้องมีสิทธิ์ admin**

<!--
ให้ผู้เรียนกางหน้าจอ terminal ไว้รอเลยตั้งแต่สไลด์นี้ เพื่อ warm-up
ย้ำว่าถ้าใครมีสิทธิ์ admin อยู่แล้วก็ทำตามขั้นตอนเดียวกันได้ปกติ ไม่มีอะไรเสีย
แต่จุดสำคัญคือคนที่ "ไม่มี" admin ต้องไม่ตกขบวน
-->

---

## 0. เปิด terminal

ใช้ **Windows Terminal** หรือ **PowerShell** (ไม่ต้อง Run as administrator)

> แนะนำให้ติดตั้ง **Git for Windows** ไว้ด้วย (มี `git` + `ssh` + Git Bash) — ตัวติดตั้งเลือกแบบ user-level ได้ ไม่ต้อง admin

<!--
เช็คให้แน่ใจว่าผู้เรียนไม่ได้เผลอคลิก "Run as administrator" — เพราะ lab นี้ตั้งใจ
ให้ทำแบบ user-level ทั้งหมด ถ้ามีคนถามว่าทำไมไม่ใช้ admin ให้อธิบายว่าในองค์กรจริง
ผู้เรียนอาจไม่มีสิทธิ์นี้ และการติดตั้งแบบ user-level ก็ใช้งานได้เหมือนกัน
ถ้ามีเวลา แนะนำให้ลง Git for Windows คู่กันไปเลยเพราะจะได้ใช้ git/ssh/Git Bash ใน lab ถัดๆไป
-->

---

## 1. ติดตั้ง Node.js แบบ no-admin ด้วย fnm

`fnm` เป็น Node version manager ที่ลงแบบ user-level ได้ ไม่ต้อง admin

```powershell
# ติดตั้ง fnm (ผ่าน winget ถ้ามี — ไม่ต้อง admin เพราะลงใน user scope)
winget install Schniz.fnm

# ถ้าไม่มี winget ให้โหลด fnm.exe จาก GitHub releases แล้ววางในโฟลเดอร์ใน PATH ของ user
# https://github.com/Schniz/fnm/releases

# เปิดใช้ fnm ใน session ปัจจุบัน
fnm env --use-on-cd | Out-String | Invoke-Expression

# ติดตั้ง Node LTS
fnm install --lts
fnm use lts-latest
```

<!--
นี่คือขั้นตอนที่มักใช้เวลานานที่สุดใน lab เพราะ winget/เน็ตของแต่ละคนไม่เท่ากัน
เดินดูรอบห้องระหว่างรอ install เสร็จ
ถ้า winget ไม่มีในเครื่อง (เช่น Windows เก่า หรือถูก block โดย IT) ให้ไปที่ fallback:
โหลด fnm.exe จาก GitHub releases มาวางในโฟลเดอร์ที่อยู่ใน PATH ของ user เอง
ย้ำว่าคำสั่ง fnm env ต้องรันทุกครั้งที่เปิด session ใหม่ (หรือจะไปตั้งใน profile ก็ได้
แต่ในคลาสนี้ไม่ได้ลงรายละเอียดเรื่อง persist ผ่าน profile)
-->

---

## ✅ Checkpoint 1

```powershell
node -v    # ควรได้เวอร์ชัน LTS เช่น v20.x หรือใหม่กว่า
npm -v
```

<!--
เดินตรวจทุกคนว่าเห็นเลขเวอร์ชันจริง ไม่ใช่ error หรือ "command not found"
ถ้ายังไม่เจอ node ให้สงสัยว่า PATH ยังไม่ถูก apply — ให้ปิด-เปิด terminal ใหม่
หรือรันคำสั่ง fnm env อีกครั้งในบรรทัดนั้น
คนที่ผ่าน checkpoint นี้แล้วให้รอเพื่อน อย่าลากไปเร็วเกินไป เพราะขั้นต่อไปต้องมี node ก่อน
-->

---

## 2. ติดตั้ง Claude Code (native install)

วิธีที่ทางการแนะนำตอนนี้คือ **native install** (ไม่ใช่ผ่าน npm แล้ว) — ลงแบบ user-level ไม่ต้อง admin และอัปเดตตัวเองอัตโนมัติ

```powershell
irm https://claude.ai/install.ps1 | iex
```

> ถ้าเจอ error `'irm' is not recognized` แสดงว่าอยู่ใน CMD ไม่ใช่ PowerShell — ให้ใช้:
> ```bat
> curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
> ```
>
> ทางเลือกอื่น (ไม่ auto-update, ต้องรัน `winget upgrade Anthropic.ClaudeCode` เองเป็นระยะ):
> ```powershell
> winget install Anthropic.ClaudeCode
> ```

<!--
อ้างอิงจาก https://code.claude.com/docs/en/quickstart#native-install-recommended
เปลี่ยนจาก npm install -g มาเป็น native installer ตามคำแนะนำล่าสุดของ Anthropic
ข้อดี: ไม่ต้องพึ่ง Node/npm เลยสำหรับตัว Claude Code เอง, ไม่มีปัญหา npm global prefix/permission แบบเดิม,
และตัว installer จะอัปเดต Claude Code ให้อัตโนมัติ (ต่างจาก winget ที่ต้อง upgrade เอง)
ที่ยังให้ลง Node ผ่าน fnm ไว้ในขั้นตอนที่ 1 เพราะ lab capstone (05) ใช้ node รัน mock server ต่างหาก
ไม่เกี่ยวกับการรัน Claude Code
ถ้าเจอปัญหาแปลกๆกับ install script ให้ดู https://code.claude.com/docs/en/troubleshoot-install
-->

---

## ✅ Checkpoint 2

```powershell
claude --version
```

<!--
ถ้าเจอ error "command not found" ให้เช็ค PATH อีกครั้ง (เฉพาะกรณีที่ใช้ custom npm prefix
จาก slide ก่อนหน้า) หรือให้ปิด-เปิด terminal ใหม่
นี่คือจุดที่ยืนยันว่า Claude Code ติดตั้งสำเร็จแล้ว ก่อนจะไปตั้งค่า auth ในขั้นต่อไป
-->

---

## 3. ตั้งค่า API key (auth) — ตั้งชั่วคราว

ผู้สอนแจก `ANTHROPIC_API_KEY` (จาก Anthropic Console — 1 key/คน มี spend limit)

**ตั้งชั่วคราวใน session:**
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-xxxxxxxx"
```

<!--
แจก key ให้ผู้เรียนแต่ละคนตรงนี้ (1 key ต่อคน มี spend limit ตั้งไว้แล้ว)
เตือนว่าวิธีนี้เป็นแบบชั่วคราว มีผลแค่ session ปัจจุบันของ terminal เท่านั้น
ปิด terminal แล้วเปิดใหม่ค่านี้จะหายไป ต้องไปดูสไลด์ถัดไปสำหรับตั้งค่าแบบถาวร
-->

---

## 3. ตั้งค่า API key (auth) — ตั้งถาวร

**ตั้งถาวรสำหรับ user (ไม่ต้อง admin):**
```powershell
setx ANTHROPIC_API_KEY "sk-ant-xxxxxxxx"
# ปิด-เปิด terminal ใหม่ให้ค่ามีผล
```

> ⚠️ อย่าแชร์ key · อย่า commit key ลง git

<!--
ย้ำเรื่องความปลอดภัยของ API key ให้หนักแน่น: ห้ามแชร์ต่อ ห้าม commit ลง git repo
เพราะ key นี้ผูกกับ spend limit ของแต่ละคน ถ้าหลุดออกไปอาจถูกใช้เกินโควต้าหรือถูกเรียกเก็บเงิน
setx จะตั้งค่าแบบถาวรใน user environment variables แต่ต้องปิด-เปิด terminal ใหม่ค่าจึงจะมีผล
เตือนผู้เรียนไม่ให้แปลกใจว่าทำไม echo $env:ANTHROPIC_API_KEY ใน terminal เดิมยังไม่เห็นค่า
-->

---

## 4. รัน Claude Code ครั้งแรก

```powershell
mkdir hello-claude
cd hello-claude
claude
```

ลองพิมพ์:
```
สร้างไฟล์ hello.txt ที่มีข้อความ "สวัสดี Claude Code"
```

สังเกต **permission prompt** ก่อน Claude เขียนไฟล์ → กด allow

<!--
นี่คือช่วง "wow moment" แรกของ workshop — เดินดูรอบห้องว่าทุกคนเห็น permission prompt
จริงหรือไม่ก่อนที่ Claude จะเขียนไฟล์ ให้ผู้เรียนกด allow เอง อย่ากดให้
ใช้จังหวะนี้อธิบายสั้นๆว่า permission prompt คือกลไกความปลอดภัยหลักของ Claude Code
ที่จะเจอซ้ำๆตลอด workshop ก่อนที่มันจะแก้ไฟล์ รันคำสั่ง หรือทำ action ที่มีผลต่อระบบ
-->

---

## ✅ Checkpoint 4

มีไฟล์ `hello.txt` เกิดขึ้น และเนื้อหาตรงตามสั่ง = ติดตั้งครบและใช้งานได้ 🎉

<!--
เดินเช็คทุกโต๊ะว่าเห็นไฟล์ hello.txt จริง และเนื้อหาในไฟล์ตรงกับที่สั่งไป
("สวัสดี Claude Code") ถ้าใครยังไม่ผ่าน checkpoint นี้ ให้หยุดรอตรงนี้ก่อน
เพราะ lab ถัดไปทั้งหมดต้องอาศัยว่า Claude Code ทำงานได้จริงแล้ว
ถือเป็นจุด milestone แรกของทั้ง workshop — ควรให้เวลาผู้เรียน celebrate เล็กน้อย
-->

---

## ติดปัญหา?

- ลง Node/Claude Code ไม่ได้ → ดู [`99-troubleshooting.md`](../lab/99-troubleshooting.md)
- ถ้ายังไม่ได้จริง ๆ → ใช้ **fallback A**: SSH เข้า VM แล้วรัน Claude Code บน VM แทน
  (ดู [`05-capstone-optional.md`](../lab/05-capstone-optional.md) หัวข้อการต่อ SSH)

<!--
สไลด์นี้ไว้เผื่อกรณีมีคนติดปัญหาจริงๆและใช้เวลานานเกินไป
อย่าให้คนที่ติดปัญหาดึงเวลาของคนทั้งห้อง — ให้ผู้ช่วยสอน (ถ้ามี) ไปช่วยแยกต่างหาก
หรือใช้ fallback A คือให้ผู้เรียนคนนั้น SSH เข้า VM ที่เตรียมไว้แล้วรัน Claude Code
บน VM แทน เพื่อให้ตามทันเนื้อหาต่อไปได้ก่อน แล้วค่อยย้อนมาแก้ปัญหาเครื่องตัวเองทีหลัง
-->

---

<!-- _class: lead -->
## ทำต่อ →
### Lab 02 — พื้นฐาน Claude Code + Plan mode

<!--
เชื่อมไปยัง Lab 02 ซึ่งเป็นเนื้อหาพื้นฐานการใช้งาน Claude Code จริงบนโปรเจกต์ตัวอย่าง
รวมถึงการสั่งงาน แก้ไฟล์ รันคำสั่ง ใช้ /commands ทำความเข้าใจ permission, git,
และ plan mode — ตรวจสอบว่าทุกคนพร้อมแล้วก่อนข้ามไป lab ถัดไป
-->
