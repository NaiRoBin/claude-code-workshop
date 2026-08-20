# เช็คลิสต์ก่อนวันอบรม

## ต้องทำทุกครั้ง (แกนหลัก)
- [ ] สร้าง Anthropic Console API key — 1 key/คน (หรือ key กลาง) จาก workspace เดียว
- [ ] ตั้ง **spend limit** รวมใน Console (กันค่าใช้จ่ายบานปลาย)
- [ ] เตรียมวิธีแจก key หน้างานอย่างปลอดภัย (ไม่ commit ลง repo/ไม่ส่งในแชตสาธารณะ)
- [ ] ทดสอบเครื่อง Windows แบบ **บัญชี no-admin** จริง: ลง fnm + Node + Claude Code + ตั้ง key → `claude` ทำงาน
- [ ] ยืนยันเน็ตหน้างานต่อ `api.anthropic.com` + npm registry ได้
- [ ] ติดตั้ง skill `grilling`/`tdd` ไว้บนเครื่องสาธิต + ซ้อมสาธิต use-case (grill-me → plan → generate)
- [ ] เตรียมโจทย์สาธิต + โจทย์ mini-project (ดู `lab/04`)
- [ ] ปริ๊น/แชร์ลิงก์เอกสาร lab ให้ผู้เรียน

## เฉพาะถ้าจะทำ Optional Capstone
- [ ] provision VM 1 เครื่อง/คน (แนะนำ 2 vCPU / 4GB, Ubuntu LTS): รัน `scripts/provision-vm.sh "student01 ..."`
- [ ] วาง public key ผู้เรียนใน `scripts/pubkeys/<user>.pub` ก่อนรัน provision (หรือให้ผู้เรียนสร้าง key ตอนเช้าแล้วใส่ทีหลัง)
- [ ] รัน `scripts/verify-vm.sh` บนแต่ละ VM → ผ่านทุกข้อ
- [ ] ทดสอบ `ssh myvm "uname -a"` แบบ non-interactive (ไม่ถาม host key/รหัส)
- [ ] ยืนยัน **Ivanti STG/SDP** endpoint + token ใช้ได้ (เตรียมเป็น env var, ไม่ commit)
- [ ] เตรียม fallback: `scripts/ivanti-mock/` คัดลอกขึ้น VM แล้ว (`~/ivanti-mock/`)
- [ ] ทดสอบ end-to-end: CC ติดตั้ง Postgres → โหลด mock → ติดตั้ง Grafana → เปิดผ่าน `ssh -L 3000` เห็น dashboard

## Dry-run สุดท้าย
- [ ] เดินตาม `lab/01` → `lab/06` ด้วยตัวเองครบเส้น จับเวลาว่าพอดีกรอบ 5 ชม.
- [ ] เตรียมแผนสำรองเวลา (ตัด optional capstone ถ้าช้า)
