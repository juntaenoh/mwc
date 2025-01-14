import json
import pandas as pd

# JSON 파일 읽기
with open('intl_en.arb', 'r', encoding='utf-8') as f:
    en_data = json.load(f)

with open('intl_ko.arb', 'r', encoding='utf-8') as f:
    ko_data = json.load(f)

# 메타데이터를 제외한 키-값 쌍 추출
en_translations = {k: v for k, v in en_data.items() if not k.startswith('@')}
ko_translations = {k: v for k, v in ko_data.items() if not k.startswith('@')}

# 데이터 병합
keys = en_translations.keys()
data = {
    "Key": [],
    "English Text": [],
    "Korean Text": []
}

for key in keys:
    data["Key"].append(key)
    data["English Text"].append(en_translations.get(key, ""))
    data["Korean Text"].append(ko_translations.get(key, ""))

# DataFrame 생성
df = pd.DataFrame(data)

# 엑셀 파일로 저장
file_path = "intl_strings.xlsx"
df.to_excel(file_path, index=False)

print(f"Excel file saved to {file_path}")
