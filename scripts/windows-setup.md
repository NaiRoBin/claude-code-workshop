# Windows setup (no-admin) — สรุปคำสั่งสำหรับผู้เรียน/ผู้สอน

> เป็น **เอกสาร** ไม่ใช่ `.ps1` เพราะ execution policy ของเครื่องอาจบล็อกสคริปต์
> ให้ก๊อปคำสั่งทีละบล็อกไปวางใน PowerShell (ไม่ต้อง Run as administrator)

## 1) Node.js ผ่าน fnm
```powershell
winget install Schniz.fnm
fnm env --use-on-cd | Out-String | Invoke-Expression
fnm install --lts
fnm use lts-latest
node -v; npm -v
```
ถ้าไม่มี `winget`: โหลด `fnm.exe` จาก https://github.com/Schniz/fnm/releases วางในโฟลเดอร์ที่อยู่ใน PATH ของ user

## 2) Claude Code (native install)
```powershell
irm https://claude.ai/install.ps1 | iex
claude --version
```
ถ้า `irm` ไม่รู้จัก (อยู่ใน CMD ไม่ใช่ PowerShell):
```bat
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

## 3) API key
```powershell
setx ANTHROPIC_API_KEY "sk-ant-xxxxxxxx"
# ปิด-เปิด terminal ใหม่
```

## 4) (ทางเลือก) Git for Windows
ติดตั้งแบบ user-level เพื่อได้ `git` + `ssh` + Git Bash: https://git-scm.com/download/win

## 5) ทดสอบ
```powershell
mkdir hello-claude; cd hello-claude; claude
```

> รายละเอียดเต็ม + checkpoint ดูที่ `../lab/01-windows-setup.md`
