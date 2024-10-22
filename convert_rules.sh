#!/bin/bash

# 遍历所有 *_OCD_*.txt 文件, 转换为实际可用的格式和 .mrs 文件
find . -name "*.txt" | while read -r file; do
    # 读取文件的第一行
    first_line=$(head -n 1 "$file")
    # 检查第一行是否包含 'payload'
    if [[ "$first_line" == *"payload"* ]]; then
        # 如果包含 'payload'，则删除
        sed -i '1d' "$file"
    fi
    # 删除所有单引号、减号和空格
    sed -i "s/'//g; s/-//g; s/[[:space:]]//g" "$file"

    # 获取文件的目录路径和文件名（不包含扩展名）
    filename=$(basename "$file" .txt)
    # 判断文件名中是否包含 "Domain" 或 "IP" 来选择参数
    if [[ "$filename" == *cidr* ]]; then
        param="ipcidr"
    else
        param="domain"
    fi
    # 设置输出的 .mrs 文件路径，使其与原文件目录一致
    output_file="$filename.mrs"
    # 使用 mihomo convert-ruleset 进行转换
    /usr/bin/mihomo convert-ruleset "$param" text "$file" "$output_file"
    # 输出转换状态
    if [[ $? -eq 0 ]]; then
        echo "文件 $file 转换成功为 $output_file"
    else
        echo "文件 $file 转换失败"
    fi
done
