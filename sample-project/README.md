# cc-sample-calculator

โปรเจกต์ตัวอย่างเล็ก ๆ สำหรับฝึกใช้ Claude Code ใน **Lab 02**

## โครงสร้าง
- `src/calculator.js` — ฟังก์ชันเครื่องคิดเลข (add, subtract)
- `test/calculator.test.js` — เทสต์ (ใช้ `node --test`)

## รันเทสต์
```bash
npm test
```

## แบบฝึกที่จะทำกับ Claude Code
1. ให้ Claude เพิ่มฟังก์ชัน `multiply(a, b)` และ `divide(a, b)` (กัน division by zero)
2. ให้ Claude เขียนเทสต์เพิ่ม
3. ลองใช้ plan mode วางแผนฟีเจอร์ "อ่านตัวเลขจากไฟล์ CSV แล้วรวมผล"
4. commit ด้วย git ผ่าน Claude
