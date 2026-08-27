# Lab 01 — ติดตั้ง Claude Code บน Windows (ไม่ต้องมี admin)

> เวลา ~35 นาที · เป้าหมาย: มี Claude Code ใช้งานได้, auth ผ่าน API key, และต่อ SSH เข้า VM ได้
> ทุกขั้นตอนออกแบบให้ทำได้โดย **ไม่ต้องมีสิทธิ์ admin**

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

## 2. ต่อ SSH ไป VM ให้ non-interactive (สำคัญมาก)

ตั้งแต่ lab 02 เป็นต้นไป Claude Code (ที่รันอยู่บน Windows) จะสั่งงานผ่าน `ssh myvm "<คำสั่ง>"`
ไปทำงานบน VM ที่ผู้สอนเตรียมไว้ ดังนั้น ssh **ต้องไม่ค้างรอ prompt** ขั้นตอนนี้มี 2 ฝั่งที่ต้อง
ตรงกัน — **คุณ** สร้าง key แล้วส่ง public key ให้ผู้สอน, **ผู้สอน** เอา public key ไปติดตั้งบน VM
แล้วส่ง IP/username ของ VM คุณกลับมา ถ้าข้ามขั้นไหนไปจะเจอ error `Could not resolve hostname myvm`
หรือ `Permission denied` ตอนทดสอบ

**ขั้นที่ 1 — สร้าง SSH key (ถ้ายังไม่มี)**
```bash
ssh-keygen -t ed25519 -C "workshop"
```
กด Enter รัวๆ ผ่านทุกคำถามได้เลย (ไม่ต้องตั้ง passphrase) จะได้ไฟล์ 2 ไฟล์ที่ `~/.ssh/`:
`id_ed25519` (**private key** — ห้ามให้ใครดู/ส่งให้ใคร) และ `id_ed25519.pub` (**public key**
— อันนี้ส่งให้ผู้สอนได้ปลอดภัย)

**ขั้นที่ 2 — เอา public key ไปส่งให้ผู้สอน**
```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub
```
จะได้ข้อความยาว 1 บรรทัด ขึ้นต้นด้วย `ssh-ed25519 AAAA...` — copy ทั้งบรรทัดส่งให้ผู้สอน
ตามวิธีที่ผู้สอนบอก (เช่น พิมพ์ในแชทกลุ่มของคลาส) แล้ว**รอผู้สอนติดตั้งให้บน VM**

**ขั้นที่ 3 — รับ VM_IP กับ username ของคุณจากผู้สอน**
ผู้สอนจะส่งกลับมา 2 ค่า เช่น `VM_IP = 13.212.xx.xx` และ `username = student07` — จำไว้ใช้ในขั้นต่อไป

**ขั้นที่ 4 — สร้าง/แก้ไฟล์ `~/.ssh/config`**
เปิดไฟล์นี้ด้วย Notepad (ไฟล์นี้ไม่มีนามสกุล ไม่ใช่ `.txt`):
```powershell
notepad $env:USERPROFILE\.ssh\config
```
ถ้า Notepad ถามว่าจะสร้างไฟล์ใหม่ไหม ให้กด **Yes** — แล้ววางข้อความนี้ลงไป:
```
Host myvm
    HostName <VM_IP>
    User <student-user>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking accept-new
```
**สำคัญ:** ต้องแทนที่ `<VM_IP>` และ `<student-user>` ด้วยค่าจริงจากขั้นที่ 3 (เช่น
`HostName 13.212.xx.xx` และ `User student07`) — ถ้าปล่อยเป็น `<VM_IP>`/`<student-user>`
แบบ placeholder ไว้เฉย ๆ, ssh จะพยายามหา host ชื่อ `myvm` ทาง DNS จริง ๆ (เพราะไม่มี
`Host myvm` ที่ match) แล้วขึ้น error `Could not resolve hostname myvm` — เช็คให้ดีว่า
save ไฟล์แล้ว (Ctrl+S) และปิด Notepad

**ขั้นที่ 5 — ทดสอบ**
```bash
ssh myvm "uname -a"      # ต้องได้ผลลัพธ์ทันที ไม่ถาม yes/no ไม่ถามรหัส
```

### ✅ Checkpoint 2
`ssh myvm "hostname"` ทำงานได้แบบไม่ถามอะไรเลย = พร้อมให้ Claude Code สั่งข้าม SSH ใน lab ถัดไป

> ถ้าเจอ `Could not resolve hostname myvm` → ไม่มี `Host myvm` ใน config จริง (ไฟล์ไม่มี/
> พิมพ์ผิด/ยังเป็น placeholder) กลับไปขั้นที่ 4 ใหม่ — ดูรายละเอียดเพิ่มที่
> [`99-troubleshooting.md`](99-troubleshooting.md)

> 💡 fallback A: ถ้าใครลง Claude Code บน Windows ไม่ได้ (Checkpoint 1 ไม่ผ่าน) → `ssh myvm`
> เข้าไป แล้วลง Claude Code (native install แบบเดียวกัน แต่รันบน VM) แล้วรัน `claude`
> **บน VM** ทำ lab ที่เหลือจากในนั้นแทน (ขั้นตอนเนื้อหาเหมือนกันทุกอย่าง)

---

## 3. ตั้งค่า API key (auth)

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

### ✅ Checkpoint 4
มีไฟล์ `hello.txt` เกิดขึ้น และเนื้อหาตรงตามสั่ง (ยืนยันว่า Claude Code บน Windows ใช้ได้จริง)
**และ** `ssh myvm "hostname"` จาก Checkpoint 2 ยังทำงานได้แบบไม่ถามอะไรเลย
= ติดตั้งครบและพร้อมไปทำงานบน VM ใน lab ถัดไป 🎉

---

## ติดปัญหา?
- ลง Claude Code ไม่ได้ → ดู [`99-troubleshooting.md`](99-troubleshooting.md)
- ถ้ายังไม่ได้จริง ๆ → ใช้ **fallback A**: SSH เข้า VM แล้วรัน Claude Code บน VM แทน
  (ดู [`05-capstone.md`](05-capstone.md) หัวข้อการต่อ SSH)
