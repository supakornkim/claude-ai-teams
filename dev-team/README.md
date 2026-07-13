# AI Product Team สำหรับ Claude Code

ชุด subagents สำหรับ pipeline: ไอเดีย → groom → วิเคราะห์ตลาด → spec → architecture → dev → QA → marketing review → launch

## วิธีติดตั้ง (ครั้งเดียว ใช้ได้ทุกโปรเจกต์)

```bash
mkdir -p ~/.claude/agents
cp agents/*.md ~/.claude/agents/
```

## วิธีเริ่มโปรเจกต์ใหม่ (~10 นาที)

```bash
cd my-new-project
cp /path/to/CLAUDE.md.template ./CLAUDE.md   # แล้วกรอกให้ครบ
mkdir -p docs/ideas docs/research docs/specs docs/tasks docs/qa-reports docs/launch
echo '{}' > docs/_queue.json
claude
```

จากนั้นพิมพ์ไอเดียได้เลย เช่น:
> มีไอเดียใหม่: อยากทำแอปจองคิวร้านตัดผมสำหรับร้านเล็กๆ ช่วย groom หน่อย

Claude จะเรียก idea-groomer มาคุยกับคุณเอง หรือสั่งตรงๆ ก็ได้:
> ใช้ idea-groomer ช่วย groom ไอเดียนี้

## ทีมงาน 5 ตัว

| Agent | หน้าที่ | Output |
|---|---|---|
| idea-groomer | คุยขัดเกลาไอเดีย ถามจนชัด ท้าทายจุดอ่อน | docs/ideas/ |
| market-analyst | วิเคราะห์ตลาด คู่แข่ง ให้ verdict GO/NO-GO | docs/research/ |
| pm-spec | เขียน spec + แตก task พร้อม acceptance criteria | docs/specs/, docs/tasks/ |
| architect | เลือก stack ออกแบบระบบ เขียน ADR | docs/specs/*-adr.md |
| qa-reviewer | รัน test ตรวจตาม acceptance criteria ให้ PASS/FAIL | docs/qa-reports/ |
| marketing-reviewer | เช็ค drift กับตลาด + เตรียม launch plan | docs/launch/ |

**ทำไมไม่มี dev-implementer?** ตั้งใจครับ — การเขียนโค้ดให้ main agent ของ Claude Code ทำเอง เพราะมันเห็น context ทั้ง codebase + CLAUDE.md ครบ (แก้ปัญหา "context gatekeeping") ส่วน subagents ทำเฉพาะงาน groom/วิเคราะห์/ตรวจ ซึ่งเป็นงานที่ได้ประโยชน์จาก context แยกและมุมมองอิสระ

## Human checkpoints (ห้ามข้าม)

1. **GO/NO-GO** — หลัง market-analyst ให้ verdict คุณตัดสินใจเอง
2. **Approve ADR** — ก่อนเริ่มเขียนโค้ด
3. **Launch** — คุณเป็นคนกดปุ่มสุดท้ายเสมอ

## Flow การใช้งานจริง (ตัวอย่าง)

```text
คุณ:  มีไอเดีย X ช่วย groom หน่อย
  →  idea-groomer ถามตอบกับคุณ → บันทึก docs/ideas/x.md
คุณ:  วิเคราะห์ตลาดไอเดีย x หน่อย
  →  market-analyst → verdict GO → คุณอนุมัติ
คุณ:  ทำ spec และแตก task เลย
  →  pm-spec → architect → คุณ approve ADR
คุณ:  เริ่ม implement T-001 ถึง T-003
  →  main agent เขียนโค้ด
คุณ:  QA หน่อย
  →  qa-reviewer → FAIL พร้อมรายงาน → แก้ → QA ใหม่ → PASS
คุณ:  เตรียม launch
  →  marketing-reviewer → READY_TO_LAUNCH → คุณกดปุ่ม 🚀
```

## Tips การปรับจูน

- Agent ตัวไหนตอบไม่ตรงใจ → แก้ไฟล์ .md ของมันตรงๆ ได้เลย (มันคือ prompt ธรรมดา)
- โปรเจกต์ไหนอยากได้เวอร์ชันพิเศษ → copy agent ไปวางที่ `.claude/agents/` ในโปรเจกต์ (จะ override ตัว global)
- ทุกครั้งที่ agent เข้าใจผิด → เพิ่มกติกาใน CLAUDE.md ข้อ 5 กันพลาดซ้ำ
- ใช้ `/agents` ใน Claude Code เพื่อดู/แก้/สร้าง agent เพิ่มได้
