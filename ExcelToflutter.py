import pandas as pd

# 엑셀 파일 읽기
file_path = "intl_strings.xlsx"
df = pd.read_excel(file_path)
j = 0
# 빈 딕셔너리 생성
translations_map = {}
# 데이터 변환 및 \n 추가
for i in range(len(df)):
    key = df["Key"][i]
    ko_text = str(df["Korean Text"][i]).replace("\n", "\\n").replace(
        "'", "\\'") if pd.notna(df["Korean Text"][i]) else ""
    en_text = str(df["English Text"][i]).replace("\n", "\\n").replace(
        "'", "\\'") if pd.notna(df["English Text"][i]) else ""
    translations_map[key] = {
        'ko': ko_text,
        'en': en_text
    }

    j = i

# Flutter 코드 생성
flutter_code = "final kTranslationsMap = <Map<String, Map<String, String>>>[\n  {\n"
for key, value in translations_map.items():
    flutter_code += f"    '{key}': {{\n"
    flutter_code += f"      'ko': '{value['ko']}',\n"
    flutter_code += f"      'en': '{value['en']}',\n"
    flutter_code += "    },\n"
flutter_code += "  },\n].reduce((a, b) => a..addAll(b));"
# print(flutter_code)
print(j)
# Flutter 코드 다트 파일로 저장
dart_file_path = "translations_map.dart"
with open(dart_file_path, "w", encoding="utf-8") as file:
    file.write(flutter_code)
