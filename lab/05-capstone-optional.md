# Lab 05 — (Optional) Capstone: Claude Code สั่งงานข้าม SSH ไป VM

> เวลา ~45 นาที · **สำหรับคนอยากลงลึก** (remote orchestration + งาน ops จริง)
> คนที่ไม่ทำ capstone: ต่อยอด mini-project/skill ของตัวเองจาก Lab 04 ต่อได้เลย
>
> เป้าหมาย: ให้ **Claude Code (บน Windows)** สั่งงานข้าม SSH ไปติดตั้ง PostgreSQL + Grafana
> บน Linux VM แล้วสร้าง dashboard — ข้อมูลจาก Ivanti (option) หรือ mock

---

## 0. ต่อ SSH ไป VM ให้ non-interactive (สำคัญมาก) (10 นาที)

Claude Code จะสั่งงานผ่าน `ssh myvm "<คำสั่ง>"` ดังนั้น ssh **ต้องไม่ค้างรอ prompt**

1. สร้าง key (ถ้ายังไม่มี):
   ```bash
   ssh-keygen -t ed25519 -C "workshop"
   ```
2. ผู้สอนแจก host/user + ติดตั้ง public key บน VM ให้แล้ว (หรือทำตามที่ผู้สอนบอก)
3. ตั้ง `~/.ssh/config` ให้เรียกสั้น ๆ และไม่ถาม host key:
   ```
   Host myvm
       HostName <VM_IP>
       User <student-user>
       IdentityFile ~/.ssh/id_ed25519
       StrictHostKeyChecking accept-new
   ```
4. ทดสอบ:
   ```bash
   ssh myvm "uname -a"      # ต้องได้ผลลัพธ์ทันที ไม่ถาม yes/no ไม่ถามรหัส
   ```

### ✅ Checkpoint 0
`ssh myvm "hostname"` ทำงานได้แบบไม่ถามอะไรเลย = พร้อมให้ Claude Code สั่งข้าม SSH

> 💡 fallback A: ถ้าใครลง Claude Code บน Windows ไม่ได้ → `ssh myvm` เข้าไป แล้วรัน `claude` **บน VM** ทำ capstone จากในนั้นแทน (ขั้นตอนเนื้อหาเหมือนกัน)

---

## 1. ให้ Claude Code ติดตั้ง PostgreSQL บน VM (10 นาที)

เปิด `claude` บน Windows แล้วสั่ง (ตัวอย่าง prompt):
```
เราจะทำงานบน remote VM ผ่านคำสั่ง `ssh myvm "..."`
ช่วยติดตั้ง PostgreSQL บน VM, สร้าง database ชื่อ itsm,
และสร้างตาราง incidents (id, subject, status, priority, created_at)
รันทีละขั้น ตรวจผลแต่ละขั้นก่อนไปต่อ
```
- ดูว่า Claude วางแผน แล้วยิง `ssh myvm "sudo apt-get install -y postgresql ..."` ให้
- ตรวจ: `ssh myvm "sudo -u postgres psql -d itsm -c '\dt'"`

---

## 2. ดึงข้อมูล — Ivanti (option) หรือ mock (10 นาที)

**ทางเลือก A — Ivanti STG/SDP API จริง** (ผู้สอนแจก endpoint + token):
```
เขียนสคริปต์ (บน VM) ดึงข้อมูล incident จาก Ivanti SDP API
ที่ $IVANTI_BASE_URL โดยใช้ token จาก env $IVANTI_TOKEN
แล้ว insert ลงตาราง incidents ใน postgres
(อย่า hardcode token — อ่านจาก environment)
```

**ทางเลือก B — mock (เมื่อ Ivanti ไม่พร้อม/ช้า):**
รัน mock server แล้วชี้สคริปต์มาที่มันแทน
```
# บน VM
node ~/ivanti-mock/mock-server.js &   # เสิร์ฟที่ http://localhost:8080/incidents
```
แล้วสั่ง Claude ให้ดึงจาก `http://localhost:8080/incidents` เข้าตาราง

> ไฟล์ mock อยู่ที่ `../scripts/ivanti-mock/` (คัดลอกขึ้น VM ตอน provision)

### ✅ Checkpoint 2
`ssh myvm "sudo -u postgres psql -d itsm -c 'select count(*) from incidents;'"` มีจำนวนแถว > 0

---

## 3. ให้ Claude Code ติดตั้ง Grafana + สร้าง dashboard (15 นาที)
```
ติดตั้ง Grafana บน VM (พอร์ต 3000), เพิ่ม PostgreSQL (db itsm) เป็น data source,
แล้วสร้าง dashboard แสดง: จำนวน incident ตาม status (bar) และตาม priority (pie)
```

เปิดดูผลบน browser Windows ผ่าน **port forward** (ทำใน terminal แยก เพราะ tunnel ค้าง):
```bash
ssh -L 3000:localhost:3000 myvm
```
แล้วเปิด `http://localhost:3000` (login เริ่มต้น Grafana: admin/admin แล้วเปลี่ยนรหัส)

### ✅ Checkpoint 3
เห็น dashboard ใน browser ที่ `http://localhost:3000` แสดงข้อมูลจากตาราง incidents

---

## สรุป capstone
คุณเพิ่งใช้ Claude Code เป็น **agent orchestrate remote Linux** ผ่าน SSH ตั้งแต่ติดตั้ง DB,
ดึงข้อมูล, ไปจนตั้ง dashboard — โดยไม่ต้องลงมือพิมพ์คำสั่งเองทีละบรรทัด

ไปต่อ [`06-wrapup.md`](06-wrapup.md)
