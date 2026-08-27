# Windows setup (no-admin) — สรุปคำสั่งสำหรับผู้เรียน/ผู้สอน

> เป็น **เอกสาร** ไม่ใช่ `.ps1` เพราะ execution policy ของเครื่องอาจบล็อกสคริปต์
> ให้ก๊อปคำสั่งทีละบล็อกไปวางใน PowerShell (ไม่ต้อง Run as administrator)

## 1) Claude Code (native install)
```powershell
irm https://claude.ai/install.ps1 | iex
claude --version
```
ถ้า `irm` ไม่รู้จัก (อยู่ใน CMD ไม่ใช่ PowerShell):
```bat
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

## 2) ต่อ SSH ไป VM
```powershell
ssh-keygen -t ed25519 -C "workshop"
```
ส่ง public key ให้ผู้สอน (ไม่ใช่ private key):
```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub
```
รอผู้สอนติดตั้งบน VM แล้วส่ง VM_IP/username กลับมา จากนั้นแก้ไฟล์:
```powershell
notepad $env:USERPROFILE\.ssh\config
```
วางแล้ว**แทนที่ `<VM_IP>`/`<student-user>` ด้วยค่าจริง** (ปล่อย placeholder ไว้จะ error
`Could not resolve hostname myvm`):
```
Host myvm
    HostName <VM_IP>
    User <student-user>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking accept-new
```
ทดสอบ (ต้องไม่ถาม yes/no หรือรหัสผ่าน):
```powershell
ssh myvm "uname -a"
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
แล้วยืนยันว่า `ssh myvm "hostname"` ทำงานได้แบบไม่ถามอะไรเลย — lab ถัดไปทำงานบน VM ผ่าน SSH ทั้งหมด

> รายละเอียดเต็ม + checkpoint ดูที่ `../lab/01-windows-setup.md`
