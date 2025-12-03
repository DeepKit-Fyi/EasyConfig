import yaml
import json
import os

# 源文件和目标文件路径
yaml_path = os.path.join('config', 'template copy.yaml')
json_path = os.path.join('config', 'subtitle_to_v-template-001.json')

# 读取YAML文件
with open(yaml_path, 'r', encoding='utf-8') as yaml_file:
    yaml_data = yaml.safe_load(yaml_file)

# 写入JSON文件
with open(json_path, 'w', encoding='utf-8') as json_file:
    json.dump(yaml_data, json_file, ensure_ascii=False, indent=2)

print(f'已成功将 {yaml_path} 转换为 {json_path}') 