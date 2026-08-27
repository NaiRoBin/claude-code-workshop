# คู่มือผู้สอน

## ปรัชญาของ workshop นี้
สอน Claude Code **ผ่านการใช้งานจริง** โดยมี 2 แกนหลัก:
1. **Skills** — ติดตั้ง/ใช้/สร้าง skill
2. **Use case จริง** — ให้ผู้เรียนใช้ Claude Code สร้างโปรเจกต์ด้วย workflow เดียวกับที่สร้าง workshop นี้
   (grill-me → plan → generate) — เดโมได้จาก `examples/how-we-built-this.md`

Capstone (ServiceDesk Plus/DB/Grafana) เป็น **ส่วนหนึ่งของ flow หลัก** เพราะ VM ที่ใช้ในนั้น
เป็น workspace เดียวกันที่ใช้มาตั้งแต่ lab 02 — ไม่ใช่ของเสริมสำหรับคนอยากลงลึกอีกต่อไป

## กลุ่มผู้เรียน
คละระดับ (dev/non-dev) ≤ 10 คน → ใช้ **checkpoint** ท้ายแต่ละส่วน, จับคู่ dev ช่วย non-dev, เดินช้าตอนติดตั้ง

## การคุมเวลา (ดู `agenda.md`)
- เช้า: ติดตั้ง + ต่อ SSH เข้า VM + fundamentals + plan mode
- บ่าย: Skills (45') → use case (75') → capstone (45') → wrap-up (15')
- **ถ้าเวลาไม่พอ:** ย่อความลึกของ Skills (สอน skill เดียวพอ) หรือลดโจทย์ mini-project ของ
  use case แทน — ห้ามตัด capstone เพราะรวมเข้า flow หลักแล้ว

## จุดที่มักติด + วิธีกู้ (เตรียมใจไว้)
| จุด | อาการ | ทางกู้เร็ว |
|---|---|---|
| ติดตั้ง Windows | native install ล้มเหลว | ลองใหม่/เช็คเน็ต; ถ้าไม่ได้ → **fallback A** (รัน claude บน VM) |
| API key | auth error | ตรวจ `setx` แล้วเปิด terminal ใหม่; เตรียม key สำรอง |
| Skills ไม่โผล่ | ลืม reload | `/reload-plugins` หรือเปิด `claude` ใหม่ |
| SSH (ตั้งแต่ lab01) | `Could not resolve hostname myvm` | ผู้เรียนยังไม่แทน `<VM_IP>`/`<student-user>` ใน `~/.ssh/config` ด้วยค่าจริง (ยัง placeholder อยู่) |
| SSH (ตั้งแต่ lab01) | ค้างรอ prompt | `StrictHostKeyChecking accept-new` + key-based; เตรียม `~/.ssh/config` ให้พร้อม |
| SSH (ตั้งแต่ lab01) | `Permission denied (publickey)` | pubkey ของผู้เรียนคนนี้ยังไม่ถูกใส่ใน `authorized_keys` บน VM — มักเกิดกับคนที่สร้าง key ตอนเช้าแทนที่จะส่งมาก่อนวันจริง ต้องรับ pubkey แล้ว provision ให้ทันช่วง lab 01 |
| ServiceDesk Plus | ล่ม/ช้า | สลับ mock (`scripts/servicedesk-mock/`) ทันที |
| เปิด Grafana ไม่ได้ | security group ยังไม่เปิด inbound 3000 | เช็ค security group ของ VM (ต้องเปิด TCP 22 + 3000) |

## เตรียมสาธิต use-case ให้ลื่น
- เตรียมโฟลเดอร์ว่าง + โจทย์ตัวอย่าง (CSV→JSON CLI) ไว้ล่วงหน้า
- ติดตั้ง skill `grilling` ไว้ก่อน เพื่อสาธิต `/grilling` ได้ทันที
- เปิด `examples/how-we-built-this.md` ค้างไว้ประกอบการเล่า

## Fallback A (สำคัญ)
ใครลง Claude Code บน Windows ไม่สำเร็จ → ให้ `ssh` เข้า VM แล้วรัน `claude` บน VM แทน
เนื้อหาทุก lab ทำบน VM ได้เหมือนกัน (ยกเว้นขั้นตอน "ติดตั้งบน Windows")

## หลังคลาส
เก็บ feedback, เตือนเรื่อง spend limit/secret, ชี้ self-study (`self-study/wsl-setup-guide.md`)
