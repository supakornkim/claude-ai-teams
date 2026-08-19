#!/bin/bash
# install-gemini.sh — ติดตั้ง Claude Agents ให้เป็น Gemini Antigravity Skills
set -e
cd "$(dirname "$0")"

# 1. โฟลเดอร์ติดตั้งแบบ Global
GEMINI_GLOBAL_SKILLS="$HOME/.gemini/config/skills"
GEMINI_GLOBAL_AGENTS="$HOME/.gemini/config/agents"

mkdir -p "$GEMINI_GLOBAL_SKILLS"
mkdir -p "$GEMINI_GLOBAL_AGENTS"

a_global_skills=0
a_global_agents=0

# ค้นหาไฟล์ .md ของ Agent จากโฟลเดอร์ของทุกทีม
for f in */agents/*.md; do
  # หาชื่อ agent จากชื่อไฟล์ (เช่น dev-team/agents/architect.md -> architect)
  agent_name=$(basename "$f" .md)
  
  # 1. คัดลอกไปยัง Global Skills (เรียกใช้เป็นความสามารถเสริมในแชทเดิม)
  mkdir -p "$GEMINI_GLOBAL_SKILLS/$agent_name"
  cp "$f" "$GEMINI_GLOBAL_SKILLS/$agent_name/SKILL.md"
  a_global_skills=$((a_global_skills+1))

  # 2. คัดลอกไปยัง Global Agents (สำหรับสลับบทบาทผ่านเมนู /agents ใน CLI)
  mkdir -p "$GEMINI_GLOBAL_AGENTS/$agent_name"
  cp "$f" "$GEMINI_GLOBAL_AGENTS/$agent_name/agent.md"
  a_global_agents=$((a_global_agents+1))
done

echo "✅ ติดตั้ง $a_global_skills agents ไปยัง Global Gemini Skills: ~/.gemini/config/skills/"
echo "✅ ติดตั้ง $a_global_agents agents ไปยัง Global Gemini Agents: ~/.gemini/config/agents/"
echo "คุณสามารถเรียกใช้เป็น Skill ในแชท หรือกดสลับร่างผ่านคำสั่ง /agents บน CLI ได้ทันที!"
