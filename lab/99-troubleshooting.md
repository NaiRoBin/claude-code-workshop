# Lab 99 — Troubleshooting (ปัญหาที่พบบ่อย)

## ติดตั้งบน Windows

| อาการ | สาเหตุ | วิธีแก้ |
|---|---|---|
| `node` / `npm` ไม่รู้จัก | fnm ยังไม่ได้ activate ใน session | รัน `fnm env --use-on-cd \| Out-String \| Invoke-Expression` แล้ว `fnm use lts-latest`; เปิด terminal ใหม่ |
| `irm` ไม่รู้จัก (`is not recognized`) | อยู่ใน CMD ไม่ใช่ PowerShell | ใช้ `curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd` แทน |
| ติดตั้ง native install แล้วยังหา `claude` ไม่เจอ | PATH ยังไม่ถูก apply ใน session นี้ | ปิด-เปิด terminal ใหม่ |
| `winget` ไม่มี | เครื่องเก่า/ถูกปิด | โหลด `fnm.exe` จาก GitHub releases วางในโฟลเดอร์ที่อยู่ใน PATH ของ user |
| `claude` ขึ้น auth error | ยังไม่ตั้ง/ตั้งผิด `ANTHROPIC_API_KEY` | `setx ANTHROPIC_API_KEY "sk-ant-..."` แล้วเปิด terminal ใหม่ |
| ลงบน Windows ไม่ได้จริง ๆ | policy เครื่อง | **Fallback A**: `ssh myvm` เข้าไปรัน `claude` บน VM แทน |

## Skills

| อาการ | วิธีแก้ |
|---|---|
| ติดตั้ง skill แล้ว `/<ชื่อ>` ไม่โผล่ | รัน `/reload-plugins` หรือปิด-เปิด `claude` ใหม่ |
| copy ผิดที่ | ต้องอยู่ที่ `~/.claude/skills/<ชื่อ>/SKILL.md` (personal) หรือ `<project>/.claude/skills/...` |
| Windows path | `~` = `C:\Users\<you>` → `C:\Users\<you>\.claude\skills\` |

## SSH → VM (optional capstone)

| อาการ | สาเหตุ | วิธีแก้ |
|---|---|---|
| ssh ค้าง / Claude Code สั่ง ssh แล้วไม่จบ | ถาม host key หรือถามรหัสผ่าน | ใช้ key-based auth + `StrictHostKeyChecking accept-new` ใน `~/.ssh/config` |
| `Permission denied (publickey)` | public key ยังไม่อยู่บน VM | แจ้งผู้สอนใส่ public key ลง `authorized_keys` |
| เปิด Grafana ไม่ได้ | ไม่ได้ทำ port forward | `ssh -L 3000:localhost:3000 myvm` (terminal แยก) แล้วเปิด `http://localhost:3000` |
| Ivanti ดึงไม่ได้/ช้า | staging ล่ม/rate limit | สลับไปใช้ mock: `node ~/ivanti-mock/mock-server.js` |
| พอร์ต 3000 ถูกใช้แล้ว | มี process ค้าง | เปลี่ยนพอร์ต forward เช่น `ssh -L 3001:localhost:3000 myvm` |

## ทั่วไป
- Claude ทำผิดทาง → กด Esc หยุด, สั่งใหม่ให้ชัดขึ้น หรือ `/clear` เริ่ม context ใหม่
- อยากให้จำ context → เพิ่มใน `CLAUDE.md`
- เน็ตมีปัญหา → ตรวจว่าต่อ `api.anthropic.com` ได้ (ping/curl)
