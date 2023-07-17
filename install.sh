#!/bin/bash

# 输出脚本信息
NAME="nbum" # 脚本名称
VERSION="1.0" # 脚本版本号
cd $home
yilai() {
    if [ "$(uname -o)" == "GNU/Linux" ]; then
      if command -v apt-get >/dev/null 2>&1; then
        apt install -y dialog git which
      elif command -v pacman >/dev/null 2>&1; then
        pacman -Syu --noconfirm dialog git which
      else
        echo "未知的 Linux 发行版或包管理器"
        exit 6
      fi
    else
      pkg install -y dialog git which
    fi
}
kelong() {
echo -e "\e[38;5;159m您需要\e[38;5;70m选择一个软件源\e[38;5;159m才能继续\033[0m"
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
     *) ;;
  esac
    chmod u+x nbum/nbum.sh
    chmod u+x nbum/install.sh
}
nbum_install() {
if grep -q 'cd $home
exec ./'nbum/nbum.sh' "$@"' $nbumfiles/nbum > /dev/null 2>&1; then
    echo -e "完成"
else
    echo 'cd $home
exec ./"nbum/nbum.sh" "$@"' >> $nbumfiles/nbum
    # 修改权限为 777
    chmod 777 "$nbumfiles/nbum"
    echo -e "完成"
    exec $SHELL
fi
}
# 检查系统是否已安装依赖
echo -e "正准备安装 $NAME"
if ! command -v dialog > /dev/null || ! command -v git > /dev/null || ! command -v which > /dev/null; then
    yilai
fi
# 创建 nbum 文件
echo "注意:选中 $NAME$VERSION，而非 $NAME"
nbumfiles=$(dirname "$(which bash)")
echo -e "正在编译软件包源文件"
if [ -d "$HOME/nbum" ]; then
    echo -e "原文件已存在"
else
    kelong
fi
if [ ! -f "$nbumfiles/nbum" ]; then
  touch "$nbumfiles/nbum"
  echo -e "正在处理软件包介质文件"
  nbum_install
fi