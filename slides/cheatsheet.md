# Claude Code Cheat Sheet (1 หน้า)

## เริ่มต้น
```bash
claude                  # เปิดในโฟลเดอร์ปัจจุบัน
claude --version
```
ตั้ง auth: `setx ANTHROPIC_API_KEY "sk-ant-..."` (Windows) แล้วเปิด terminal ใหม่

## Slash commands ที่ใช้บ่อย
| คำสั่ง | ทำอะไร |
|---|---|
| `/help` | ความช่วยเหลือ + รายการคำสั่ง |
| `/clear` | ล้าง context เริ่มใหม่ |
| `/plan` | ให้วางแผนก่อนลงมือ (plan mode) |
| `/reload-plugins` | โหลด skill/plugin ใหม่ |
| `/<ชื่อ-skill>` | เรียก skill เช่น `/grilling`, `/tdd` |
| Esc | หยุดสิ่งที่ Claude กำลังทำ |

## Skills
```bash
git clone https://github.com/mattpocock/skills.git /tmp/mp
cp -r /tmp/mp/skills/grilling ~/.claude/skills/grilling
# แล้ว /reload-plugins หรือเปิด claude ใหม่ → /grilling
```
- personal: `~/.claude/skills/<ชื่อ>/SKILL.md`
- project (แชร์ทีม): `<project>/.claude/skills/<ชื่อ>/SKILL.md`

## Workflow แนะนำ
```
1. ให้ context ดี ๆ (เป้าหมาย + ข้อจำกัด + ตัวอย่าง)
2. งานใหญ่ → plan mode → ตรวจแผน → อนุมัติ
3. อ่าน diff ก่อน allow
4. commit บ่อย · วนแก้เป็นรอบเล็ก
5. CLAUDE.md = ความจำของโปรเจกต์
```

## SSH (ใช้ตั้งแต่ lab 02)
```bash
ssh myvm "uname -a"                 # สั่งงานข้าม SSH (ต้อง non-interactive)
ssh -L 3000:localhost:3000 myvm     # port forward ดู Grafana
```
`~/.ssh/config`:
```
Host myvm
    HostName <IP>
    User <user>
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking accept-new
```

## ความปลอดภัย
- อย่า commit API key/token — ใช้ env var
- ระวัง spend limit · อ่านคำสั่งก่อนให้รันบนเครื่องที่มี root
