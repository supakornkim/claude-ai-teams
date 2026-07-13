รับหน้าที่เปิดโปรเจกต์ใหม่ตามระบบทีม AI ของผู้ใช้ โดยทำตามขั้นตอนนี้อย่างเคร่งครัด:

Input จากผู้ใช้ (อาจว่าง): $ARGUMENTS

## ขั้นที่ 1 — เก็บข้อมูล
ถ้า $ARGUMENTS ไม่ได้ระบุครบ ให้ถามผู้ใช้จนได้ครบ 3 อย่าง:
1. ชื่อโปรเจกต์ (ใช้เป็นชื่อโฟลเดอร์ — แนะนำ english-kebab-case)
2. ประเภทงาน (เลือกหนึ่ง): dev / content / ops / erp-client / ผสม (ระบุว่าผสมอะไร)
3. path ที่จะสร้าง (เสนอ default ตามประเภท: dev→~/projects/ content→~/content/ ops→~/ops/ erp-client→~/clients/)

## ขั้นที่ 2 — สร้างโครงโฟลเดอร์ตามประเภท
- dev: docs/{ideas,research,specs,tasks,qa-reports} + สร้าง docs/_queue.json เนื้อหา {}
- content: content/{calendar,posts,visuals,research/inbox}
- ops: ops/{inbox,reports,scripts,archive}
- erp-client: project/{requirements,specs,config,uat,cr,minutes}
- ผสม: รวมโครงของทุกประเภทที่ระบุ + เพิ่ม strategy/ และ evals/ เสมอ

## ขั้นที่ 3 — วาง CLAUDE.md
- copy template จาก repo กลางของผู้ใช้ (ถามตำแหน่งครั้งแรกแล้วจำไว้ — ปกติคือ ~/claude-ai-teams/<ทีม>/CLAUDE.md.template)
- ถ้าเป็นงานผสม: ใช้ template ของประเภทหลัก แล้วต่อท้ายด้วย section ที่เกี่ยวจาก template อื่น
- จากนั้นสัมภาษณ์ผู้ใช้สั้นๆ (ครั้งละไม่เกิน 3 คำถาม) เพื่อกรอก section สำคัญที่สุดของประเภทนั้น:
  - dev: ธุรกิจคืออะไร / tech stack / เป้าหมาย
  - content: brand voice + ตัวอย่างประโยคใช่-ไม่ใช่ / platforms / facts bank
  - ops: ระบบ ERP อะไร / column mapping ของ export / รอบการทำงาน
  - erp-client: system landscape เวอร์ชันเป๊ะๆ / scope / คนสำคัญฝั่งลูกค้า / data policy (cloud/hybrid/local)
- ส่วนที่ผู้ใช้ยังไม่รู้ ให้เขียน TBD ห้ามลบหัวข้อ ห้ามแต่งข้อมูลแทนผู้ใช้เด็ดขาด

## ขั้นที่ 4 — Git
git init + สร้าง .gitignore ที่เหมาะกับประเภท (ops ต้อง ignore ops/inbox/ และไฟล์ .xlsx .csv,
ทุกประเภท ignore ไฟล์ secret/API key) + commit แรกข้อความ "เปิดโปรเจกต์: <ชื่อ>"

## ขั้นที่ 5 — ลงทะเบียน PMO
- เปิด ~/pmo/CLAUDE.md แล้วเพิ่มแถวใหม่ในตาราง workspace registry ข้อ 1:
  | <ชื่อโปรเจกต์> | <ประเภท> | <path เต็ม> | <หมายเหตุถ้ามี> |
- ถ้าไม่พบ ~/pmo/CLAUDE.md ให้แจ้งผู้ใช้ว่ายังไม่ได้ตั้ง PMO workspace และถามว่าจะตั้งเลยไหม

## ขั้นที่ 6 — สรุปปิดงาน
รายงานสั้นๆ: โครงที่สร้าง / section ใน CLAUDE.md ที่ยังเป็น TBD (เตือนให้กลับมากรอก) /
ยืนยันว่าลงทะเบียน PMO แล้ว / แนะนำคำสั่งแรกที่ควรใช้ตามประเภทงาน
(dev: "โยนไอเดียใส่ groomer" / erp-client: "ให้ ba-requirement เตรียม interview kit" /
content: "ให้ content-strategist วางแผนเดือนแรก" / ops: "วาง export แรกใน inbox แล้วเรียก sales-analyst")

กติกา: ทำตามลำดับ ห้ามข้ามขั้น 5 (โปรเจกต์ที่ไม่ลงทะเบียน = ล่องหนจากรายงาน PMO)
และห้ามเริ่มทำงานเนื้อหาของโปรเจกต์ (groom, spec ฯลฯ) ใน command นี้ — จบที่พิธีเปิดเท่านั้น
