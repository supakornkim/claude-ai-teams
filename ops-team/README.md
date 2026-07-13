# AI Ops Team สำหรับ Claude Code (SAP + Odoo)

ทีมวิเคราะห์ข้อมูล ERP: ยอดขาย / สต๊อก / การเงิน — READ-ONLY ทั้งหมด

## สถาปัตยกรรม

```
SAP  ──export .xlsx/.csv──►  ops/inbox/  ──►  ทีม agent วิเคราะห์  ──►  ops/reports/
Odoo ──export หรือ MCP (read-only)──►┘        (คำนวณผ่าน script เสมอ)
```

## ติดตั้ง

```bash
cp agents/*.md ~/.claude/agents/          # ครั้งเดียว ใช้ร่วมกับทีมอื่นได้

# ต่อ workspace
mkdir -p ~/ops/บริษัท-a && cd ~/ops/บริษัท-a
cp /path/to/CLAUDE.md.template ./CLAUDE.md   # กรอก — ข้อ 3 column mapping สำคัญสุด
mkdir -p ops/inbox ops/reports ops/scripts ops/archive
claude
```

## ทีมงาน 3 ตัว (sonnet ทั้งหมด)

| Agent | หน้าที่ |
|---|---|
| sales-analyst | รายงานยอดขาย เทียบช่วงเวลา top/bottom สินค้า หา anomaly |
| inventory-watcher | ของใกล้หมด (URGENT/SOON) + dead stock พร้อมมูลค่าเงินจม + reorder แนะนำโชว์สูตร |
| finance-summarizer | เงินเข้า-ออก, AR aging (ลูกหนี้ค้างเป็นช่วงอายุ), รายจ่ายตามหมวด — **ไม่ใช่นักบัญชี** เรื่องภาษี/งบส่งนักบัญชีเสมอ |

## กติกาเหล็ก (ฝังใน agent ทุกตัวแล้ว)

1. **READ-ONLY** — ไม่มี agent ตัวไหนเขียนเข้า ERP ได้/ควรทำ การบันทึกจริงคุณทำในระบบเอง
2. **คำนวณผ่าน script เท่านั้น** — LLM ห้ามคำนวณในหัว ทุกตัวเลขมาจาก pandas script ที่เก็บไว้ใน ops/scripts/ ตรวจซ้ำได้
3. **ทุกตัวเลขอ้างที่มาได้** — ไฟล์ไหน filter อะไร / query ไหน
4. **Validate ก่อนวิเคราะห์** — ช่วงวันที่, แถวซ้ำ, VAT รวม/ไม่รวม, สองระบบขัดกันต้องธง

## การเชื่อมต่อ

**SAP → ใช้ export** (แนะนำ): export รายงานเป็น Excel/CSV จากจอที่คุณใช้ประจำ วางใน ops/inbox/ — ปลอดภัย ไม่ต้องยุ่ง integration ฝั่ง IT

**Odoo → เริ่มด้วย export ก็ได้ หรืออัปเกรดเป็น MCP:**
มี MCP server ให้เลือกหลายทาง เช่น module บน Odoo Apps Store (ค้น "MCP server" — ติดตั้งแล้วสร้าง API key จาก My Profile → Account Security ได้ config พร้อมวางสำหรับ Claude Code) หรือ open source เช่น odoo-mcp-pro (รองรับ Odoo 19 JSON/2 และ 14-18 XML-RPC)

ข้อบังคับตอนต่อ MCP:
- สร้าง Odoo user แยกสำหรับ AI ให้สิทธิ์ **read-only** เฉพาะโมดูลที่จำเป็น (ขาย/สต๊อก/บัญชีตามที่ใช้)
- **ห้ามใช้ admin key เด็ดขาด** — ACL ของ Odoo คือ safety net
- เริ่มจาก database ทดสอบ/สำเนาก่อน ถ้ามี

## ตัวอย่างการใช้

```text
(วาง export ยอดขาย มิ.ย. จาก Odoo + AR aging จาก SAP ใน ops/inbox/)

คุณ:  สรุปยอดขายเดือนมิถุนายน เทียบพฤษภาคม
  →  sales-analyst validate → เขียน script → รายงาน + ธงว่าไฟล์มีแถวซ้ำ 12 แถว
คุณ:  ลูกหนี้ค้างเกิน 60 วันมีใครบ้าง รวมเท่าไหร่
  →  finance-summarizer ทำ AR aging พร้อมชื่อ+ยอด+วันครบกำหนดเก่าสุด
คุณ:  เช็คสต๊อกหน่อย ควรสั่งอะไรเพิ่ม
  →  inventory-watcher ถาม lead time (ถ้ายังไม่กรอกใน CLAUDE.md) → รายการ URGENT + สูตรที่ใช้
```

## ต่อยอดข้ามทีม

- ยอดขายจาก sales-analyst → ป้อน content-strategist ("สินค้า A โต 40% → ทำคอนเทนต์ชูตัวนี้")
- ข้อมูล margin/ต้นทุน → ป้อน market-analyst ตอนประเมินไอเดียใหม่ว่าตั้งราคาไหวไหม
