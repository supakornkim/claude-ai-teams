#!/usr/bin/env python3
import os
import re
import glob

# Destinations
global_skills_dir = os.path.expanduser('~/.gemini/config/skills')
global_agents_dir = os.path.expanduser('~/.gemini/config/agents')

os.makedirs(global_skills_dir, exist_ok=True)
os.makedirs(global_agents_dir, exist_ok=True)

a_skills = 0
a_agents = 0

# Find all team agents in the project
for path in glob.glob('*/agents/*.md'):
    agent_name = os.path.splitext(os.path.basename(path))[0]
    
    try:
        content = open(path).read()
        parts = content.split('---')
        if len(parts) >= 3:
            yaml_block = parts[1]
            
            # Find name and description in YAML frontmatter using regex
            name_match = re.search(r'^name:\s*(.*)$', yaml_block, re.MULTILINE)
            desc_match = re.search(r'^description:\s*(.*)$', yaml_block, re.MULTILINE)
            
            name = name_match.group(1).strip() if name_match else agent_name
            desc = desc_match.group(1).strip() if desc_match else ''
            
            # Sanitize description: strip outer quotes if any, and replace inner double quotes with single quotes
            if (desc.startswith('"') and desc.endswith('"')) or (desc.startswith("'") and desc.endswith("'")):
                desc = desc[1:-1]
            desc = desc.replace('"', "'")
            
            # Generate clean YAML frontmatter
            clean_yaml = f'name: {name}\ndescription: "{desc}"\n'
            
            # Reconstruct the file with cleaned YAML frontmatter
            clean_content = '---\n' + clean_yaml + '---\n' + '---'.join(parts[2:])
            
            # Write to Global Skills (SKILL.md)
            skill_folder = os.path.join(global_skills_dir, name)
            os.makedirs(skill_folder, exist_ok=True)
            with open(os.path.join(skill_folder, 'SKILL.md'), 'w') as f:
                f.write(clean_content)
            a_skills += 1
            
            # Write to Global Agents (agent.md)
            agent_folder = os.path.join(global_agents_dir, name)
            os.makedirs(agent_folder, exist_ok=True)
            with open(os.path.join(agent_folder, 'agent.md'), 'w') as f:
                f.write(clean_content)
            a_agents += 1
            
    except Exception as e:
        print(f"Error processing {path}: {e}")

print(f"✅ Robustly installed {a_skills} skills to {global_skills_dir}")
print(f"✅ Robustly installed {a_agents} agents to {global_agents_dir}")
