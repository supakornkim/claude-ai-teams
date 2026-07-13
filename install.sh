#!/bin/bash
# ติดตั้ง agents + commands ทั้งหมดลง ~/.claude/
set -e
cd "$(dirname "$0")"

mkdir -p ~/.claude/agents ~/.claude/commands

a=0
for f in */agents/*.md; do
  cp "$f" ~/.claude/agents/
  a=$((a+1))
done

c=0
if compgen -G "commands/*.md" > /dev/null; then
  for f in commands/*.md; do
    cp "$f" ~/.claude/commands/
    c=$((c+1))
  done
fi

echo "✅ ติดตั้ง $a agents ลง ~/.claude/agents/"
echo "✅ ติดตั้ง $c commands ลง ~/.claude/commands/"
echo "ขั้นต่อไป: เปิดโปรเจกต์ใหม่ด้วย /new-project ได้เลย"
