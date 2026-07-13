# Claude AI Teams — ระบบทีม AI ครบชุด (22 agents / 4 ทีม + 2 shared)

ระบบ subagents สำหรับ Claude Code ครอบคลุม: หาไอเดีย→ทำ product / ทำ content การตลาด / วิเคราะห์ข้อมูล ERP / งาน implement ERP ให้ลูกค้า / ปรึกษากลยุทธ์

## ติดตั้งทั้งหมดในคำสั่งเดียว

```bash
mkdir -p ~/.claude/agents
cp */agents/*.md ~/.claude/agents/
```
ติดตั้งแล้ว "นอนรอ" ไม่มีต้นทุน — agent กินเงินเฉพาะตอนถูกเรียกใช้งานจริง
Claude จะเลือกตัวที่ตรงกับงานเองจาก description (หรือสั่งชื่อตรงๆ ก็ได้: "ใช้ cr-analyst ประเมินหน่อย")

## โครงสร้างหลัก (ทุกทีมใช้หลักเดียวกัน)

- **Agent กลาง = วิธีทำงาน** (ติดตั้งครั้งเดียวที่ ~/.claude/agents/ ใช้ทุกโปรเจกต์)
- **CLAUDE.md ต่อโฟลเดอร์ = บริบทของงานนั้น** (โปรเจกต์/แบรนด์/ลูกค้า — copy จาก template ในแต่ละทีม)
- **สถานะเป็นไฟล์** — งานไหลผ่าน status ตรวจย้อนได้
- **มนุษย์คุม gate สำคัญเสมอ** — GO/NO-GO, approve, sign-off, กดโพสต์, กด launch
- ปรับจูนต่อโปรเจกต์: กติกาใน CLAUDE.md ก่อน → ไม่พอค่อย copy agent ไป .claude/agents/ ในโปรเจกต์ (override เฉพาะที่นั่น)

---

## 1) dev-team — ไอเดีย → Product (7 ตัว)

Pipeline: ไอเดีย → groom → วิเคราะห์ตลาด → [GO/NO-GO] → spec → architecture → [approve] → main agent เขียนโค้ด → QA loop → marketing check → [launch]

| Agent | หน้าที่ | Model |
|---|---|---|
| idea-groomer | คุยขัดเกลาไอเดีย ถามจนชัด ท้าทายจุดอ่อน | sonnet |
| market-analyst | คู่แข่ง/ตลาด/ราคา → verdict GO/NO-GO (FACT vs ASSUMPTION) | sonnet |
| pm-spec | spec + แตก task + acceptance criteria | sonnet |
| architect | เลือก stack, ADR, guardrails | inherit |
| qa-reviewer | รัน test จริง ตรวจตาม criteria PASS/FAIL | sonnet |
| marketing-reviewer | เช็ค drift กับตลาด + launch plan | sonnet |
| product-auditor | ตรวจโปรเจกต์เก่า หา improvement (effort/impact) | sonnet |

หมายเหตุ: ไม่มี dev-implementer โดยตั้งใจ — main agent เขียนโค้ดเองเพราะเห็น context ครบ

## 2) content-team — Social Marketing (5 ตัว, หลายธุรกิจ)

Cycle: intel → วางแผน → เขียน → ทำภาพ → ตรวจแบรนด์ → [คุณกดโพสต์]
1 ธุรกิจ = 1 โฟลเดอร์ + brand profile (CLAUDE.md)

| Agent | หน้าที่ | Model |
|---|---|---|
| content-strategist | content calendar ผูกเป้าธุรกิจ + content mix | sonnet |
| copywriter | โพสต์ 2 variants แยกกติกาตาม platform (FB/IG/TikTok/LINE) | inherit |
| visual-designer | quote card/infographic → PNG เองได้ หรือ image prompt สำหรับ AI ภายนอก | sonnet |
| brand-reviewer | ตรวจ voice/fact/ความเสี่ยงโฆษณาไทย (อย., claim เกินจริง) | sonnet |
| competitor-scout | intel คู่แข่งรายเดือนจากข้อมูลสาธารณะ + screenshot ที่คุณให้ | sonnet |

## 3) ops-team — วิเคราะห์ข้อมูล ERP: SAP + Odoo (3 ตัว)

READ-ONLY ทั้งหมด | SAP → export ใส่ ops/inbox/ | Odoo → export หรือ MCP (read-only key, ห้าม admin key)
กติกาเหล็ก: คำนวณผ่าน script เท่านั้น + ทุกตัวเลขอ้างที่มาได้ + validate ก่อนวิเคราะห์

| Agent | หน้าที่ |
|---|---|
| sales-analyst | รายงานยอดขาย เทียบช่วงเวลา หา anomaly |
| inventory-watcher | ของใกล้หมด + dead stock (มูลค่าเงินจม) + reorder โชว์สูตร |
| finance-summarizer | เงินเข้าออก, AR aging — ไม่ใช่นักบัญชี ภาษี/งบส่งนักบัญชีเสมอ |

## 4) erp-impl-team — Implement + Improvement ให้ลูกค้า (5 ตัว)

Pipeline: requirement → [confirm blueprint] → FS gap-fit → [approve FS] → config guide → UAT → [sign-off]
Improvement: CR → impact analysis → [อนุมัติ/commercial] → route → regression
1 ลูกค้า = 1 โฟลเดอร์ | Traceability: REQ ↔ FS ↔ CFG ↔ TC | ทุกตัวเขียนเอกสารเท่านั้น ไม่แตะระบบจริง

| Agent | หน้าที่ | Model |
|---|---|---|
| ba-requirement | interview kit, As-Is→To-Be, requirement catalog (MoSCoW) | inherit |
| functional-spec | gap-fit: FIT / FIT-PARTIAL / GAP / VERIFY + effort | inherit |
| config-designer | config guide ทีละ step + rollback + ⚠️ จุดกระทบข้อมูล | sonnet |
| uat-designer | UAT script ภาษา user, defect log route ตาม root cause, sign-off pack | sonnet |
| cr-analyst | impact analysis อิงเอกสารเดิม + regression zone + size + route | inherit |

## 5) shared — ใช้ได้ทุกทีมทุกโฟลเดอร์ (2 ตัว)

| Agent | หน้าที่ | Model |
|---|---|---|
| trend-watcher | เทรนด์รายสัปดาห์ แยก TREND/WAVE/SIGNAL — โฟลเดอร์ content ป้อนมุมคอนเทนต์ / โฟลเดอร์ dev ป้อนโอกาส product | sonnet |
| business-strategist | ปรึกษากลยุทธ์: วินิจฉัยก่อนสั่งยา (ยอดขาย = คนเข้า × ปิด × บิล × ซื้อซ้ำ) สังเคราะห์รายงานทุกทีม → 2-3 options พร้อม trade-off | inherit |

---

## กิจวัตรแนะนำ

- **รายสัปดาห์:** trend-watcher ในธุรกิจหลัก
- **ต้นเดือน:** competitor-scout → content-strategist วาง calendar / sales-analyst + inventory-watcher อ่านตัวเลข
- **รายไตรมาส:** business-strategist ประกอบทุกรายงาน → ทบทวนกลยุทธ์ / product-auditor ตรวจโปรเจกต์เก่า

## กติกาการโต (สำคัญ)

1. อย่าเปิดใช้ทุกทีมพร้อมกัน — เลือกงานที่เจ็บสุด ใช้จริง 2-4 สัปดาห์ก่อนขยาย
2. Agent ตอบเพี้ยน → เพิ่มกติกาใน CLAUDE.md ของโฟลเดอร์นั้นก่อนเสมอ
3. เพิ่ม agent ใหม่เมื่อพิมพ์คำสั่งเดิมซ้ำครั้งที่ 3 เท่านั้น / ตัวที่ไม่เคยใช้ → ลบทิ้งได้
4. ลำดับงานซ้ำๆ = slash command (.claude/commands/) ไม่ใช่ agent
