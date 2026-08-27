# Lab 01 — ติดตั้ง Claude Code บน Windows (ไม่ต้องมี admin)

> เวลา ~35 นาที · เป้าหมาย: มี Node + Claude Code ใช้งานได้ และ auth ผ่าน API key
> ทุกขั้นตอนออกแบบให้ทำได้โดย **ไม่ต้องมีสิทธิ์ admin**

---

## 0. เปิด terminal
ใช้ **Windows Terminal** หรือ **PowerShell** (ไม่ต้อง Run as administrator)
> แนะนำให้ติดตั้ง **Git for Windows** ไว้ด้วย (มี `git` + `ssh` + Git Bash) — ตัวติดตั้งเลือกแบบ user-level ได้ ไม่ต้อง admin

---

## 1. ติดตั้ง Node.js แบบ no-admin ด้วย fnm

`fnm` เป็น Node version manager ที่ลงแบบ user-level ได้ ไม่ต้อง admin

**PowerShell:**
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

### ✅ Checkpoint 1
```powershell
node -v    # ควรได้เวอร์ชัน LTS เช่น v20.x หรือใหม่กว่า
npm -v
```

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
>
> อ้างอิง: https://code.claude.com/docs/en/quickstart#native-install-recommended

### ✅ Checkpoint 2
```powershell
claude --version
```

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
มีไฟล์ `hello.txt` เกิดขึ้น และเนื้อหาตรงตามสั่ง = ติดตั้งครบและใช้งานได้ 🎉

---

## ติดปัญหา?
- ลง Node/Claude Code ไม่ได้ → ดู [`99-troubleshooting.md`](99-troubleshooting.md)
- ถ้ายังไม่ได้จริง ๆ → ใช้ **fallback A**: SSH เข้า VM แล้วรัน Claude Code บน VM แทน
  (ดู [`05-capstone-optional.md`](05-capstone-optional.md) หัวข้อการต่อ SSH)
