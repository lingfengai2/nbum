#!/bin/bash
# 生成前四位随机字母
random_letters=$(cat /dev/urandom | tr -dc 'A-Z' | fold -w 4 | head -n 1)
# 生成后八位当前日期
current_date=$(date +"%Y%m%d")
# 生成密钥
key="${random_letters}${current_date}"
# 对密钥进行Base64转码
encoded_key=$(echo -n "$key" | base64)
# 输出转码后的密钥
echo -e "\e[32m密钥生成成功：\e[33m$encoded_key"