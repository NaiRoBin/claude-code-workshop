# Lab 99 — Troubleshooting (ปัญหาที่พบบ่อย)

## ติดตั้งบน Windows

| อาการ | สาเหตุ | วิธีแก้ |
|---|---|---|
| `irm` ไม่รู้จัก (`is not recognized`) | อยู่ใน CMD ไม่ใช่ PowerShell | ใช้ `curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd` แทน |
| ติดตั้ง native install แล้วยังหา `claude` ไม่เจอ | PATH ยังไม่ถูก apply ใน session นี้ | ปิด-เปิด terminal ใหม่ |
| `claude` ขึ้น auth error | ยังไม่ตั้ง/ตั้งผิด `ANTHROPIC_API_KEY` | `setx ANTHROPIC_API_KEY "sk-ant-..."` แล้วเปิด terminal ใหม่ |
| ลงบน Windows ไม่ได้จริง ๆ | policy เครื่อง | **Fallback A**: `ssh myvm` เข้าไปรัน `claude` บน VM แทน |

## Skills

| อาการ | วิธีแก้ |
|---|---|
| ติดตั้ง skill แล้ว `/<ชื่อ>` ไม่โผล่ | รัน `/reload-plugins` หรือปิด-เปิด `claude` ใหม่ |
| copy ผิดที่ | ต้องอยู่ที่ `~/.claude/skills/<ชื่อ>/SKILL.md` (personal) หรือ `<project>/.claude/skills/...` |
| Windows path | `~` = `C:\Users\<you>` → `C:\Users\<you>\.claude\skills\` |

## SSH → VM (ใช้ตั้งแต่ lab 02)

| อาการ | สาเหตุ | วิธีแก้ |
|---|---|---|
| `Could not resolve hostname myvm` | ไม่มี `Host myvm` ใน `~/.ssh/config` จริง (ไฟล์ไม่มีเลย/พิมพ์ผิด/ยังเป็น placeholder `<VM_IP>`) | เปิด `notepad $env:USERPROFILE\.ssh\config` เช็คว่ามี block `Host myvm` และแทนที่ `<VM_IP>`/`<student-user>` ด้วยค่าจริงแล้ว (ดู lab 01 ขั้นที่ 4) |
| ssh ค้าง / Claude Code สั่ง ssh แล้วไม่จบ | ถาม host key หรือถามรหัสผ่าน | ใช้ key-based auth + `StrictHostKeyChecking accept-new` ใน `~/.ssh/config` |
| `Permission denied (publickey)` | public key ยังไม่อยู่บน VM (ยังไม่ได้ส่งให้ผู้สอน หรือผู้สอนยังไม่ได้ provision) | เช็คว่าส่ง `id_ed25519.pub` (ไม่ใช่ตัวไม่มี `.pub`) ให้ผู้สอนแล้ว และแจ้งผู้สอนใส่ลง `authorized_keys` |
| เปิด `http://<VM_IP>:3000` ไม่ได้ (timeout) | security group ยังไม่เปิด inbound 3000 | แจ้งผู้สอนเช็ค security group ของ VM (ต้องเปิด TCP 22 + 3000) |
| เปิด `http://<VM_IP>:3000` ได้แต่ขึ้น "connection refused" | Grafana ยังไม่ได้ start/ยังติดตั้งไม่เสร็จ | เช็คด้วย `ssh myvm "sudo systemctl status grafana-server"` |
| ServiceDesk Plus ดึงไม่ได้/ช้า | staging ล่ม/rate limit | สลับไปใช้ mock: `node ~/servicedesk-mock/mock-server.js` |
| กังวลเรื่อง Grafana เปิดออกสู่อินเทอร์เน็ต | พอร์ต 3000 เปิดสู่สาธารณะ ไม่ใช่แค่ localhost | เปลี่ยนรหัส admin จาก default (`admin/admin`) ทันทีหลัง login ครั้งแรก |

## ทั่วไป
- Claude ทำผิดทาง → กด Esc หยุด, สั่งใหม่ให้ชัดขึ้น หรือ `/clear` เริ่ม context ใหม่
- อยากให้จำ context → เพิ่มใน `CLAUDE.md`
- เน็ตมีปัญหา → ตรวจว่าต่อ `api.anthropic.com` ได้ (ping/curl)
