// mock-server.js — mock ServiceDesk Plus (SDP) API เล็ก ๆ (Node ล้วน ไม่ต้องลง dependency)
// ใช้เป็น safety net เมื่อ ServiceDesk Plus STG ไม่พร้อม/ช้า ระหว่างทำ lab/05 (capstone)
//
// วิธีใช้:  node mock-server.js         (ค่าเริ่มต้นพอร์ต 8080)
//          PORT=9090 node mock-server.js
// endpoint: GET /requests  -> คืน JSON array เลียนแบบ response ของ ServiceDesk Plus
//           GET /health    -> { "ok": true }

const http = require("http");
const fs = require("fs");
const path = require("path");

const PORT = process.env.PORT || 8080;
const DATA_FILE = path.join(__dirname, "sample-requests.json");

const server = http.createServer((req, res) => {
  if (req.url.startsWith("/requests")) {
    let body;
    try {
      body = fs.readFileSync(DATA_FILE, "utf8");
    } catch (e) {
      res.writeHead(500, { "Content-Type": "application/json" });
      res.end(JSON.stringify({ error: "cannot read sample data" }));
      return;
    }
    // เลียนแบบรูปแบบ response ของ ServiceDesk Plus: ห่อด้วย key "requests"
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ requests: JSON.parse(body) }));
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
  console.log(`mock ServiceDesk Plus API listening on http://localhost:${PORT}`);
  console.log(`  GET /requests  GET /health`);
});
