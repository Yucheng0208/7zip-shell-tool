#!/bin/bash

CONFIG_FILE="$HOME/.7zconfig"

# 設定語言
function select_language() {
    echo "Select language / 選擇語言:"
    echo "1. English"
    echo "2. 中文"
    read lang_choice

    case "$lang_choice" in
        1) echo "LANG=EN" > "$CONFIG_FILE";;
        2) echo "LANG=ZH" > "$CONFIG_FILE";;
        *) echo "Invalid choice. Defaulting to English."; echo "LANG=EN" > "$CONFIG_FILE";;
    esac
}

# 如果設定檔不存在，提示語言選擇
if [ ! -f "$CONFIG_FILE" ]; then
    select_language
fi

# 讀取語言設定
source "$CONFIG_FILE"

# 根據語言載入對應文字
if [[ "$LANG" == "ZH" ]]; then
    T_7Z_PATH="請輸入 7z 可執行檔路徑（按 Enter 使用預設 /usr/local/bin/7z）："
    T_TARGET="請輸入目標資料夾或檔案路徑："
    T_OP="選擇操作：1. 壓縮  2. 解壓縮  3. 顯示內容"
    T_OUT_NAME="輸出檔名（可留空使用原始名稱）："
    T_OUT_DIR="輸出資料夾（可留空使用原始位置）："
    T_FMT="選擇格式：1. 7z  2. zip  3. tar  4. gz  5. xz"
    T_LEVEL="壓縮等級（0-store, 1-fastest, 3-fast, 5-normal, 7-maximum, 9-ultra）："
    T_DONE="✅ 完成"
    T_ERR="❌ 發生錯誤"
else
    T_7Z_PATH="Please enter the path to 7z executable (Press Enter for default /usr/local/bin/7z):"
    T_TARGET="Enter target file or directory:"
    T_OP="Select operation: 1. Compress  2. Extract  3. List"
    T_OUT_NAME="Enter output file name (leave empty to use original name):"
    T_OUT_DIR="Enter output directory (leave empty to use original location):"
    T_FMT="Choose format: 1. 7z  2. zip  3. tar  4. gz  5. xz"
    T_LEVEL="Compression level (0-store, 1-fastest, 3-fast, 5-normal, 7-maximum, 9-ultra):"
    T_DONE="✅ Done"
    T_ERR="❌ Error occurred"
fi

# ---------- 主邏輯 ----------
DEFAULT_7Z="/usr/local/bin/7z"
echo "$T_7Z_PATH"
read -e sevenzip
sevenzip=${sevenzip:-$DEFAULT_7Z}

if [ ! -x "$sevenzip" ]; then
    echo "$T_ERR: $sevenzip"
    exit 1
fi

echo "$T_TARGET"
read -e target
if [ ! -e "$target" ]; then
    echo "$T_ERR: target does not exist"
    exit 1
fi

echo "$T_OP"
read operation

if [[ "$operation" == "1" ]]; then
    echo "$T_OUT_NAME"
    read output_name
    echo "$T_OUT_DIR"
    read -e output_dir
    echo "$T_FMT"
    read format_choice
    case $format_choice in
        1) extension="7z";;
        2) extension="zip";;
        3) extension="tar";;
        4) extension="gz";;
        5) extension="xz";;
        *) echo "$T_ERR: invalid format"; exit 1;;
    esac
    echo "$T_LEVEL"
    read level
    extension=${extension:-7z}
    level=${level:-5}
    output_name=${output_name:-$(basename "$target")}
    output_dir=${output_dir:-$(dirname "$target")}
    output_path="$output_dir/$output_name.$extension"
    "$sevenzip" a -t"$extension" -mx="$level" "$output_path" "$target"

elif [[ "$operation" == "2" ]]; then
    echo "$T_OUT_DIR"
    read -e extract_dir
    extract_dir=${extract_dir:-$(dirname "$target")}
    "$sevenzip" x "$target" -o"$extract_dir"

elif [[ "$operation" == "3" ]]; then
    "$sevenzip" l "$target"

else
    echo "$T_ERR: invalid operation"
    exit 1
fi

echo "$T_DONE"
