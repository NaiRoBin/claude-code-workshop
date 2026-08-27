# Lab 05 — Capstone: Claude Code สั่งงานข้าม SSH ไป VM

> เวลา ~45 นาที · **remote orchestration + งาน ops จริง**
>
> เป้าหมาย: ให้ **Claude Code (บน Windows)** สั่งงานข้าม SSH ไปติดตั้ง PostgreSQL + Grafana
> บน Linux VM แล้วสร้าง dashboard — ข้อมูลจาก ServiceDesk Plus (option) หรือ mock

---

ก่อนเริ่ม ทวนว่า `ssh myvm "hostname"` (จาก lab 01) ยังทำงานได้แบบไม่ถามอะไรเลย
ถ้าไม่ผ่านให้กลับไปทำ lab 01 หัวข้อ SSH ก่อน

> 💡 fallback A: ถ้าใครลง Claude Code บน Windows ไม่ได้ → `ssh myvm` เข้าไป แล้วลง Claude Code
> (native install แบบเดียวกับ lab 01 แต่รันบน VM) ก่อน จึงรัน `claude` **บน VM** ทำ capstone
> จากในนั้นแทน (ขั้นตอนเนื้อหาเหมือนกัน)

---

## 1. ให้ Claude Code ติดตั้ง PostgreSQL บน VM (10 นาที)

เปิด `claude` บน Windows แล้วสั่ง (ตัวอย่าง prompt):
```
เราจะทำงานบน remote VM ผ่านคำสั่ง `ssh myvm "..."`
ช่วยติดตั้ง PostgreSQL บน VM, สร้าง database ชื่อ itsm,
และสร้างตาราง requests (id, subject, status, priority, created_at)
รันทีละขั้น ตรวจผลแต่ละขั้นก่อนไปต่อ
```
- ดูว่า Claude วางแผน แล้วยิง `ssh myvm "sudo apt-get install -y postgresql ..."` ให้
- ตรวจ: `ssh myvm "sudo -u postgres psql -d itsm -c '\dt'"`

---

## 2. ดึงข้อมูล — ServiceDesk Plus (option) หรือ mock (10 นาที)

**ทางเลือก A — ServiceDesk Plus API จริง** (ผู้สอนแจก endpoint + token):
```
เขียนสคริปต์ (บน VM) ดึงข้อมูล request จาก ServiceDesk Plus API
ที่ $SDP_BASE_URL โดยใช้ token จาก env $SDP_TOKEN
แล้ว insert ลงตาราง requests ใน postgres
(อย่า hardcode token — อ่านจาก environment)
```

**ทางเลือก B — mock (เมื่อ ServiceDesk Plus ไม่พร้อม/ช้า):**
รัน mock server แล้วชี้สคริปต์มาที่มันแทน
```
# บน VM
node ~/servicedesk-mock/mock-server.js &   # เสิร์ฟที่ http://localhost:8080/requests
```
แล้วสั่ง Claude ให้ดึงจาก `http://localhost:8080/requests` เข้าตาราง

> ไฟล์ mock อยู่ที่ `../scripts/servicedesk-mock/` (คัดลอกขึ้น VM ตอน provision)

### ✅ Checkpoint 2
`ssh myvm "sudo -u postgres psql -d itsm -c 'select count(*) from requests;'"` มีจำนวนแถว > 0

---

## 3. ให้ Claude Code ติดตั้ง Grafana + สร้าง dashboard (15 นาที)
```
ติดตั้ง Grafana บน VM (พอร์ต 3000), เพิ่ม PostgreSQL (db itsm) เป็น data source,
แล้วสร้าง dashboard แสดง: จำนวน request ตาม status (bar) และตาม priority (pie)
```

เปิดดูผลบน browser Windows ผ่าน **port forward** (ทำใน terminal แยก เพราะ tunnel ค้าง):
```bash
ssh -L 3000:localhost:3000 myvm
```
แล้วเปิด `http://localhost:3000` (login เริ่มต้น Grafana: admin/admin แล้วเปลี่ยนรหัส)

### ✅ Checkpoint 3
เห็น dashboard ใน browser ที่ `http://localhost:3000` แสดงข้อมูลจากตาราง requests

---

## สรุป capstone
คุณเพิ่งใช้ Claude Code เป็น **agent orchestrate remote Linux** ผ่าน SSH ตั้งแต่ติดตั้ง DB,
ดึงข้อมูล, ไปจนตั้ง dashboard — โดยไม่ต้องลงมือพิมพ์คำสั่งเองทีละบรรทัด

ไปต่อ [`06-wrapup.md`](06-wrapup.md)
