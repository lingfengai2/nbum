#!/bin/bash
# 读取用户输入的转码后的密钥
encoded_key=$(dialog --stdout --inputbox "请输入密钥:" 0 0)

# 解码密钥
decoded_key=$(echo -n "$encoded_key" | base64 -d)
# 密钥格式的正则表达式：前四位为字母，后八位为数字
key_regex="^[A-Z]{4}[0-9]{8}$"
# 检查解码后的密钥格式是否正确
if [[ $decoded_key =~ $key_regex ]]; then
    # 提取字母部分
    letters=${decoded_key:0:4}
    # 提取日期部分
    date=${decoded_key:4}
    # 获取当前日期
    current_date=$(date +"%Y%m%d")
    # 检查密钥日期是否超过当前日期
    if [[ $date -gt $current_date ]]; then
        echo -e "\e[31m密钥错误"
    else
        echo -e "\e[32m密钥正确"
        echo -e "\e[32m密钥生成时间为：\e[33m$date"
    fi
else
    echo -e "\e[31m密钥错误"
fi