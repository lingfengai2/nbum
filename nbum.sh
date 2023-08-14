#!/bin/bash
nbum_loading(){
cd "$HOME/.nbum/nbum"
dialog --infobox "正在校验仓库完整性" 6 30
sleep 1
if [[ -n $(git status -s) ]]; then
    dialog --title "警告:1001" --msgbox "完整性校验失败，请重新安装NBUM" 6 40
fi
}
nbum_update(){
version=$(head -n 1 "$nbum_app/update.md" | cut -d'=' -f2)
update_menu1="当前版本:${version}
正在检查更新..."
{
git fetch origin master > /dev/null 2>&1
if [ $? -ne 0 ]; then
    sleep 2
    dialog --title "错误: 1002" --msgbox "请检查网络和权限." 6 40
    exit 1
fi
git_version=$(curl -s "https://gitee.com/lingfengai/nbum/raw/master/update.md" | awk -F '"' '/version/ { print $2 }')
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/master)
} | dialog --infobox "${update_menu1}" 6 30
if [ "$LOCAL" != "$REMOTE" ]; then
    dialog --infobox "发现更新，正在校验版本号" 6 30
    git pull origin master > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        dialog --title "错误:1002" --msgbox "请检查网络和权限." 6 40
        clear
        exit 1
    fi
    sleep 1
    {
        for ((x=1; x<=10; x++))
        do
            let percent=(x*10)
            echo $percent
            sleep 0.01
        done
    } | dialog --gauge "发现更新，最新版本:$git_version" 6 30
    dialog --infobox "更新完成，即将重启脚本" 6 30
    sleep 1
    cd "${nbum_aop}"
    source nbum.sh
else
    dialog --infobox "没有发现更新" 6 30
    sleep 0.5
fi
}
trap 'ctrlc' SIGINT
ctrlc() {
    choice_ctrlc=$(dialog --clear --title "菜单" \
                    --menu "请选择一个选项："  0 0 4 \
                    "1" "继续运行" \
                    "2" "返回菜单" \
                    "3" "重载脚本" \
                    "4" "结束运行" \
                    2>&1 >/dev/tty)
    case $choice_ctrlc in
        1) $current ;;
        2) main_menu ;;
        3) cd "${nbum_app}";source nbum.sh ;;
        4) exit 0 ;;
        *) ctrlc ;;
    esac
}
main_menu() {
current="main_menu"
if [ "$(uname -o)" == "GNU/Linux" ]; then
    if [ -e "/etc/os-release" ]; then
        source /etc/os-release
        distro="$NAME$VERSION"
    else
        echo "错误：无法获取系统信息"
        clear
        exit 1
    fi
    main_choice=$(dialog --stdout --scrollbar \
    --title "NBUM-Tools $version running on $distro" \
    --menu "Welome to use NBUM工具箱，使用 nbum 来启动工具箱
    Please 选择一个选项后按下 enter" \
    20 80 12 \
    1 "🤖 QQ机器人:Yunzai部署与配置" \
    2 "💻 刷只因工具:包含ADB,ozip转zip…" \
    ? "🍏 该功能不适用此系统，已隐藏" \
    4 "🦁 Tmoe:宇宙无敌的容器管理器" \
    5 "👙 终端美化:oh-my-zsh" \
    6 "🌈 脚本选项:查看脚本选项" \
    0 "👋 退出:拜拜了您嘞" )
else
    main_choice=$(dialog --stdout --scrollbar \
    --title "NBUM-Tools $version running on $(uname -o)" \
    --menu "Welome to use NBUM工具箱，使用 nbum 来启动工具箱
    Please 选择一个选项后按下 enter" \
    20 80 12 \
    ? "🍎 QQ机器人不适用安卓" \
    2 "💻 刷只因工具:包含ADB,ozip转zip…" \
    3 "📱 安卓专用工具:安卓的实用工具" \
    4 "🦁 Tmoe:宇宙无敌的容器管理器" \
    5 "👙 终端美化:oh-my-zsh" \
    6 "🌈 setting:脚本设置" \
    0 "👋 退出:拜拜了您嘞" )
fi
if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
    exit
fi 
case $main_choice in 
    1) qq_menu ;;
    2) shuaji_menu ;;
    3) android_menu ;;
    4) . <(curl -L gitee.com/mo2/linux/raw/2/2)
       main_menu ;;
    5) . <(curl -L l.tmoe.me/ee/zsh)
       main_menu ;;
    6) setting_menu ;;
    0) exit 0 ;;
    ?) dialog --title "功能不适用" --msgbox '功能无法使用，详见脚本选项/疑难杂症' 10 40
       main_menu ;; 
    *) main_menu ;; 
   esac 
}
qq_menu() {
current="qq_menu"
qq_choice=$(dialog --stdout --scrollbar \
--title "Yunzai-Bot菜单" \
--menu "请选择一个选项:" \
0 0 12 \
1 "启动Yunzai" \
2 "安装Yunzai" \
3 "修复版本过低" \
4 "卸载Yunzai" \
0 "返回主菜单")
if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
    main_menu
fi 
case $qq_choice in 
    1) if [ -d "$nbum_home/Yunzai-Bot" ];then
        cd "$nbum_home/Yunzai-Bot"
        pnpm install -P
        node app
        qq_menu
       else
        dialog --title "error" --msgbox '没安装你让我怎么启动？' 10 40
        qq_menu
       fi ;;
     2) if command -v apt-get >/dev/null 2>&1; then
            apt install -y npm redis nodejs
        elif command -v pacman >/dev/null 2>&1; then
            pacman -Syu --noconfirm npm redis nodejs
        else
            dialog --msgbox '软件包错误' 10 40
            qq_menu
        fi
        cd "$nbum_home"
        git clone --depth=1 -b main https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git
        cd Yunzai-Bot
        npm install pnpm -g
        pnpm install -P
        qq_menu ;;
     3) if [ -d "$nbum_home/Yunzai-Bot" ];then
            cd "$nbum_home/Yunzai-Bot"
            git remote set-url origin https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git && git checkout . && git pull &&  git reset --hard origin/main  && pnpm install -P && npm run login
            qq_menu
        else
            dialog --title "error" --msgbox '没安装你让我怎么修复？' 10 40
            qq_menu
        fi ;;
     4) cd "$nbum_home";rm -rf Yunzai-Bot
        if command -v apt-get >/dev/null 2>&1; then
            apt remove -y npm redis nodejs;apt autoremove -y
        elif command -v pacman >/dev/null 2>&1; then
            pacman -Ryu --noconfirm npm redis nodejs
        else
            dialog --msgbox '软件包错误' 10 40
            qq_menu
        fi
        qq_menu ;;
     0) main_menu ;; 
     *) qq_menu ;; 
esac
}
shuaji_menu() {
current="shuaji_menu"
choice_shuaji=$(dialog --stdout --scrollbar --title "刷只因工具" \
--menu "请选择一个选项:" \
0 0 12 \
1 "ADB工具" \
2 "OZIP转成ZIP格式" \
0 "返回主菜单")
if [ -z "$choice_shuaji" ]; then
    main_menu
fi
case $choice_shuaji in
    1) if [ "$(uname -o)" == "GNU/Linux" ]; then
        if [ "$(command -v apt)" != "" ]; then
            $PM adb
        else
            dialog --backtitle "温馨提示" --title "注意" --msgbox '无法在安卓和Ubuntu除外的系统上安装adb' 10 40
            shuaji_nenu
        fi
       elif [ "$(uname -o)" == "Android" ]; then
        $PM android-tools
       else
        dialog --backtitle "温馨提示" --title "注意" --msgbox '无法在安卓和Ubuntu除外的系统上安装adb' 10 40
        shuaji_menu
       fi
       adbtools_menu
    ;;
    2) cd "$nbum_home"
       if [ -d "$nbum_home/oziptozip" ];then
        cd oziptozip
       else
        git clone https://github.com/liyw0205/oziptozip.git
        cd oziptozip
       fi
       python3 -m pip install --upgrade pip
       pip install -r requirements.txt
       shuaji_menu ;;
    0)  main_menu ;;
    *)  shuaji_menu ;;
esac
}
adbtools_menu() {
current="adbtools_menu"
adbtools_choice=$(dialog --stdout --scrollbar \
--title "ADB-Tools" \
--menu "请选择一个选项:" \
0 0 12 \
1 "连接手机" \
2 "检查设备连接" \
3 "修复(signal 9)" \
4 "卸载ADB" \
0 "返回主菜单")
if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
    shuaji_menu
fi 
case $adbtools_choice in 
    1)  ;;
    2) adbdevices=$(adb devices | grep -v "List of devices attached") 
       if [ -z "$adbdevices" ]; then
        adbdevicesphone="没有设备连接"
       else
        device_count=$(echo "$adbdevices" | wc -l)  # 统计设备数量
        adbdevicesphone="${device_count}个设备连接"
       fi
       dialog --title "$adbdevicesphone" --msgbox "$adbdevices" 15 40
       adbtools_menu ;;
    3) dialog --title "错误" --msgbox '用tmoe的不香吗，丨' 0 0
       adbtools_menu ;;
    4) if [ "$(uname -o)" == "GNU/Linux" ]; then
        apt remove -y adb
       elif [ "$(uname -o)" == "Android" ]; then
        apt remove -y android_tools
       fi
       shuaji_menu ;;
    0) shuaji_menu ;;
esac
}
android_menu() {
current="android_menu"
choice_android=$(dialog --stdout --scrollbar --title "Android工具" \
--menu "请选择一个选项:" \
20 80 12 \
1 "🍭 一键美化:让你的终端变得更漂亮" \
2 "💽 软件包换源:清华源" \
0 "返回主菜单")
if [ -z "$choice_android" ]; then
    main_menu
fi
case $choice_android in
    1) cd $home
       git clone https://github.com/remo7777/T-Header.git
       cd T-Header
       bash t-header.sh
       main_menu ;;
    2) sed -i 's@^\(deb.*stable main\)$@#\1\ndeb https://mirrors.tuna.tsinghua.edu.cn/termux/termux-packages-24 stable main@' $PREFIX/etc/apt/sources.list && apt update && apt upgrade
       android_menu ;;
    0) main_menu ;;
    *) android_menu ;;
esac
}
setting_menu() {
current="setting_menu"
setting_choice=$(dialog --stdout --scrollbar \
--title "setting" \
--menu "请选择一个选项:" \
0 0 12 \
" " "-🍓设置相关-" \
1 "🍧 *°▽°*update" \
2 "☂️ 切换仓库源" \
3 "🚧 启动设置" \
" " "-🚥脚本相关-" \
4 "⚡ 前往gitee" \
5 "💾 更新日志" \
6 "🤔 疑难杂症" \
7 "💻 密钥功能" \
0 "🔙 返回主菜单")
if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
    main_menu 
fi
case $setting_choice in 
    1) nbum_update;setting_menu ;;
    2) setting_git_menu ;;
    4) case $(uname -o) in
        Android) am start -a android.intent.action.VIEW -d "${nbum_gitee}" ;;
       esac
       dialog --msgbox 'https://gitee.com/lingfengai/nbum' 10 50
       setting_menu ;;
    5) setting_change_menu ;;
    6) main_menu ;;
    7) setting_key_check_menu ;;
    0) main_menu ;; 
    *) setting_menu ;; 
esac
}
setting_change_menu() {
current="setting_change_menu"
changelog=$(cat "$nbum_app/update.md")
dialog --no-collapse --title "更新日志" --msgbox "$changelog" 25 80
setting_menu
}
setting_git_menu() {
cd "$nbum_app"
remote_url=$(git remote get-url origin)
if [[ ${remote_url} == *"gitee"* ]]; then
    dialog --title "当前仓库源为Gitee" --yesno "你是否要切换仓库源为Github？" 7 40
    setting_git_choice=$?
    if [ ${setting_git_choice} -eq 0 ]; then
        git remote set-url origin https://github.com/lingfengai2/nbum.git
    fi
elif [[ ${remote_url} == *"github"* ]]; then
    dialog --title "当前仓库源为Github" --yesno "你是否要切换仓库源为Gitee？" 7 40
    setting_git_choice=$?
    if [ ${setting_git_choice} -eq 0 ]; then
       git remote set-url origin https://gitee.com/lingfengai2/nbum.git
    fi
else
    dialog --title '错误' --msgbox '无法获取仓库源' 5 20
fi
setting_menu
}
setting_key_check_menu() {
encoded_key=$(dialog --stdout --inputbox "请输入密钥:" 0 0)
if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
    setting_menu
fi
decoded_key=$(echo -n "$encoded_key" | base64 -d)
key_regex="^[A-Z]{4}[0-9]{8}$"
if [[ $decoded_key =~ $key_regex ]]; then
    letters=${decoded_key:0:4}
    key_date=${decoded_key:4}
    current_date=$(date +"%Y%m%d")
    if [[ $date -gt $current_date ]]; then
        dialog --msgbox "密钥错误" 6 30
        setting_menu
    else
        key_value=$(grep "^key=" "$nbum_setting" | cut -d'=' -f2)
        if [ -n "$key_value" ]; then
            sed -i 's/^key=.*/key='"$encoded_key"'/' "$nbum_setting"
        else
            sed -i 's/^key=.*/key='"$key_value$encoded_key"'/' "$nbum_setting"
        fi
        if [[ $? -eq 0 ]]; then
            dialog --msgbox "校验成功:${key_date}" 6 30
            setting_menu
        else
            dialog --title "错误:1003" --msgbox "校验成功，但是密钥写入失败" 6 40
            setting_menu
        fi
    fi
else
    dialog --msgbox "密钥错误" 6 30
    setting_menu
fi
}
nbum_loading
source 2.sh
nbum_update
main_menu