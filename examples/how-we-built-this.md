# Use case จริง: เราใช้ Claude Code สร้าง workshop นี้อย่างไร (step-by-step)

เอกสารนี้บันทึก **ของจริง** ว่าชุดสื่อ workshop นี้ (ทุกไฟล์ในโฟลเดอร์ `claude_lab/`)
ถูกสร้างขึ้นด้วย Claude Code อย่างไร ใช้เป็นตัวอย่างสอนได้เลย

---

## ภาพรวม workflow

```
โจทย์คลุมเครือ
   │
   ▼  (1) เรียก skill grill-me / grilling
Claude ซักถามทีละคำถาม  ── ตอบ ──► สเปกชัดขึ้นเรื่อย ๆ
   │
   ▼  (2) plan mode
Claude ร่างแผนเป็นไฟล์ .md  ── ตรวจ/แก้ ──►
   │
   ▼  (3) ExitPlanMode = อนุมัติ
Claude ลงมือสร้างไฟล์ทั้งชุด + รันคำสั่ง
   │
   ▼  (4) วนทบทวน
"ปรับ scope / เพิ่มหัวข้อ Skills / ทำ Ivanti เป็น optional" ...
```

---

## Step 1 — เริ่มจากโจทย์คลุมเครือ

โจทย์ตั้งต้น (สรุป): *"สร้างโปรเจกต์เตรียมการสอน Claude Code 1 วัน (10:00–12:00, 13:30–16:30)
lab ต้องมี install บน Windows + WSL + ใช้ SSH จาก Windows ไป WSL แล้วสั่ง Claude Code ทำงานที่นั่น
โดยเครื่องไม่มี admin ของ Windows"*

โจทย์แบบนี้มีจุดที่ต้องตัดสินใจซ่อนอยู่เยอะ (มี admin จริงไหม? auth ยังไง? เน็ตเปิดไหม? ...)
→ จึงเริ่มด้วยการ **ให้ Claude ซักก่อน** แทนที่จะรีบลงมือ

## Step 2 — grill-me: ซักถามทีละข้อ

เรียก `/grill-me` (หรือ skill `grilling` ของ mattpocock) แล้ว Claude เดินไล่ decision tree ทีละกิ่ง
พร้อมเสนอคำตอบแนะนำในแต่ละข้อ ตัวอย่างคำถามที่เกิดขึ้นจริงและผลลัพธ์:

| คำถาม | คำตอบที่เลือก | ผลต่อ design |
|---|---|---|
| เครื่องมี admin/WSL ติดตั้งไว้ไหม? | เครื่องเปล่า ไม่มี admin | ติดตั้ง WSL สดไม่ได้ → WSL เป็น self-study |
| Linux ปลายทางมาจากไหน? | เตรียมทั้ง WSL (เผื่อ) + Linux server ภายนอก | ออกแบบ 2 tracks |
| auth Claude Code ยังไง? | Console API key (เมนู login ข้อ 2) | ตั้ง spend limit รวม, key ต่อคน |
| เน็ตเวิร์ก? | เปิด ต่อนอกได้อิสระ | ไม่ต้อง config proxy |
| topology ของ VM? | 1 VM/คน มี root | สะอาดสำหรับ install DB/Grafana |
| Claude Code รันที่ไหน? | native บน Windows, สั่งข้าม SSH ไป VM | สถาปัตยกรรมหลัก |
| โฟกัส workshop? | Skills + use case นี้เป็นหลัก, Ivanti เป็น optional | ปรับลำดับเนื้อหา |

> บทเรียน: **การถูกซักช่วยจับข้อขัดแย้งได้เร็ว** เช่น "ไม่มี admin" ขัดกับ "ติดตั้ง WSL" —
> เจอตั้งแต่คำถามแรก ก่อนจะเสียเวลาสร้างของผิด

## Step 3 — plan mode: ร่างแผนก่อนสร้าง

หลังสเปกชัด Claude เข้า **plan mode** เขียนแผนลงไฟล์ `.md` (โครงไฟล์, agenda, รายละเอียดแต่ละ artifact,
วิธี verify) ให้ตรวจก่อน — ยังไม่แตะไฟล์จริง จากนั้น **ExitPlanMode** เพื่อขออนุมัติ

## Step 4 — สร้างไฟล์ + วนแก้

พออนุมัติ Claude ลงมือ:
- สร้างโครงโฟลเดอร์ (`mkdir -p ...`)
- เขียนไฟล์ทีละไฟล์ (README, agenda, lab/*, scripts/*, slides/* ...)
- รับ feedback ระหว่างทาง เช่น *"เพิ่มเรื่อง Skills"*, *"Ivanti เป็น option, Skills + use case เป็นหลัก"*
  → Claude ปรับแผน + แก้ไฟล์ตาม

---

## สิ่งที่ผู้เรียนควรถอดบทเรียน
1. **อย่ารีบเขียนโค้ด** — ให้ Claude ซักจนสเปกชัด (skill grilling ช่วยได้)
2. **ใช้ plan mode กับงานใหญ่** — เห็นภาพรวม ตรวจก่อน ลดการรื้อ
3. **ให้ feedback เป็นรอบ ๆ** — เปลี่ยน scope กลางทางได้ Claude ปรับตาม
4. **บันทึก context ใน `CLAUDE.md`** — ให้ Claude จำกติกาโปรเจกต์
5. **ทุกอย่างนี้ทำซ้ำได้เอง** — ดู [`../lab/04-use-case-build-workshop.md`](../lab/04-use-case-build-workshop.md)
