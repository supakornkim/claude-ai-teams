#!/bin/bash
# sync.sh — commit + push + ติดตั้งลงเครื่อง ในคำสั่งเดียว
# ใช้: ./sync.sh "ข้อความ commit"
set -e
cd "$(dirname "$0")"

git add -A
git commit -m "${1:-update agents}"
git push
./install.sh
echo "✅ push แล้ว + Claude Code ใช้เวอร์ชันล่าสุดแล้ว"
