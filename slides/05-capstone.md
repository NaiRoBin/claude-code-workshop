---
marp: true
title: "Lab 05 — Capstone: ServiceDesk Plus + Grafana Dashboard"
paginate: true
theme: default
---

<!-- _class: lead -->
# Lab 05
# Capstone: Claude Code สั่งงานข้าม SSH ไป VM

<!--
เปิด lab นี้เหมือน lab ก่อนหน้า — เป็นส่วนหนึ่งของ flow หลักของวัน ไม่ใช่ของแถม
ทุกคนทำต่อจาก lab 04 ได้เลย เพราะ VM ที่ใช้ตรงนี้คือ VM เดียวกับที่ใช้มาตั้งแต่ lab 02
-->

---

## ภาพรวม capstone

> เวลา ~45 นาที · **remote orchestration + งาน ops จริง**

**เป้าหมาย:** ให้ **Claude Code (บน Windows)** สั่งงานข้าม SSH ไปติดตั้ง
PostgreSQL + Grafana บน Linux VM แล้วสร้าง dashboard
— ข้อมูลจาก ServiceDesk Plus (option) หรือ mock

<!--
ย้ำภาพรวม flow ทั้งหมดก่อนลงรายละเอียด:
0) ทวนว่า ssh ที่ตั้งไว้ตั้งแต่ lab 01 ยัง non-interactive อยู่
1) ให้ Claude ติดตั้ง postgres บน VM
2) โหลดข้อมูล ServiceDesk Plus หรือ mock
3) ติดตั้ง grafana + สร้าง dashboard + เปิดดูผลตรง ๆ ผ่าน public IP:3000
เน้นว่า Claude Code จะเป็นคนสั่งงานข้าม ssh เอง ผู้เรียนแค่ป้อน prompt
-->

---

## ก่อนเริ่ม — ทวน SSH จาก lab 01

ทวนว่า `ssh myvm "hostname"` (ตั้งไว้แล้วใน lab 01) ยังทำงานได้แบบไม่ถามอะไรเลย

ถ้าไม่ผ่าน → กลับไปทำ lab 01 หัวข้อ "ต่อ SSH ไป VM" ก่อน แล้วค่อยกลับมาต่อที่นี่

<!--
lab นี้ไม่สอน ssh-keygen/~/.ssh/config ซ้ำแล้ว เพราะย้ายไปทำตั้งแต่ lab 01
ให้เช็คเร็ว ๆ ว่าทุกคนยังต่อ ssh myvm ได้แบบไม่มี prompt ก่อนเริ่มสั่งงาน Claude Code
ถ้ามีคนตกหล่น ให้พาไปทำ checkpoint ของ lab 01 ก่อนไปต่อ
-->

---

## 💡 Fallback A

ถ้าใครลง Claude Code บน Windows ไม่ได้:

- `ssh myvm` เข้าไป แล้ว**ลง Claude Code บน VM ก่อน** (native install คำสั่งเดียวกับ
  lab 01 แต่รันบน VM แทน) จึงรัน `claude` **บน VM** ทำ capstone จากในนั้นแทน
- ขั้นตอนเนื้อหาเหมือนกันทุกอย่าง เพียงแค่ Claude Code รันอยู่บน VM
  โดยตรง ไม่ต้องสั่งงานข้าม ssh อีกที

> 💡 ทางเลือกนี้ช่วยให้ไม่มีใครตกขบวนเพราะปัญหาติดตั้งบน Windows

<!--
เตรียม fallback นี้ไว้ล่วงหน้าสำหรับคนที่ลง Claude Code บน Windows ไม่สำเร็จ
ต่างจากเดิม: ต้องลง Claude Code บน VM ก่อนด้วย (native install เหมือนกัน แค่รันบน VM)
เพราะ default architecture ตอนนี้ไม่ได้ติดตั้ง Claude Code บน VM ไว้ล่วงหน้า
เนื้อหาที่สอนเหมือนกันหมด แค่ไม่ต้องสั่งผ่าน ssh ซ้อน
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
และสร้างตาราง requests (id, subject, status, priority, created_at)
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
> ไปเจอ prompt ที่ตั้งค่าไว้ยังไม่ครบ (กลับไปเช็ค checkpoint SSH ของ lab 01)

<!--
ให้ผู้เรียนสังเกตว่า Claude ไม่ได้พิมพ์คำสั่งสุ่ม ๆ แต่วางแผนทีละขั้นและยิงผ่าน ssh
เป็นคำสั่งเดียวกันกับที่คนจะพิมพ์เองถ้านั่งอยู่หน้า terminal ของ VM
คำสั่งตรวจผลด้วย \dt คือดูว่าตาราง requests ถูกสร้างจริงในฐาน itsm
-->

---

<!-- _class: lead -->
# 2. ดึงข้อมูล — ServiceDesk Plus (option) หรือ mock
## 10 นาที

<!--
section นี้มีสองทางเลือก บอกผู้เรียนก่อนว่าให้เลือกทางที่ผู้สอนกำหนด/พร้อมใช้งาน
ถ้า ServiceDesk Plus ล่มหรือช้า ให้สลับไป mock ได้ทันทีไม่ต้องรอ
-->

---

## ทางเลือก A — ServiceDesk Plus API จริง

ผู้สอนแจก endpoint + token ให้:

```
เขียนสคริปต์ (บน VM) ดึงข้อมูล request จาก ServiceDesk Plus API
ที่ $SDP_BASE_URL โดยใช้ token จาก env $SDP_TOKEN
แล้ว insert ลงตาราง requests ใน postgres
(อย่า hardcode token — อ่านจาก environment)
```

> ⚠️ ห้าม hardcode token ในสคริปต์ — ต้องอ่านจาก environment variable เสมอ

<!--
ย้ำเรื่อง security ง่าย ๆ ตรงนี้ — อย่า hardcode token ลงในไฟล์สคริปต์
เพราะสคริปต์อาจถูก commit หรือแชร์ต่อ ให้อ่านจาก env $SDP_TOKEN เท่านั้น
-->

---

## ทางเลือก B — mock (เมื่อ ServiceDesk Plus ไม่พร้อม/ช้า)

รัน mock server แล้วชี้สคริปต์มาที่มันแทน:

```bash
# บน VM
node ~/servicedesk-mock/mock-server.js &   # เสิร์ฟที่ http://localhost:8080/requests
```

แล้วสั่ง Claude ให้ดึงจาก `http://localhost:8080/requests` เข้าตาราง

> ไฟล์ mock อยู่ที่ `../scripts/servicedesk-mock/` (คัดลอกขึ้น VM ตอน provision)

> ⚠️ ถ้า ServiceDesk Plus API จริงล่มหรือตอบช้าระหว่าง lab ให้สลับมาใช้ mock นี้ทันที
> ไม่ต้องเสียเวลารอ — เนื้อหาที่เรียนเหมือนกัน แค่เปลี่ยนปลายทาง URL

<!--
mock server รันเป็น background process ด้วย & บน VM แล้ว serve ที่ localhost:8080
ผู้สอนต้อง provision ไฟล์ ~/servicedesk-mock/mock-server.js ไว้บน VM ล่วงหน้าแล้ว
ให้เตือนผู้เรียนว่าสลับไป mock ได้ตลอดเวลาถ้า ServiceDesk Plus จริงมีปัญหา ไม่ต้องรอแก้
-->

---

## ✅ Checkpoint 2

```bash
ssh myvm "sudo -u postgres psql -d itsm -c 'select count(*) from requests;'"
```

มีจำนวนแถว > 0

<!--
ตรวจสอบง่าย ๆ ว่าข้อมูลเข้าตาราง requests จริง ไม่ว่าจะมาจาก ServiceDesk Plus จริงหรือ mock
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
แล้วสร้าง dashboard แสดง: จำนวน request ตาม status (bar) และตาม priority (pie)
```

<!--
prompt นี้ครอบคลุมสามงาน: ติดตั้ง grafana, ผูก data source เข้ากับ postgres db itsm,
และสร้าง dashboard สอง panel (bar chart ตาม status, pie chart ตาม priority)
ให้ Claude ทำทีละขั้นเหมือนเดิม
-->

---

## เปิดดูผลตรง ๆ ผ่าน public IP

ผู้สอนเปิด security group ของ VM ให้แล้ว (inbound พอร์ต 3000) — เปิด browser
บน Windows แล้วเข้าได้ตรง ๆ ไม่ต้องทำ SSH tunnel:

```
http://<VM_PUBLIC_IP>:3000
```

(login เริ่มต้น Grafana: admin/admin — **ต้องเปลี่ยนรหัสทันที** เพราะพอร์ตนี้เปิดออกสู่อินเทอร์เน็ต)

> ⚠️ พอร์ต 3000 เปิดออกสู่อินเทอร์เน็ตจริง ไม่ใช่แค่ในเครื่อง — ห้ามลืมเปลี่ยนรหัส
> admin/admin เป็นอย่างอื่นทันทีหลัง login ครั้งแรก

<!--
เดิม lab นี้สอน ssh -L port forward แต่ตอนนี้เปลี่ยนมาเปิดพอร์ต 3000 ตรงใน security
group ของ VM แทน (ผู้สอนเตรียมไว้ล่วงหน้าตอน provision) ทำให้ผู้เรียนไม่ต้องกังวลเรื่อง
tunnel ค้าง terminal หรือพอร์ต local ชนอีกต่อไป — แต่ต้องย้ำเรื่องเปลี่ยนรหัส Grafana
เพราะตอนนี้ใครก็เข้าถึง URL นี้ได้ถ้ารู้ IP ไม่ใช่แค่คนที่ ssh เข้าได้เหมือนเดิม
-->

---

## ✅ Checkpoint 3

เห็น dashboard ใน browser ที่ `http://<VM_PUBLIC_IP>:3000`
แสดงข้อมูลจากตาราง requests และเปลี่ยนรหัส admin ของ Grafana จาก default แล้ว

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
ปิด lab 05 แล้วพาไปต่อที่ wrap-up ของ workshop ทั้งหมด — ทุกคนไปด้วยกันที่นี่
-->
