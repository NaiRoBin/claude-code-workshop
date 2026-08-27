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
Claude Code รันได้, auth ผ่าน API key สำเร็จ, และต่อ SSH เข้า VM ได้แบบ non-interactive
เน้นย้ำ selling point ของ lab นี้: ทุกขั้นตอนออกแบบมาให้ทำได้โดยไม่ต้องมีสิทธิ์ admin
บนเครื่อง Windows ขององค์กร/บริษัท ซึ่งมักเป็นข้อจำกัดจริงของผู้เรียนในห้อง
-->

---

## ภาพรวม Lab 01

- ⏱ เวลา ~35 นาที
- 🎯 เป้าหมาย: มี **Claude Code** ใช้งานได้, **auth ผ่าน API key**, และ **ต่อ SSH เข้า VM ได้**
- 🔑 หลักการสำคัญ: **ทุกขั้นตอนออกแบบให้ทำได้โดยไม่ต้องมีสิทธิ์ admin**

<!--
ให้ผู้เรียนกางหน้าจอ terminal ไว้รอเลยตั้งแต่สไลด์นี้ เพื่อ warm-up
ย้ำว่าถ้าใครมีสิทธิ์ admin อยู่แล้วก็ทำตามขั้นตอนเดียวกันได้ปกติ ไม่มีอะไรเสีย
แต่จุดสำคัญคือคนที่ "ไม่มี" admin ต้องไม่ตกขบวน
ย้ำด้วยว่า lab นี้ไม่มีขั้นตอนติดตั้ง Node/npm อีกแล้ว — Node (ถ้าต้องใช้) จะอยู่บน VM
ที่ผู้สอน provision ไว้ล่วงหน้า ไม่ใช่บนเครื่อง Windows ของผู้เรียน
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

<!--
อ้างอิงจาก https://code.claude.com/docs/en/quickstart#native-install-recommended
native install เป็น standalone binary ไม่ต้องพึ่ง Node/npm เลยสำหรับตัว Claude Code เอง
lab นี้จึงไม่มีขั้นตอนลง Node/fnm อีกแล้ว — ต่างจากเวอร์ชันก่อนหน้าที่ให้ลง Node ไว้ใช้กับ
sample-project บนเครื่องตัวเอง ตอนนี้ sample-project ย้ายไปอยู่บน VM แล้ว (ดู lab 02)
ถ้าเจอปัญหาแปลกๆกับ install script ให้ดู https://code.claude.com/docs/en/troubleshoot-install
-->

---

## ✅ Checkpoint 1

```powershell
claude --version
```

<!--
ถ้าเจอ error "command not found" ให้ปิด-เปิด terminal ใหม่ (PATH ยังไม่ถูก apply)
นี่คือจุดที่ยืนยันว่า Claude Code ติดตั้งสำเร็จแล้ว ก่อนจะไปตั้งค่า SSH เข้า VM ในขั้นต่อไป
-->

---

<!-- _class: lead -->
# 2. ต่อ SSH ไป VM ให้ non-interactive
## (สำคัญมาก)

<!--
section นี้ยกมาจาก capstone เดิม (lab 05) เพราะตอนนี้ทุก lab ตั้งแต่ lab 02 เป็นต้นไป
ใช้ VM เป็น workspace หลัก ไม่ใช่แค่ capstone อีกต่อไป — ถ้า ssh ยังถาม prompt
Claude Code จะสั่งงานข้าม ssh ไม่ได้เลย ต้องเน้นให้ผู้เรียนทำจนผ่าน checkpoint นี้ก่อนไปต่อ
-->

---

## ทำไมต้อง non-interactive

ตั้งแต่ lab 02 เป็นต้นไป Claude Code จะสั่งงานผ่าน `ssh myvm "<คำสั่ง>"`

ดังนั้น ssh **ต้องไม่ค้างรอ prompt** ไม่ว่าจะเป็น:
- ถามยืนยัน host key (yes/no)
- ถามรหัสผ่าน (password)

ถ้า ssh ค้างรอ prompt → Claude Code จะสั่งงานต่อไม่ได้ (agent ค้าง)

> ⚠️ นี่คือจุดพลาดอันดับหนึ่งของ workshop นี้: ssh ค้างรอ prompt โดยไม่มีใครไปตอบ
> ทำให้ Claude Code ดูเหมือน "แฮงค์" ทั้งที่จริง ๆ คือรอ input จากคน

<!--
เน้นย้ำ concept นี้ก่อนลงมือ เพราะเป็นสาเหตุหลักที่ทำให้ lab 02 เป็นต้นไปล้มตั้งแต่ต้น
ถ้ามีคนถามว่าทำไม Claude ไม่ตอบ ให้เดาว่าน่าจะติดที่ ssh prompt ก่อนอื่น
-->

---

## ขั้นตอน 1 — สร้าง SSH key

สร้าง key (ถ้ายังไม่มี):

```bash
ssh-keygen -t ed25519 -C "workshop"
```

ผู้สอนแจก host/user + ติดตั้ง public key บน VM ให้แล้ว
(หรือทำตามที่ผู้สอนบอก)

<!--
ผู้สอนควรเตรียม host/user/public key ไว้ล่วงหน้าให้แต่ละคนก่อน lab นี้เริ่ม
(provision VM ล่วงหน้าด้วย scripts/provision-vm.sh)
-->

---

## ขั้นตอน 2 — ตั้งค่า `~/.ssh/config`

ตั้ง `~/.ssh/config` ให้เรียกสั้น ๆ และไม่ถาม host key:

```
Host myvm
    HostName <VM_IP>
    User <student-user>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking accept-new
```

- `Host myvm` ทำให้เรียก `ssh myvm` สั้น ๆ ได้ ไม่ต้องพิมพ์ IP/user ทุกครั้ง
- `StrictHostKeyChecking accept-new` คือกันไม่ให้ถาม yes/no ตอน host key ใหม่

<!--
อธิบายว่าทำไมต้องมีทั้งสองบรรทัดนี้ Host alias ช่วยให้ prompt สั่งงานสั้นและอ่านง่าย
ส่วน StrictHostKeyChecking accept-new คือกุญแจสำคัญที่ทำให้ ssh ไม่ค้างถาม prompt
-->

---

## ขั้นตอน 3 — ทดสอบ SSH

```bash
ssh myvm "uname -a"      # ต้องได้ผลลัพธ์ทันที ไม่ถาม yes/no ไม่ถามรหัส
```

ถ้าได้ผลลัพธ์ทันที ไม่มี prompt ใด ๆ = ตั้งค่าสำเร็จ

> ⚠️ ถ้ายังเจอ prompt ถามรหัสผ่าน หรือค้างรอ yes/no ให้แก้ก่อนไปต่อ
> ห้ามข้ามไปขั้นถัดไปทั้งที่ ssh ยังไม่ non-interactive

<!--
ให้ผู้เรียนรันคำสั่งนี้จริง ๆ ต่อหน้า แล้วสังเกตว่าไม่มี prompt ใด ๆ โผล่มา
ถ้ายังมี prompt ให้ตรวจ ~/.ssh/config และ public key ที่ผู้สอนติดตั้งไว้บน VM
-->

---

## ✅ Checkpoint 2

`ssh myvm "hostname"` ทำงานได้แบบไม่ถามอะไรเลย
= พร้อมให้ Claude Code สั่งข้าม SSH ตั้งแต่ lab 02 เป็นต้นไป

<!--
นี่คือ gate สำคัญของทั้งวัน ไม่ใช่แค่ capstone อีกต่อไป ถ้าผ่าน checkpoint นี้ไม่ได้
lab 02-05 ที่ให้ Claude Code สั่งงานข้าม ssh จะล้มเหลวหรือค้างหมด
เดินสำรวจห้องให้แน่ใจว่าทุกคน (หรือกลุ่ม) ผ่านจุดนี้ก่อนไปต่อ
-->

---

## 💡 Fallback A

ถ้าใครลง Claude Code บน Windows ไม่ได้ (Checkpoint 1 ไม่ผ่าน):

- `ssh myvm` เข้าไป แล้วลง Claude Code (native install แบบเดียวกัน แต่รันบน VM)
- รัน `claude` **บน VM** ทำ lab ที่เหลือทั้งวันจากในนั้นแทน
- ขั้นตอนเนื้อหาเหมือนกันทุกอย่าง เพียงแค่ Claude Code รันอยู่บน VM
  โดยตรง ไม่ต้องสั่งงานข้าม ssh อีกที

> 💡 ทางเลือกนี้ช่วยให้ไม่มีใครตกขบวนเพราะปัญหาติดตั้งบน Windows

<!--
เตรียม fallback นี้ไว้ล่วงหน้าสำหรับคนที่ลง Claude Code บน Windows ไม่สำเร็จ
ให้เข้าไปรัน claude บน VM ตรง ๆ เนื้อหาที่สอนเหมือนกันหมด แค่ไม่ต้องสั่งผ่าน ssh ซ้อน
กรณีนี้ต้องลง Claude Code บน VM ด้วย (ปกติ default path ไม่ต้องลง Claude Code บน VM เลย)
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

มีไฟล์ `hello.txt` เกิดขึ้น และเนื้อหาตรงตามสั่ง (ยืนยันว่า Claude Code บน Windows ใช้ได้จริง)
**และ** `ssh myvm "hostname"` จาก Checkpoint 2 ยังทำงานได้แบบไม่ถามอะไรเลย
= ติดตั้งครบและพร้อมไปทำงานบน VM ใน lab ถัดไป 🎉

<!--
เดินเช็คทุกโต๊ะว่าเห็นไฟล์ hello.txt จริง และเนื้อหาในไฟล์ตรงกับที่สั่งไป
("สวัสดี Claude Code") พร้อมทวนว่า ssh myvm ยังทำงานได้แบบไม่ถามอะไร (จาก checkpoint 2)
ถ้าใครยังไม่ผ่านทั้งสองอย่าง ให้หยุดรอตรงนี้ก่อน เพราะ lab ถัดไปทั้งหมดต้องอาศัยทั้งคู่
ถือเป็นจุด milestone แรกของทั้ง workshop — ควรให้เวลาผู้เรียน celebrate เล็กน้อย
-->

---

## ติดปัญหา?

- ลง Claude Code ไม่ได้ → ดู [`99-troubleshooting.md`](../lab/99-troubleshooting.md)
- ถ้ายังไม่ได้จริง ๆ → ใช้ **fallback A**: SSH เข้า VM แล้วรัน Claude Code บน VM แทน
  (ดู [`05-capstone.md`](../lab/05-capstone.md) หัวข้อการต่อ SSH)

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
เชื่อมไปยัง Lab 02 ซึ่งเป็นเนื้อหาพื้นฐานการใช้งาน Claude Code จริงบน sample-project
ที่ provision ไว้บน VM แล้ว (Claude Code สั่งงานข้าม SSH ไปทำงานที่นั่น) รวมถึงการสั่งงาน
แก้ไฟล์ รันคำสั่ง ใช้ /commands ทำความเข้าใจ permission, git, และ plan mode —
ตรวจสอบว่าทุกคนพร้อมแล้วก่อนข้ามไป lab ถัดไป
-->
