#!/bin/bash
# install-gemini.sh — ติดตั้ง Claude Agents ให้เป็น Gemini Antigravity Skills
set -e
cd "$(dirname "$0")"

# 1. ติดตั้งแบบ Global (~/.gemini/config/skills/)
GEMINI_GLOBAL_SKILLS="$HOME/.gemini/config/skills"
mkdir -p "$GEMINI_GLOBAL_SKILLS"

# 2. ติดตั้งแบบ Local (.agents/skills/) ในโปรเจกต์นี้
GEMINI_LOCAL_SKILLS=".agents/skills"
mkdir -p "$GEMINI_LOCAL_SKILLS"

a_global=0
a_local=0

# ค้นหาไฟล์ .md ของ Agent จากโฟลเดอร์ของทุกทีม
for f in */agents/*.md; do
  # หาชื่อ agent จากชื่อไฟล์ (เช่น dev-team/agents/architect.md -> architect)
  agent_name=$(basename "$f" .md)
  
  # 1. คัดลอกไปยัง Global Skills
  mkdir -p "$GEMINI_GLOBAL_SKILLS/$agent_name"
  cp "$f" "$GEMINI_GLOBAL_SKILLS/$agent_name/SKILL.md"
  a_global=$((a_global+1))
  
  # 2. คัดลอกไปยัง Local Workspace Skills
  mkdir -p "$GEMINI_LOCAL_SKILLS/$agent_name"
  cp "$f" "$GEMINI_LOCAL_SKILLS/$agent_name/SKILL.md"
  a_local=$((a_local+1))
done

echo "✅ ติดตั้ง $a_global agents ไปยัง Global Gemini Skills: ~/.gemini/config/skills/"
echo "✅ ติดตั้ง $a_local agents ไปยัง Local Gemini Skills: .agents/skills/"
echo "คุณสามารถใช้ Gemini Antigravity เรียกใช้ agent เหล่านี้ได้ทันที!"
