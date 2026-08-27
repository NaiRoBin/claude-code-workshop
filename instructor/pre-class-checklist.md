# เช็คลิสต์ก่อนวันอบรม

## ต้องทำทุกครั้ง (แกนหลัก)
- [ ] สร้าง Anthropic Console API key — 1 key/คน (หรือ key กลาง) จาก workspace เดียว
- [ ] ตั้ง **spend limit** รวมใน Console (กันค่าใช้จ่ายบานปลาย)
- [ ] เตรียมวิธีแจก key หน้างานอย่างปลอดภัย (ไม่ commit ลง repo/ไม่ส่งในแชตสาธารณะ)
- [ ] ทดสอบเครื่อง Windows แบบ **บัญชี no-admin** จริง: ลง Claude Code (native install) + ต่อ SSH เข้า VM + ตั้ง key → `claude` ทำงาน
- [ ] ยืนยันเน็ตหน้างานต่อ `api.anthropic.com` ได้ (ไม่ต้องพึ่ง npm registry แล้ว)
- [ ] ติดตั้ง skill `grilling`/`tdd` ไว้บนเครื่องสาธิต + ซ้อมสาธิต use-case (grill-me → plan → generate)
- [ ] เตรียมโจทย์สาธิต + โจทย์ mini-project (ดู `lab/04`)
- [ ] ปริ๊น/แชร์ลิงก์เอกสาร lab ให้ผู้เรียน
- [ ] provision VM 1 เครื่อง/คน (แนะนำ t3.small ขึ้นไป, Ubuntu LTS): รัน `scripts/provision-vm.sh "student01 ..."`
  — **ต้องทำก่อนวันอบรมเสมอ** เพราะ VM ใช้ตั้งแต่ lab 02 ไม่ใช่แค่ capstone
  — ถ้า provision บน cloud (เช่น AWS EC2) ใช้ `scripts/aws-user-data.sh` เป็น user-data ตอน
    launch แต่ละเครื่องได้เลย (แก้ `STUDENT_USER`/`STUDENT_PUBKEY` ก่อนวาง ไม่ต้อง ssh เข้าไปรันมือ)
- [ ] วาง public key ผู้เรียนใน `scripts/pubkeys/<user>.pub` ก่อนรัน provision (หรือให้ผู้เรียนสร้าง key ตอนเช้าแล้วใส่ทีหลัง)
  — ถ้าใช้แบบหลัง: เตรียมช่องทางรับ pubkey หน้างาน (เช่นแชทกลุ่ม) แล้ว provision +
    ส่ง VM_IP/username กลับให้ทันช่วง lab 01 ขั้นตอน SSH (ผู้เรียนรอ 2 ค่านี้ก่อนตั้ง `~/.ssh/config` ได้)
- [ ] รัน `scripts/verify-vm.sh` บนแต่ละ VM → ผ่านทุกข้อ (รวม sample-project + servicedesk-mock ที่ provision ไว้)
- [ ] ทดสอบ `ssh myvm "uname -a"` แบบ non-interactive (ไม่ถาม host key/รหัส)
- [ ] ยืนยัน **ServiceDesk Plus** endpoint + token ใช้ได้ (เตรียมเป็น env var, ไม่ commit)
- [ ] เตรียม fallback: `scripts/servicedesk-mock/` คัดลอกขึ้น VM แล้ว (`~/servicedesk-mock/`)
- [ ] เปิด security group ของแต่ละ VM: inbound TCP 22 (SSH) และ TCP 3000 (Grafana) จากอินเทอร์เน็ต/เน็ตของสถานที่จัดงาน
- [ ] ทดสอบ end-to-end: CC ติดตั้ง Postgres → โหลด mock → ติดตั้ง Grafana → เปิด `http://<VM_IP>:3000` ตรง ๆ เห็น dashboard (ไม่ต้อง ssh -L แล้ว)

## Dry-run สุดท้าย
- [ ] เดินตาม `lab/01` → `lab/06` ด้วยตัวเองครบเส้น จับเวลาว่าพอดีกรอบ 5 ชม.
- [ ] เตรียมแผนสำรองเวลา (ย่อความลึกของ Skills หรือลดโจทย์ mini-project ถ้าช้า — ไม่ตัด capstone)
