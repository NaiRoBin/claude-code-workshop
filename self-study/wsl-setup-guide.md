# Self-study: ติดตั้ง WSL แล้วรัน Claude Code บน WSL

> เอกสารนี้อ่านเองภายหลัง — **ไม่ได้สอนสดในคลาส** เพราะการติดตั้ง WSL ต้องมีสิทธิ์ **admin**
> ซึ่งเครื่องในคลาสไม่มี ใช้เมื่อคุณมีเครื่องที่เป็น admin ของตัวเอง

## ทำไมต้องมี admin
การเปิด WSL ต้องเปิด Windows optional features:
- **Virtual Machine Platform**
- **Windows Subsystem for Linux**

การเปิด feature เหล่านี้ (`wsl --install`) **บังคับใช้สิทธิ์ admin** — ไม่มีวิธี bypass ที่ถูกต้อง

## ขั้นตอน (บนเครื่องที่คุณมี admin)

### 1) ติดตั้ง WSL + Ubuntu
เปิด PowerShell **as administrator**:
```powershell
wsl --install
# หรือระบุ distro:  wsl --install -d Ubuntu
```
รีสตาร์ตเครื่องตามที่ระบบแจ้ง แล้วตั้ง username/password ของ Ubuntu

### 2) อัปเดต + ติดตั้ง Node ใน WSL
เปิด Ubuntu (WSL) แล้ว:
```bash
sudo apt update && sudo apt upgrade -y
# ติดตั้ง Node LTS ผ่าน nvm (ไม่ต้องใช้ sudo)
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.bashrc
nvm install --lts
node -v
```

### 3) ติดตั้ง Claude Code + auth
วิธีที่แนะนำตอนนี้คือ native install (ไม่ผ่าน npm) — อัปเดตตัวเองอัตโนมัติด้วย:
```bash
curl -fsSL https://claude.ai/install.sh | bash
export ANTHROPIC_API_KEY="sk-ant-xxxx"   # เพิ่มลง ~/.bashrc ให้ถาวร
claude --version
```

### 4) ใช้งาน
```bash
cd ~/myproject
claude
```

## SSH จาก Windows → WSL (ตามโจทย์เดิม)
ถ้าอยากฝึก workflow "SSH จาก Windows ไป WSL":
```bash
# ใน WSL: ติดตั้งและเปิด ssh server
sudo apt install -y openssh-server
sudo service ssh start
ip addr | grep inet        # ดู IP ของ WSL
```
จาก Windows: `ssh <wsl-user>@<wsl-ip>` แล้วรัน `claude` ใน WSL

> เทียบกับคลาส: แนวคิดเดียวกับ optional capstone (SSH ไปรัน Claude Code บน Linux)
> ต่างกันแค่ Linux อยู่ในเครื่อง (WSL) แทนที่จะเป็น VM ภายนอก

## อ้างอิงในคลาส
- พื้นฐาน Claude Code: `../lab/02-claude-code-basics.md`
- Skills: `../lab/03-skills.md`
- Use case: `../lab/04-use-case-build-workshop.md`
