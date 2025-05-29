#!/bin/bash

find . -name "*.txt" | while read -r file; do
    first_line=$(head -n 1 "$file")
    if [[ "$first_line" == *"payload"* ]]; then
        sed -i '1d' "$file"
    fi
    sed -i "s/'//g; s/-//g; s/[[:space:]]//g" "$file"

    filename=$(basename "$file" .txt)

    if [[ "$filename" == *ip* ]]; then
        param="ipcidr"
    else
        param="domain"
    fi

    output_file="$filename.mrs"

    /usr/bin/mihomo convert-ruleset "$param" text "$file" "$output_file"

    if [[ $? -eq 0 ]]; then
        echo "文件 $file 转换成功为 $output_file"
    else
        echo "文件 $file 转换失败"
    fi
done
