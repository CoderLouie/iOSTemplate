# excel表格生成多语言strings文件

# 命令 python3 l10n_excel_2_strings.py
# 安装openpyxl 'python3 -m pip install openpyxl'

# 下载为excel 修改文件路径为xlsx文件路径
file_path = "/Users/liyang/Desktop/Program/2025/10/licowa.xlsx"

# 是否是转换InfoPlist
is_info_plist: bool = False
# 从excel文档的这个key(包括)往后的内容追加在string文件的末尾
# 如果是空则全覆盖
add_from_key: str = ""

strings_file = ("InfoPlist" if is_info_plist else "Localizable") + ".strings"

path_format = "../Resources/{}.lproj/" + strings_file

langs: list[str] = [
    "en", "zh-Hans", "zh-Hant", "ja", "ru", "es",
    "pt-BR", "pt-PT", "id", "ms", "fil",
    "my", "hi", "ar", "tr", "fr", "km"
]

#excel文档第一列Key，2～n列为相应多语言，第一行为语言码，第二行为key，语言码对应的中文描述[英文、简体中文、繁体中文...]

class LangValues:
    def __init__(self, key: str, is_comment: bool = False):
        self.key = key
        self.is_comment = is_comment
        self.lang_values: dict[str, str] = {}

from openpyxl import load_workbook

workbook = load_workbook(filename=file_path)

sheet = workbook["iOS_InfoPlist" if is_info_plist else "iOS"]

lang_cols: dict[str, str] = {}
noneTimes = 0
for cell in sheet['1']: # 第一行，找出每一种语言对应的列
    if noneTimes > 5: #连续5列都是空格，认为到达最右
        break
    val = cell.value
    if val is None or not isinstance(val, str):
        val = ""
    val = val.strip()
    if len(val) == 0:
        noneTimes += 1
        continue
    noneTimes = 0
    if val in langs:
        lang_cols[val] = cell.column_letter
    else:
        continue
print("找到语言对应的列", lang_cols)

lang_names: list[str] = []

lang_val_list: list[LangValues] = []
noneTimes = 0
for cell in sheet['A']:
    if noneTimes > 5:#连续出现5行空格认为到达尾部
        break
    
    key = cell.value
    if cell.row == 1:
        # 表头
        key = "LanguageCode"
    if cell.row == 2:
        # 表头
        key = "LanguageName"
    
    if key is None or not isinstance(key, str):
        key = ""
    key = key.strip()
    if len(key) == 0:
        lang_val_list.append(LangValues(key="", is_comment=True))
        noneTimes += 1
        continue
    noneTimes = 0
    if key.startswith("//"):
        lang_val_list.append(LangValues(key=key, is_comment=True))
        continue
    lang_val = LangValues(key=key)
    lang_val_list.append(lang_val)
    for l in langs:
        if l in lang_cols:
            column_letter = lang_cols[l]
            coor = "{}{}".format(column_letter, cell.row)
            value = sheet[coor].value
            if value is None or not isinstance(value, str):
                print("invalid coor content", coor)
                value = "INVALID EMPTY"
            # if "\\n" in value: # 这里不必再把\\n换成\n
            #     value = value.replace("\\n", "\n")
            value = value.strip()
            if cell.row == 2:
                lang_names.append(value)
            lang_val.lang_values[l] = value
print("多语言顺序", lang_names)
print("从excel找到key", len(lang_val_list), "个")
        
def check_str(s: str) -> str:
    return s.replace('"', '\\"')
#    if s.endswith("\\") and not s.endswith("\\\\"):
#        # 结尾是\符号，直接把句尾的";号给转义了。。最后会拼出 "xxx" = "xxx\";
#        s = s + "\"" #再加一个引号消除转义？
#    return s

for l in langs:
    savefilepath = path_format.format(l)
    print("写入语言strings", l, "路径", savefilepath)
    lines = []
    
    start_write = add_from_key == ""
                
    for index, val in enumerate(lang_val_list, start=1):
        
        k = check_str(val.key)
        if not start_write:
            if k == add_from_key:
                start_write = True
        if not start_write:
            continue
        
        if val.is_comment:
            # lines.append("") # 多一个空行
            lines.append(k)
            continue
        if l in val.lang_values:
            v = check_str(val.lang_values[l])
            line = "\"{}\" = \"{}\";".format(k, v)
            if is_info_plist and index < 3:
                line = "//" + line
            lines.append(line)
    
    lines.append("") #末尾加个空行
    content = "\n".join(lines)
    
    targetsavefiles = [savefilepath]
    
    for pa in targetsavefiles:
        if add_from_key == "":
            with open(pa, "w") as outfile:
                outfile.write(content)
        else:
            content = "\n" + content
            with open(pa, "a") as outfile:
                outfile.write(content)

print("finished请检查项目{}是否错漏".format(strings_file))


