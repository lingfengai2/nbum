#!/bin/bash
# 检查系统是否已安装 dialog
if ! command -v dialog > /dev/null || ! command -v python3 > /dev/null || ! command -v git > /dev/null ; then
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
read confirm
confirm=${confirm:-y}

case $confirm in
  [yY]|[yY][eE][sS])
    # 检查包管理器并设置对应变量
    if [ "$(uname -o)" == "GNU/Linux" ]; then
      if command -v apt-get >/dev/null 2>&1; then
        apt install -y dialog git python3 python3-pip
      elif command -v pacman >/dev/null 2>&1; then
        pacman -Syu --noconfirm dialog git python-pip
      else
        echo "未知的 Linux 发行版或包管理器"
        exit 6
      fi
    else
      pkg update
      apt install -y dialog git python-pip
    fi
    ;;
  *)
    exit 6
    ;;
esac
else
echo -e "依赖校验完成✅"
fi
cd $home
if [ -d "$HOME/nbum" ]; then
  echo "仓库校验完成"
else
  echo -e "\033[34m你需要\033[35m克隆本仓库\033[34m才能正常使用\033[0m"
  echo -e "您要继续吗? [\033[38;5;226;1mY/n\033[0m] "
  read juxu
  juxu=${juxu:-y}
  case $juxu in
  [yY]|[yY][eE][sS])
    git clone https://gitee.com/lingfengai/nbum.git
    chmod u+x nbum/nbum.sh
    chmod u+x nbum/install.sh
    # 定义要检查的 shell 配置文件
    CONFIG_FILES=(".bashrc")
    CONFIG_FILES2=(".zshrc")
# 定义要添加的命令别名
    CMD_ALIAS="alias nbum=\"$HOME/nbum/nbum.sh\""
    # 检查别名是否存在于配置文件中
    if grep -Fxq "$CMD_ALIAS" "$CONFIG_FILES"
    then
        echo -e "\033[34m你可以输入\033[33m nbum \033[34m来启动脚本\033[0m"
    else
        # 如果别名不存在，则将其添加到文件末尾
        echo "$CMD_ALIAS" >> "$CONFIG_FILES"
        echo -e "\033[34m重启终端后可以输入\033[33m nbum \033[34m来启动脚本\033[0m"
    fi
   if grep -Fxq "$CMD_ALIAS" "$CONFIG_FILES2"
    then
        echo -e "\033[34m你可以输入\033[33m nbum \033[34m来启动脚本\033[0m"
    else
        echo "$CMD_ALIAS" >> "$CONFIG_FILES2"
        echo -e "\033[34m重启终端后可以输入\033[33m nbum \033[34m来启动脚本\033[0m"
    fi
    ;;
      *)
    echo "无效的输入，操作已取消"
    exit 6
    ;;
  esac
fi



