// เทสต์สำหรับ calculator.js — ใช้ test runner ในตัวของ Node (ไม่ต้องลง dependency)
// รันด้วย:  npm test    (หรือ node --test)

const test = require("node:test");
const assert = require("node:assert");
const { add, subtract } = require("../src/calculator");

test("add บวกเลขได้ถูกต้อง", () => {
  assert.strictEqual(add(2, 3), 5);
});

test("subtract ลบเลขได้ถูกต้อง", () => {
  assert.strictEqual(subtract(10, 4), 6);
});

// แบบฝึก: เมื่อให้ Claude Code เพิ่ม multiply/divide แล้ว ลองให้มันเขียนเทสต์เพิ่มที่นี่ด้วย
