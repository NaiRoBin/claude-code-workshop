---
marp: true
title: "Lab 05 — Capstone (Optional)"
paginate: true
theme: default
---

<!-- _class: lead -->
# Lab 05 (Optional)
# Capstone: Claude Code สั่งงานข้าม SSH ไป VM

<!--
เปิด lab นี้ด้วยการบอกชัด ๆ ว่าเป็น optional
คนที่ไม่ทำ capstone ให้ต่อยอด mini-project/skill ของตัวเองจาก Lab 04 ต่อได้เลย
ไม่ต้องรู้สึกผิดถ้าข้าม ให้เวลากับคนที่อยากลงลึกเรื่อง remote orchestration
-->

---

## ภาพรวม capstone

> เวลา ~45 นาที · **สำหรับคนอยากลงลึก** (remote orchestration + งาน ops จริง)
> คนที่ไม่ทำ capstone: ต่อยอด mini-project/skill ของตัวเองจาก Lab 04 ต่อได้เลย

**เป้าหมาย:** ให้ **Claude Code (บน Windows)** สั่งงานข้าม SSH ไปติดตั้ง
PostgreSQL + Grafana บน Linux VM แล้วสร้าง dashboard
— ข้อมูลจาก Ivanti (option) หรือ mock

<!--
ย้ำภาพรวม flow ทั้งหมดก่อนลงรายละเอียด:
0) ตั้ง ssh ให้ non-interactive
1) ให้ Claude ติดตั้ง postgres บน VM
2) โหลดข้อมูล ivanti หรือ mock
3) ติดตั้ง grafana + สร้าง dashboard + ssh -L ดูผล
เน้นว่า Claude Code จะเป็นคนสั่งงานข้าม ssh เอง ผู้เรียนแค่ป้อน prompt
-->

---

<!-- _class: lead -->
# 0. ต่อ SSH ไป VM ให้ non-interactive
## (สำคัญมาก) — 10 นาที

<!--
section นี้คือ prerequisite ที่พลาดไม่ได้ ถ้า ssh ยังถาม prompt
Claude Code จะสั่งงานข้าม ssh ไม่ได้เลย ต้องเน้นให้ผู้เรียนทำจนผ่าน checkpoint 0 ก่อนไปต่อ
-->

---

## ทำไมต้อง non-interactive

Claude Code จะสั่งงานผ่าน `ssh myvm "<คำสั่ง>"`

ดังนั้น ssh **ต้องไม่ค้างรอ prompt** ไม่ว่าจะเป็น:
- ถามยืนยัน host key (yes/no)
- ถามรหัสผ่าน (password)

ถ้า ssh ค้างรอ prompt → Claude Code จะสั่งงานต่อไม่ได้ (agent ค้าง)

> ⚠️ นี่คือจุดพลาดอันดับหนึ่งของ lab นี้: ssh ค้างรอ prompt โดยไม่มีใครไปตอบ
> ทำให้ Claude Code ดูเหมือน "แฮงค์" ทั้งที่จริง ๆ คือรอ input จากคน

<!--
เน้นย้ำ concept นี้ก่อนลงมือ เพราะเป็นสาเหตุหลักที่ทำให้ capstone ล้มตั้งแต่ต้น
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
ถ้าผู้เรียนมี key อยู่แล้วจาก lab ก่อนหน้า ไม่ต้องสร้างใหม่
ผู้สอนควรเตรียม host/user/public key ไว้ล่วงหน้าให้แต่ละคนก่อน lab นี้เริ่ม
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

## ✅ Checkpoint 0

`ssh myvm "hostname"` ทำงานได้แบบไม่ถามอะไรเลย
= พร้อมให้ Claude Code สั่งข้าม SSH

<!--
นี่คือ gate สำคัญของ lab ทั้งหมด ถ้าผ่าน checkpoint นี้ไม่ได้
ทุกขั้นตอนถัดไปที่ให้ Claude Code สั่งงานข้าม ssh จะล้มเหลวหรือค้าง
เดินสำรวจห้องให้แน่ใจว่าทุกคน (หรือกลุ่ม) ผ่านจุดนี้ก่อนไปต่อ
-->

---

## 💡 Fallback A

ถ้าใครลง Claude Code บน Windows ไม่ได้:

- `ssh myvm` เข้าไป แล้วรัน `claude` **บน VM** ทำ capstone จากในนั้นแทน
- ขั้นตอนเนื้อหาเหมือนกันทุกอย่าง เพียงแค่ Claude Code รันอยู่บน VM
  โดยตรง ไม่ต้องสั่งงานข้าม ssh อีกที

> 💡 ทางเลือกนี้ช่วยให้ไม่มีใครตกขบวนเพราะปัญหาติดตั้งบน Windows

<!--
เตรียม fallback นี้ไว้ล่วงหน้าสำหรับคนที่ลง Claude Code บน Windows ไม่สำเร็จ
ให้เข้าไปรัน claude บน VM ตรง ๆ เนื้อหาที่สอนเหมือนกันหมด แค่ไม่ต้องสั่งผ่าน ssh ซ้อน
-->

---

<!-- _class: lead -->
# 1. ให้ Claude Code ติดตั้ง PostgreSQL บน VM
## 10 นาที

<!--
section นี้คือครั้งแรกที่ผู้เรียนเห็น Claude Code orchestrate remote work จริง ๆ
ให้เปิด claude บน Windows (หรือบน VM ถ้าใช้ fallback A) แล้วส่ง prompt ตัวอย่าง
-->

---

## Prompt ตัวอย่าง

เปิด `claude` บน Windows แล้วสั่ง:

```
เราจะทำงานบน remote VM ผ่านคำสั่ง `ssh myvm "..."`
ช่วยติดตั้ง PostgreSQL บน VM, สร้าง database ชื่อ itsm,
และสร้างตาราง incidents (id, subject, status, priority, created_at)
รันทีละขั้น ตรวจผลแต่ละขั้นก่อนไปต่อ
```

<!--
เน้นว่า prompt นี้บอก Claude ชัดเจนว่าให้ทำงานผ่าน ssh myvm และให้ "รันทีละขั้น
ตรวจผลก่อนไปต่อ" ซึ่งเป็นวิธีคุมความเสี่ยงของ agent ที่สั่งงานบนเครื่อง remote จริง
-->

---

## สิ่งที่ควรสังเกต

- ดูว่า Claude วางแผน แล้วยิงคำสั่งลักษณะ
  ```bash
  ssh myvm "sudo apt-get install -y postgresql ..."
  ```
  ให้เอง
- ตรวจผลด้วยคำสั่ง:
  ```bash
  ssh myvm "sudo -u postgres psql -d itsm -c '\dt'"
  ```

> ⚠️ ถ้า Claude ค้างไม่ตอบระหว่างสั่งงานข้าม ssh มักเป็นเพราะ ssh
> ไปเจอ prompt ที่ตั้งค่าไว้ยังไม่ครบ (กลับไปเช็ค Checkpoint 0)

<!--
ให้ผู้เรียนสังเกตว่า Claude ไม่ได้พิมพ์คำสั่งสุ่ม ๆ แต่วางแผนทีละขั้นและยิงผ่าน ssh
เป็นคำสั่งเดียวกันกับที่คนจะพิมพ์เองถ้านั่งอยู่หน้า terminal ของ VM
คำสั่งตรวจผลด้วย \dt คือดูว่าตาราง incidents ถูกสร้างจริงในฐาน itsm
-->

---

<!-- _class: lead -->
# 2. ดึงข้อมูล — Ivanti (option) หรือ mock
## 10 นาที

<!--
section นี้มีสองทางเลือก บอกผู้เรียนก่อนว่าให้เลือกทางที่ผู้สอนกำหนด/พร้อมใช้งาน
ถ้า Ivanti ล่มหรือช้า ให้สลับไป mock ได้ทันทีไม่ต้องรอ
-->

---

## ทางเลือก A — Ivanti SDP API จริง

ผู้สอนแจก endpoint + token ให้:

```
เขียนสคริปต์ (บน VM) ดึงข้อมูล incident จาก Ivanti SDP API
ที่ $IVANTI_BASE_URL โดยใช้ token จาก env $IVANTI_TOKEN
แล้ว insert ลงตาราง incidents ใน postgres
(อย่า hardcode token — อ่านจาก environment)
```

> ⚠️ ห้าม hardcode token ในสคริปต์ — ต้องอ่านจาก environment variable เสมอ

<!--
ย้ำเรื่อง security ง่าย ๆ ตรงนี้ — อย่า hardcode token ลงในไฟล์สคริปต์
เพราะสคริปต์อาจถูก commit หรือแชร์ต่อ ให้อ่านจาก env $IVANTI_TOKEN เท่านั้น
-->

---

## ทางเลือก B — mock (เมื่อ Ivanti ไม่พร้อม/ช้า)

รัน mock server แล้วชี้สคริปต์มาที่มันแทน:

```bash
# บน VM
node ~/ivanti-mock/mock-server.js &   # เสิร์ฟที่ http://localhost:8080/incidents
```

แล้วสั่ง Claude ให้ดึงจาก `http://localhost:8080/incidents` เข้าตาราง

> ไฟล์ mock อยู่ที่ `../scripts/ivanti-mock/` (คัดลอกขึ้น VM ตอน provision)

> ⚠️ ถ้า Ivanti API จริงล่มหรือตอบช้าระหว่าง lab ให้สลับมาใช้ mock นี้ทันที
> ไม่ต้องเสียเวลารอ — เนื้อหาที่เรียนเหมือนกัน แค่เปลี่ยนปลายทาง URL

<!--
mock server รันเป็น background process ด้วย & บน VM แล้ว serve ที่ localhost:8080
ผู้สอนต้อง provision ไฟล์ ~/ivanti-mock/mock-server.js ไว้บน VM ล่วงหน้าแล้ว
ให้เตือนผู้เรียนว่าสลับไป mock ได้ตลอดเวลาถ้า Ivanti จริงมีปัญหา ไม่ต้องรอแก้
-->

---

## ✅ Checkpoint 2

```bash
ssh myvm "sudo -u postgres psql -d itsm -c 'select count(*) from incidents;'"
```

มีจำนวนแถว > 0

<!--
ตรวจสอบง่าย ๆ ว่าข้อมูลเข้าตาราง incidents จริง ไม่ว่าจะมาจาก Ivanti จริงหรือ mock
ถ้าจำนวนแถวเป็น 0 ให้กลับไปดูว่าสคริปต์ insert รันสำเร็จหรือเจอ error ระหว่างทาง
-->

---

<!-- _class: lead -->
# 3. ให้ Claude Code ติดตั้ง Grafana + สร้าง dashboard
## 15 นาที

<!--
section สุดท้ายของ capstone รวมทุกอย่างเป็น dashboard ที่มองเห็นได้จริงบน browser
เป็นช่วงที่ผู้เรียนจะรู้สึกว่า "งานเสร็จ" เห็นผลลัพธ์เป็นรูปเป็นร่าง
-->

---

## Prompt ติดตั้ง Grafana + dashboard

```
ติดตั้ง Grafana บน VM (พอร์ต 3000), เพิ่ม PostgreSQL (db itsm) เป็น data source,
แล้วสร้าง dashboard แสดง: จำนวน incident ตาม status (bar) และตาม priority (pie)
```

<!--
prompt นี้ครอบคลุมสามงาน: ติดตั้ง grafana, ผูก data source เข้ากับ postgres db itsm,
และสร้าง dashboard สอง panel (bar chart ตาม status, pie chart ตาม priority)
ให้ Claude ทำทีละขั้นเหมือนเดิม
-->

---

## เปิดดูผลผ่าน port forward

เปิดดูผลบน browser Windows ผ่าน **port forward**
(ทำใน terminal แยก เพราะ tunnel ค้าง):

```bash
ssh -L 3000:localhost:3000 myvm
```

แล้วเปิด `http://localhost:3000`
(login เริ่มต้น Grafana: admin/admin แล้วเปลี่ยนรหัส)

> ⚠️ `ssh -L` เป็นคำสั่งที่ค้างอยู่ตลอด (tunnel) — ต้องรันใน terminal แยก
> ห้ามรันในหน้าต่างเดียวกับที่ใช้สั่ง Claude Code เพราะจะบล็อกไม่ให้ใช้ terminal นั้นต่อ

> ⚠️ ถ้าพอร์ต 3000 บนเครื่อง Windows ถูกใช้อยู่แล้ว (พอร์ตชน) ให้เปลี่ยนเลขพอร์ตซ้าย
> เช่น `ssh -L 3001:localhost:3000 myvm` แล้วเปิด `http://localhost:3001` แทน

<!--
สองจุดเตือนสำคัญที่นี่:
1. ssh -L ค้างเป็น tunnel ต้องมี terminal แยกสำหรับมันโดยเฉพาะ
2. ถ้า local port 3000 ชนกับโปรแกรมอื่นบนเครื่อง Windows ของผู้เรียน (เช่นมี service อื่น
   ใช้พอร์ต 3000 อยู่) ให้เปลี่ยนเลขพอร์ตฝั่ง local (ตัวเลขซ้ายของ -L) ได้เลย ไม่ต้องกลัว
-->

---

## ✅ Checkpoint 3

เห็น dashboard ใน browser ที่ `http://localhost:3000`
แสดงข้อมูลจากตาราง incidents

<!--
นี่คือ checkpoint สุดท้ายของ capstone ให้ผู้เรียนโชว์หน้าจอ dashboard จริง ๆ
เห็น bar chart ตาม status และ pie chart ตาม priority มีข้อมูลแสดงผลจริง ไม่ใช่ error
-->

---

## สรุป capstone

คุณเพิ่งใช้ Claude Code เป็น **agent orchestrate remote Linux** ผ่าน SSH
ตั้งแต่ติดตั้ง DB, ดึงข้อมูล, ไปจนตั้ง dashboard
— โดยไม่ต้องลงมือพิมพ์คำสั่งเองทีละบรรทัด

<!--
สรุปภาพใหญ่ว่า flow ทั้งหมดคือ agent orchestration แบบเดียวกับที่ใช้ได้ในงาน ops จริง
ผู้เรียนคุมด้วย prompt + ตรวจ checkpoint แต่ละขั้น ไม่ใช่พิมพ์คำสั่งเองทุกบรรทัด
-->

---

<!-- _class: lead -->
# ทำต่อ →
## `06-wrapup.md`

<!--
ปิด lab 05 (optional) แล้วพาไปต่อที่ wrap-up ของ workshop ทั้งหมด
สำหรับคนที่ไม่ได้ทำ capstone นี้ ให้ไปสมทบที่ wrap-up พร้อมกันได้เลย
-->
