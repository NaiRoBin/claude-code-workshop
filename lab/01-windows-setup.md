# Lab 01 — ติดตั้ง Claude Code บน Windows (ไม่ต้องมี admin)

> เวลา ~35 นาที · เป้าหมาย: มี Claude Code ใช้งานได้, auth ผ่าน API key, และต่อ SSH เข้า VM ได้
> ทุกขั้นตอนออกแบบให้ทำได้โดย **ไม่ต้องมีสิทธิ์ admin**
> ลำดับ: ติดตั้ง → API key → ทดสอบใช้งานจริงบนเครื่องตัวเอง → ต่อ SSH เข้า VM (ทำทีหลังสุด
> เพราะต้องรอไฟล์ key จากผู้สอน)

---

## 0. เปิด terminal
ใช้ **Windows Terminal** หรือ **PowerShell** (ไม่ต้อง Run as administrator)
> แนะนำให้ติดตั้ง **Git for Windows** ไว้ด้วย (มี `git` + `ssh` + Git Bash) — ตัวติดตั้งเลือกแบบ user-level ได้ ไม่ต้อง admin

---

## 1. ติดตั้ง Claude Code (native install)

วิธีที่ทางการแนะนำตอนนี้คือ **native install** (ไม่ใช่ผ่าน npm แล้ว) — ลงแบบ user-level ไม่ต้อง admin และอัปเดตตัวเองอัตโนมัติ ไม่ต้องมี Node/npm ก่อนเลย

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
>
> อ้างอิง: https://code.claude.com/docs/en/quickstart#native-install-recommended

### ✅ Checkpoint 1
```powershell
claude --version
```

---

## 2. ตั้งค่า API key (auth)

ผู้สอนแจก `ANTHROPIC_API_KEY` (จาก Anthropic Console — 1 key/คน มี spend limit)

**ตั้งชั่วคราวใน session:**
```powershell
$env:ANTHROPIC_API_KEY = "sk-ant-xxxxxxxx"
```

**ตั้งถาวรสำหรับ user (ไม่ต้อง admin):**
```powershell
setx ANTHROPIC_API_KEY "sk-ant-xxxxxxxx"
# ปิด-เปิด terminal ใหม่ให้ค่ามีผล
```

> ⚠️ อย่าแชร์ key · อย่า commit key ลง git

---

## 3. รัน Claude Code ครั้งแรก
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

### ✅ Checkpoint 3
มีไฟล์ `hello.txt` เกิดขึ้น และเนื้อหาตรงตามสั่ง = Claude Code บน Windows ใช้ได้จริงแล้ว
(ยังไม่ต้องมี VM ในขั้นนี้ — ไปต่อขั้นที่ 4 เพื่อต่อ SSH)

---

## 4. ต่อ SSH ไป VM ให้ non-interactive (สำคัญมาก)

ตั้งแต่ lab 02 เป็นต้นไป Claude Code (ที่รันอยู่บน Windows) จะสั่งงานผ่าน `ssh myvm "<คำสั่ง>"`
ไปทำงานบน VM ที่ผู้สอนเตรียมไว้ ดังนั้น ssh **ต้องไม่ค้างรอ prompt** ขั้นตอนนี้ทำทีหลังสุดเพราะ
ต้องรอรับไฟล์ key จากผู้สอนก่อน — **ทุกคนในคลาสใช้ key ไฟล์เดียวกัน** (ผู้สอนแจกให้ครั้งเดียว
ไม่ต้องสร้าง key เอง ไม่ต้องส่งอะไรกลับ)

**ขั้นที่ 1 — รับไฟล์ key จากผู้สอน**
ผู้สอนจะแจกไฟล์ `.pem` ตัวเดียวกันให้ทุกคน (เช่น ผ่านลิงก์ดาวน์โหลด/แชทกลุ่ม) — โหลดมาวางไว้ที่
`~/.ssh/` เช่น `C:\Users\<you>\.ssh\workshop.pem`

> 🔒 ไฟล์นี้ทุกคนในคลาสมีเหมือนกัน (เพื่อความง่าย ไม่ต้องแลก key กันไปมา) แต่แปลว่าใครถือไฟล์นี้
> ก็ ssh เข้า VM ของคนอื่นในคลาสได้ด้วย — เป็น trade-off ที่ตั้งใจยอมรับสำหรับ workshop วันเดียว
> อย่าเอาไฟล์นี้ไปใช้ที่อื่น/เก็บไว้ใช้ต่อหลังคลาสจบ

**ขั้นที่ 2 — รับ VM_IP กับ username ของคุณจากผู้สอน**
ผู้สอนจะส่งมา 2 ค่าที่เป็นของคุณคนเดียว เช่น `VM_IP = 13.212.xx.xx` และ `username = student07`
— จำไว้ใช้ในขั้นต่อไป (key ไฟล์เดียวกันทุกคน แต่ IP/username ของแต่ละคนต่างกัน)

**ขั้นที่ 3 — สร้าง/แก้ไฟล์ `~/.ssh/config`**
เปิดไฟล์นี้ด้วย Notepad (ไฟล์นี้ไม่มีนามสกุล ไม่ใช่ `.txt`):
```powershell
notepad $env:USERPROFILE\.ssh\config
```
ถ้า Notepad ถามว่าจะสร้างไฟล์ใหม่ไหม ให้กด **Yes** — แล้ววางข้อความนี้ลงไป:
```
Host myvm
    HostName <VM_IP>
    User <student-user>
    IdentityFile ~/.ssh/workshop.pem
    StrictHostKeyChecking accept-new
```
**สำคัญ:** ต้องแทนที่ `<VM_IP>` และ `<student-user>` ด้วยค่าจริงจากขั้นที่ 2 (เช่น
`HostName 13.212.xx.xx` และ `User student07`) — ถ้าปล่อยเป็น placeholder ไว้เฉย ๆ, ssh
จะพยายามหา host ชื่อ `myvm` ทาง DNS จริง ๆ (เพราะไม่มี `Host myvm` ที่ match) แล้วขึ้น
error `Could not resolve hostname myvm` — เช็คให้ดีว่า save ไฟล์แล้ว (Ctrl+S) และปิด Notepad

**ขั้นที่ 4 — ทดสอบ**
```bash
ssh myvm "uname -a"      # ต้องได้ผลลัพธ์ทันที ไม่ถาม yes/no ไม่ถามรหัส
```

### ✅ Checkpoint 4
`ssh myvm "hostname"` ทำงานได้แบบไม่ถามอะไรเลย = พร้อมให้ Claude Code สั่งข้าม SSH ใน lab ถัดไป

> ถ้าเจอ `Could not resolve hostname myvm` → ไม่มี `Host myvm` ใน config จริง (ไฟล์ไม่มี/
> พิมพ์ผิด/ยังเป็น placeholder) กลับไปขั้นที่ 3 ใหม่ — ดูรายละเอียดเพิ่มที่
> [`99-troubleshooting.md`](99-troubleshooting.md)

> 💡 fallback A: ถ้าใครลง Claude Code บน Windows ไม่ได้ (Checkpoint 1 ไม่ผ่าน) → `ssh myvm`
> เข้าไป แล้วลง Claude Code (native install แบบเดียวกัน แต่รันบน VM) แล้วรัน `claude`
> **บน VM** ทำ lab ที่เหลือจากในนั้นแทน (ขั้นตอนเนื้อหาเหมือนกันทุกอย่าง)

---

## ติดปัญหา?
- ลง Claude Code ไม่ได้ → ดู [`99-troubleshooting.md`](99-troubleshooting.md)
- ถ้ายังไม่ได้จริง ๆ → ใช้ **fallback A**: SSH เข้า VM แล้วรัน Claude Code บน VM แทน
  (ดู [`05-capstone.md`](05-capstone.md) หัวข้อการต่อ SSH)
