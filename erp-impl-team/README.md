# AI ERP Implementation Team สำหรับ Claude Code (SAP + Odoo)

ทีมสำหรับงาน implement + improvement: requirement → blueprint → FS (gap-fit) → config guide → UAT → sign-off / CR

## ติดตั้ง

```bash
cp agents/*.md ~/.claude/agents/     # ครั้งเดียว อยู่ร่วมทีมอื่นได้

# ต่อ 1 ลูกค้า = 1 โฟลเดอร์
mkdir -p ~/clients/ลูกค้า-a && cd ~/clients/ลูกค้า-a
cp /path/to/CLAUDE.md.template ./CLAUDE.md    # กรอก — ข้อ 2 landscape ต้องแม่น
mkdir -p project/{requirements,specs,config,uat,cr,minutes}
claude
```

## ทีมงาน 5 ตัว

| Agent | หน้าที่ | Model |
|---|---|---|
| ba-requirement | interview kit, As-Is→To-Be, requirement catalog (REQ-xxx + MoSCoW) | inherit |
| functional-spec | FS + gap-fit: FIT / FIT-PARTIAL / GAP / VERIFY ต่อ requirement พร้อม effort | inherit |
| config-designer | config guide ทีละ step (where/what/why/REQ-id) + rollback + ⚠️ จุดกระทบข้อมูล | sonnet |
| uat-designer | UAT script ภาษา user จริง, defect log พร้อม route ตาม root cause, sign-off pack | sonnet |
| cr-analyst | งาน improvement: impact analysis อิงเอกสารเดิม, regression zone, size แล้ว route | inherit |

(ตัวที่ตัดสินใจแพง — gap-fit, impact analysis, requirement — ได้ inherit จาก session หลัก)

## Client checkpoints (ห้ามข้าม)

1. **Confirm blueprint** — ลูกค้ายืนยัน To-Be ก่อนเขียน spec
2. **Approve FS** — ลูกค้าอนุมัติ (โดยเฉพาะรายการ GAP ที่มีค่าใช้จ่าย) ก่อน config/build
3. **UAT sign-off** — ลูกค้าเซ็นก่อน go-live (uat-designer เตรียม pack ให้ พร้อม open items ตรงไปตรงมา)

## หลักการที่ฝังไว้

- **เอกสารเท่านั้น** — ไม่มี agent แตะระบบจริง consultant ลงมือใน DEV/staging ก่อนเสมอ
- **Traceability ตลอดสาย** — REQ ↔ FS ↔ CFG ↔ TC ตรวจ coverage ได้ว่า requirement ไหนยังไม่มี test
- **ห้ามเดาพฤติกรรม standard** — ไม่ชัวร์สำหรับเวอร์ชันลูกค้า = VERIFY-IN-SANDBOX (FIT ผิดๆ ที่มาแตกตอน UAT คือหายนะ)
- **Standard ก่อน custom** — FIT-PARTIAL ต้องถูกเสนอก่อน GAP เสมอ + custom ทุกตัวมี maintenance warning
- **CR ไม่ถูกกลืนเงียบๆ** — ของนอก scope ถูก flag เป็นเรื่อง commercial ให้มนุษย์คุย

## ตัวอย่างการใช้

```text
── งาน implement ──
คุณ:  เตรียม interview kit แผนกจัดซื้อสำหรับ kickoff พรุ่งนี้
  →  ba-requirement ทำชุดคำถาม
(ประชุมเสร็จ โยนโน้ตใส่ project/minutes/)
คุณ:  สกัด requirement จากโน้ตประชุมเมื่อวาน ทำ BP จัดซื้อ
  →  ba-requirement → BP-01 + REQ-001..015 → ลูกค้า confirm
คุณ:  ทำ FS จาก BP-01
  →  functional-spec → gap-fit: FIT 9, FIT-PARTIAL 3, GAP 2, VERIFY 1
คุณ:  (ลูกค้า approve) ทำ config guide + UAT script เลย
  →  config-designer + uat-designer ทำงานต่อกัน

── งาน improvement ──
คุณ:  ลูกค้า B ขอเพิ่ม approval 2 ชั้นใน PO ที่ Odoo ประเมินหน่อย
  →  cr-analyst อ่าน FS/CFG เดิม → impact + regression zone + size M → รอคุณอนุมัติ
```

## Tips

- โยนไฟล์ดิบได้เลย: โน้ตประชุม, email ลูกค้า, Excel requirement เก่า → ใส่ project/minutes/ แล้วให้ ba-requirement สกัด
- อยากได้ deliverable เป็น Word/Excel ส่งลูกค้า → บอก agent แปลง .md เป็น .docx ได้ (Claude Code ทำได้)
- ลูกค้าเจ้าประจำที่มีแต่งาน CR: ตั้ง "ประเภทงาน: Improvement/Support" ใน CLAUDE.md แล้วใช้ cr-analyst เป็นประตูหลัก
