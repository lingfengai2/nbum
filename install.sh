#!/bin/bash

# 输出脚本信息
SCRIPT_NAME="nbum" # 脚本名称
SCRIPT_VERSION="1.0" # 脚本版本号
#确认安装
# 检查系统是否已安装依赖
if ! command -v dialog > /dev/null || ! command -v python3 > /dev/null || ! command -v git > /dev/null || ! command -v which > /dev/null; then
    yilai
else
    echo -e "依赖校验完成✅"
fi
yilai() {
echo -e "依赖校验失败❌"
echo -e "\033[36m你需要\033[33m安装依赖包\033[36m才能使用\033[0m"
# 打印菜单
header="\033[38;5;203;1m╭───┬───────┬───────────┬──────────────────┬───────────────────╮\033[0m"
option_header="\033[38;5;226;1m│ # \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m选项  \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m描述      \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m   yes           \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m       no         \033[0m\033[38;5;226;1m│\033[0m"
footer="\033[38;5;203;1m╰───┴───────┴───────────┴──────────────────┴───────────────────╯\033[0m"

option0="\033[38;5;133;1m│ 0 \033[0m\033[38;5;40m│[Y/n]  \033[0m\033[38;5;244;2m│ 默认为yes \033[0m\033[38;5;244;2m│ 直接按回车键     \033[0m\033[38;5;166;2m│ 先输入n，再按回车 \033[0m\033[38;5;133;1m│\033[0m"
option1="\033[38;5;132;1m│ 1 \033[0m\033[38;5;104m│[y/N]  \033[0m\033[38;5;244;2m│ 默认为no  \033[0m\033[38;5;166;2m│先输入y，再按回车 \033[0m\033[38;5;244;2m│ 直接按回车键      \033[0m\033[38;5;132;1m│\033[0m"

echo -e "$header"
echo -e "$option_header"
echo -e "$option0"
echo -e "$option1"
echo -e "$footer"

echo -e "您要继续吗? [\033[38;5;226;1mY/n\033[0m] "
read confirm
confirm=${confirm:-y}

case $confirm in
  [yY]|[yY][eE][sS])
    # 检查包管理器并设置对应变量
    if [ "$(uname -o)" == "GNU/Linux" ]; then
      if command -v apt-get >/dev/null 2>&1; then
        apt install -y dialog git python3 python3-pip which
      elif command -v pacman >/dev/null 2>&1; then
        pacman -Syu --noconfirm dialog git python-pip which
      else
        echo "未知的 Linux 发行版或包管理器"
        exit 6
      fi
    else
      pkg install -y dialog git python-pip which
    fi
    ;;
  *)
    exit 6
    ;;
esac
}
if [ -d "$HOME/nbum" ]; then
    echo "仓库校验完成✅"
else
    kelong
fi
kelong() {
echo -e "\e[38;5;159m您需要\e[38;5;70m克隆本仓库\e[38;5;159m才能使用\033[0m"
  git2="\033[38;5;203;1m╭───┬───────┬───────────┬──────────────────┬───────────────────╮\033[0m"
  git3="\033[38;5;226;1m│ # \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m选项  \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m描述      \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m   yes           \033[0m\033[38;5;120;1m│ \033[0m\033[38;5;120;1m       no         \033[0m\033[38;5;226;1m│\033[0m"
  git5="\033[38;5;133;1m│ 0 \033[0m\033[38;5;40m│[Y/n]  \033[0m\033[38;5;244;2m│默认gitee \033[0m\033[38;5;244;2m │按回车键选择gitee \033[0m\033[38;5;166;2m│输n按回车选择github\033[0m\033[38;5;133;1m│\033[0m"
  git6="\033[38;5;132;1m│ 1 \033[0m\033[38;5;104m│[y/N]  \033[0m\033[38;5;244;2m│默认github \033[0m\033[38;5;166;2m│按回车选择github  \033[0m\033[38;5;244;2m│输入n回车选择gitee \033[0m\033[38;5;132;1m│\033[0m"
  git1="\033[38;5;203;1m╰───┴───────┴───────────┴──────────────────┴───────────────────╯\033[0m"
  echo -e "$git2"
  echo -e "$git3"
  echo -e "$git5"
  echo -e "$git6"
  echo -e "$git1"
  echo -e "您要继续吗? [\033[38;5;226;1mY/n\033[0m] "
  read juxu
  juxu=${juxu:-y}
  case $juxu in
  [yY])
    git clone https://gitee.com/lingfengai/nbum.git
    ;;
  [nN])
    git clone https://github.com/lingfengai2/nbum.git
    ;;
     *)
    exit 6
    ;;
  esac
    chmod u+x nbum/nbum.sh
    chmod u+x nbum/install.sh
}

# 创建 nbum 文件
nbumfiles=$(dirname "$(which bash)")
if [ -z "$nbumfiles/nbum" ]; then
  touch "$nbumfiles/nbum"
fi
if grep -q 'cd $home
exec ./'nbum/nbum.sh' "$@"' $nbumfiles/nbum > /dev/null 2>&1; then
    echo "你可以使用 nbum 来启动脚本"
else
    echo 'cd $home
exec ./"nbum/nbum.sh" "$@"' >> $nbumfiles/nbum
    # 修改权限为 777
    chmod 777 "$nbumfiles/nbum"
    # 输出安装完成信息
    echo "你可以使用 nbum 来启动脚本"
    exec $SHELL
fi
