#!/bin/bash
# 检查系统是否已安装 dialog
if ! command -v dialog > /dev/null || ! command -v catimg > /dev/null || ! command -v git > /dev/null; then
   echo -e "依赖校验失败❌"
echo -e "\033[36m你需要\033[33m安装依赖包\033[36m才能使用\033[0m"
# 打印菜单
header="\033[38;5;203;1m╭───┬───────┬───────────┬──────────────────┬───────────────────╮\033[0m"
option_header="\033[38;5;226;1m│ # \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m选项  \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m描述      \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m   yes           \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m       no         \033[0m\033[38;5;226;1m│\033[0m"
footer="\033[38;5;203;1m╰───┴───────┴───────────┴──────────────────┴───────────────────╯\033[0m"

option0="\033[38;5;133;1m│ 0 \033[0m\033[38;5;40m│[Y/n]  \033[0m\033[38;5;244;2m│ 默认为yes \033[0m\033[38;5;244;2m│ 直接按回车键     \033[0m\033[38;5;166;2m│ 先输入n，再按回车 \033[0m\033[38;5;133;1m│\033[0m"
option1="\033[38;5;132;1m│ 1 \033[0m\033[38;5;104m│[y/N]  \033[0m\033[38;5;244;2m│ 默认为no  \033[0m\033[38;5;166;2m│先输入y，再按回车 \033[0m\033[38;5;244;2m│ 直接按回车键      \033[0m\033[38;5;132;1m│\033[0m"

echo -e "确认 [\033[38;5;226;1mY/n\033[0m]:"
echo -e "关闭 [\033[38;5;226;1my/N\033[0m]:"
echo -e "$header"
echo -e "$option_header"
echo -e "$option0"
echo -e "$option1"
echo -e "$footer"

echo -e "您要继续吗? [\033[38;5;226;1mY/n\033[0m] "
read -p "" confirm
confirm=${confirm:-y}

case $confirm in
  [yY]|[yY][eE][sS])
    # 检查包管理器并设置对应变量
    if command -v apt-get >/dev/null 2>&1; then
    PM="apt install"
    elif command -v pacman >/dev/null 2>&1; then
    PM="pacman -S"
    else
    echo "未知的 Linux 发行版或包管理器"
    exit 1
    fi

    # 利用 PM 变量安装软件包
    $PM dialog git
    if ! command -v dialog &> /dev/null; then
        echo "安装依赖失败，滚吧"
        exit 5
    fi
    ;;
  [nN]|[nN][oO])
    exit 0
    ;;
  *)
    echo "无效的输入，操作已取消"
    ;;
esac
else
echo -e "依赖校验完成✅"
fi
cd $home
if [ -d "$HOME/nbum" ]; then
  ./nbum/nbum.sh
else
  echo -e "\033[34m你需要\033[35m克隆本仓库\033[34m才能正常使用\033[0m"
  echo -e "您要继续吗? [\033[38;5;226;1mY/n\033[0m] "
  read -p "" juxu
  juxu=${juxu:-y}
  case $juxu in
  [yY]|[yY][eE][sS])
    git clone https://gitee.com/lingfengai/nbum.git
    chmod u+x nbum/nbum.sh
    chmod u+x nbum/install.sh
    ./nbum/nbum.sh
    ;;
      *)
    echo "无效的输入，操作已取消"
    ;;
  esac
fi