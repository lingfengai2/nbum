#!/bin/bash
in_name_version="nbum-install-2.0"
purple="\033[35m"
white="\033[0m"
red="\033[31m"
yellow="\033[33m"
blue="\033[34m"
cyan="\033[36m"
green="\033[32m"
nbum_home="$HOME/.nbum"
nbum_app="$nbum_home/nbum"
install_check() {
echo -e "${purple}正在安装依赖${white}"
if [ "$(uname -o)" == "GNU/Linux" ]; then
    if command -v apt-get >/dev/null 2>&1; then
        PM="apt install -y"
    elif command -v pacman >/dev/null 2>&1; then
        PM="pacman -Syu --noconfirm"
    else
        echo "$cyan请确认$purple Linux发行版$cyan是否受支持$white"
        exit 6
    fi
elif [ "$(uname -o)" == "Android" ]; then
    PM="pkg install -y"
else
    echo -e "$red无法确认系统$white"
fi
$PM dialog git which
if ! command -v dialog > /dev/null || ! command -v git > /dev/null || ! command -v which > /dev/null; then
    echo -e "${red}安装依赖失败，重新安装${white}"
    install_check
fi
}
gitee_or_github_menu() {
gitee_or_github="${purple}请选择${yellow}一个仓库${purple}来下载代码
${cyan}╭───┬───────┬────────┬──────────────────╮
│${yellow} # ${cyan}│${blue} 选项  │ 仓库源 │       描述       │
├───┼───────┼────────┼──────────────────┤
│${yellow} 0 ${cyan}│${blue} y     ${cyan}│ gitee  │ gitee国内速度快  │
│${yellow} 1 ${cyan}│${blue} n     ${cyan}│ github │ github国外速度快 │
╰───┴───────┴────────┴──────────────────╯${white}"
echo -e "$gitee_or_github"
echo -e "请输入一个选项 ${yellow}[Y/n]${white}"
read gitee_or_github
gitee_or_github=${gitee_or_github:-y}
case $gitee_or_github in
[yY]) git clone https://gitee.com/lingfengai/nbum.git ;;
[nN]) git clone https://github.com/lingfengai2/nbum.git ;;
*) echo -e "${green}请输入${yellow}正确的选项${white}"
   gitee_or_github_menu ;;
esac
if [ ! -d "$HOME/.nbum/nbum" ]; then
    cd "$nbum_home/nbum"
    echo -e "${red}下载失败，请重试${white}"
    gitee_or_github_menu
fi
}
if ! command -v dialog > /dev/null || ! command -v git > /dev/null || ! command -v which > /dev/null; then
    install_check
fi
if [ ! -d "$HOME/.nbum" ]; then
    mkdir "$HOME/.nbum"
fi
if [ ! -d "$HOME/.nbum/nbum" ]; then
    cd "$nbum_home"
    gitee_or_github_menu
fi
nbum_files=$(dirname "$(which bash)")
if [ ! -f "$nbum_files/nbum" ]; then
    touch "$nbum_files/nbum"
fi
line_to_append='exec "$HOME/.nbum/nbum/nbum.sh" "$@"'
if ! grep -q "$line_to_append" "$nbum_files/nbum" ; then
    > "$nbum_files/nbum"
    echo "$line_to_append" > "$nbum_files/nbum"
    chmod 777 "$nbum_files/nbum"
    echo -e "${purple}你可以使用 ${yellow}nbum ${purple}来启动脚本${white}"
    exec $SHELL
fi