// mock-server.js — mock Ivanti/SDP API เล็ก ๆ (Node ล้วน ไม่ต้องลง dependency)
// ใช้เป็น safety net เมื่อ Ivanti STG ไม่พร้อม/ช้า ระหว่างทำ optional capstone (lab/05)
//
// วิธีใช้:  node mock-server.js         (ค่าเริ่มต้นพอร์ต 8080)
//          PORT=9090 node mock-server.js
// endpoint: GET /incidents  -> คืน JSON array เลียนแบบ response ของ Ivanti
//           GET /health     -> { "ok": true }

const http = require("http");
const fs = require("fs");
const path = require("path");

const PORT = process.env.PORT || 8080;
const DATA_FILE = path.join(__dirname, "sample-incidents.json");

const server = http.createServer((req, res) => {
  if (req.url.startsWith("/incidents")) {
    let body;
    try {
      body = fs.readFileSync(DATA_FILE, "utf8");
    } catch (e) {
      res.writeHead(500, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "cannot read sample data" }));
      return;
    }
    // เลียนแบบรูปแบบ response ของ Ivanti/SDP: ห่อด้วย key "incidents"
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ incidents: JSON.parse(body) }));
    return;
  }
  if (req.url.startsWith("/health")) {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ ok: true }));
    return;
  }
  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "not found" }));
});

server.listen(PORT, () => {
  console.log(`mock Ivanti API listening on http://localhost:${PORT}`);
  console.log(`  GET /incidents  GET /health`);
});
