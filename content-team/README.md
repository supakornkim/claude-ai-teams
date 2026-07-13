# AI Content Team สำหรับ Claude Code

ทีมทำ social media content: วางแผน → เขียนโพสต์ → ทำภาพ → ตรวจแบรนด์ → คุณกดโพสต์
รองรับหลายธุรกิจ: agent ชุดเดียว + brand profile แยกต่อธุรกิจ

## ติดตั้ง (ครั้งเดียว)

```bash
mkdir -p ~/.claude/agents
cp agents/*.md ~/.claude/agents/
```
(อยู่ร่วมกับทีม dev ได้ ไม่ชนกัน เพราะชื่อ agent คนละชุด)

## ตั้ง workspace ต่อธุรกิจ (~15 นาที/ธุรกิจ)

```bash
mkdir -p ~/content/business-a && cd ~/content/business-a
cp /path/to/CLAUDE.md.template ./CLAUDE.md   # กรอก brand profile ให้ครบ โดยเฉพาะข้อ 3, 5, 6
mkdir -p content/calendar content/posts content/visuals content/research/inbox
claude
```
มีกี่ธุรกิจก็ทำกี่โฟลเดอร์ — สลับธุรกิจ = cd ไปโฟลเดอร์นั้นแล้วเปิด claude

## ทีมงาน 4 ตัว

| Agent | หน้าที่ | Model |
|---|---|---|
| content-strategist | วาง content calendar ผูกกับเป้าธุรกิจ + เทรนด์ | sonnet |
| copywriter | เขียนโพสต์ 2 variants ต่อหัวข้อ แยกสไตล์ตาม platform | inherit (งาน creative ให้ตัวท็อป) |
| visual-designer | ทำ quote card/infographic เป็น PNG เองได้ หรือเขียน image prompt สำหรับ Midjourney/DALL-E | sonnet |
| brand-reviewer | ตรวจ voice, fact, ความเสี่ยงโฆษณา (อย., claim เกินจริง, ลิขสิทธิ์) ก่อนโพสต์ | sonnet |
| competitor-scout | ส่องคู่แข่งจากข้อมูลสาธารณะ + วิเคราะห์ screenshot ที่คุณโยนให้ ออกรายงาน intel รายเดือน | sonnet |
| trend-watcher | เฝ้าดูเทรนด์ตลาด/ผู้บริโภค/platform รายสัปดาห์ แยก TREND/WAVE/SIGNAL — **shared agent ใช้ได้ทั้งงาน content และงานไอเดีย** (โฟลเดอร์ dev มันจะสลับไปป้อนโอกาส product ให้ idea-groomer แทน) | sonnet |

## ตัวอย่างการใช้

```text
คุณ:  ส่องคู่แข่งประจำเดือนหน่อย (แคปหน้าจอเพจคู่แข่งใส่ content/research/inbox/ ไว้แล้ว)
  →  competitor-scout ออกรายงาน intel + 5 ไอเดียคอนเทนต์
คุณ:  วางแผนคอนเทนต์เดือนหน้าให้หน่อย ลง FB กับ IG โฟกัสโปรหน้าฝน อิงรายงาน intel ด้วย
  →  content-strategist ทำ calendar
คุณ:  เขียนโพสต์ตาม calendar วันที่ 1-5 เลย
  →  copywriter เขียน 2 variants/โพสต์ + visual note
คุณ:  ทำภาพให้โพสต์วันที่ 1 กับ 3
  →  visual-designer ทำ quote card เป็น PNG / ให้ prompt สำหรับรูปถ่าย
คุณ:  ตรวจทั้งหมดก่อนลง
  →  brand-reviewer ให้ PASS/FAIL + แนะนำ variant
คุณ:  กดโพสต์เอง ✅
```

## เรื่องรูป — ต้องรู้

- **ทำเองได้เลย:** quote card, infographic, ป้ายโปร, price list — agent สร้าง HTML แล้ว render เป็น PNG (ต้องมี headless browser: `npm i -D playwright && npx playwright install chromium`)
- **ทำเองไม่ได้:** รูปถ่าย/ภาพ AI แนว photographic — agent จะเขียน prompt ภาษาอังกฤษละเอียดๆ ให้เอาไปวางใน Midjourney / DALL-E / เครื่องมืออื่น
- **ทางที่สาม:** ต่อ MCP server ของบริการ image generation เข้า Claude Code แล้วบอก visual-designer ให้เรียกใช้ได้เลย

## กติกาความปลอดภัย (ฝังใน agent แล้ว)

- ไม่สร้างรีวิวปลอม สถิติปลอม ความ urgent ปลอม
- ไม่ทำ claim สุขภาพ/การเงินที่ไม่มีแหล่งอ้างอิงจากคุณ
- brand-reviewer สแกนความเสี่ยงบริบทไทย (อย., "ดีที่สุด" ไม่มีหลักฐาน, ลิขสิทธิ์เพลง/มีม)
- มนุษย์กดโพสต์เองเสมอ ไม่มี auto-post
