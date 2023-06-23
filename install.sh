# 定义一些颜色常量
R="[1;31m" G="[1;32m" Y="[1;33m" C="[1;36m" B="[1;m" O="[m"

# 输出脚本信息
SCRIPT_NAME="nbum" # 脚本名称
SCRIPT_VERSION="1.0" # 脚本版本号
echo "$B----------------------------------------
    $R $SCRIPT_NAME $G安装$C脚本$O
     $G版本号：$C $SCRIPT_VERSION $O
----------------------------------------"

#确认安装
# 检查系统是否已安装依赖
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

if [ -d "$HOME/nbum" ]; then
  echo "仓库校验完成"
else
  echo -e "\033[34m你需要\033[35m克隆本仓库\033[34m才能正常使用\033[0m"
  echo -e "目前有有以下2种git仓库可使用
  github（国外推荐）  gitee（国内推荐）"
  echo -e "请选择一个选项 [\033[38;5;226;1mgithub/gitee/n\033[0m] "
  read juxu
  juxu=${juxu:-y}
  case $juxu in
  gitee)
    git clone https://gitee.com/lingfengai/nbum.git
    ;;
  github)
    git clone https://github.com/lingfengai2/nbum.git
    ;;
     *)
    exit 6
    ;;
  esac
    chmod u+x nbum/nbum.sh
    chmod u+x nbum/install.sh
    echo "$Y- 安装程序... $O"

    # 创建 nbum 文件
    touch "$PREFIX/bin/nbum"
    echo 'cd $home
    exec ./"nbum/nbum.sh" "$@"' >> $PREFIX/bin/nbum

     # 修改权限为 777
     chmod 777 $PREFIX/bin/nbum
     exec "$0"
     # 输出安装完成信息
     echo -e "
     $G$SCRIPT_NAME$C已成功安装。
     您现在可以使用 '$C nbum $O' 命令。$O"
fi

