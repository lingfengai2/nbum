#!/bin/bash
cd $home
cd nbum
# 检查系统是否已安装依赖
if ! command -v dialog > /dev/null || ! command -v python3 > /dev/null || ! command -v git > /dev/null || ! command -v which > /dev/null; then
./install.sh
fi
if [ $? -eq 6 ]; then
    exit 1
fi
# 先进入到代码仓库的目录
cd $home;cd nbum
version=$(grep -Eo 'version="[0-9.]+"' update.md | cut -d'"' -f2)
{
# 检查是否有新的更新
for((x=1; x<=10; x++))
  do
    let percent=(x*5)
    echo $percent
    sleep 0.1
  done
git fetch -q origin master
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/master)
} | dialog --gauge "检查版本更新，当前版本: $version" 10 36
# 如果有新的更新，则拉取最新的代码并重新加载代码
if [ "$LOCAL" != "$REMOTE" ]; then
{
    # 从 Gitee 仓库获取版本号
    git_version=$(curl -s "https://gitee.com/lingfengai/nbum/raw/master/update.md" | awk -F '"' '/version/ { print $2 }')
    # 拉取最新的代码
    git pull origin master
    # 重新加载代码
    for((x=1; x<=10; x++))
    do
      let percent=(x*5)+50
      echo $percent
      sleep 0.1
    done
} | dialog --gauge "发现更新: $git_version" 10 36
    echo 100 | dialog --gauge "更新完成，即将重新加载脚本" 10 36
    sleep 1
    source nbum.sh
else
{
    for((x=1; x<=10; x++))
    do
      let percent=(x*5)+50
      echo $percent
      sleep 0.05
    done
} | dialog --gauge "已是最新版本" 10 36
fi

# 定义一个函数，用于显示菜单选项，并根据用户选择执行相应操作或退出程序
function show_menu() {
  # 使用dialog的menu选项，显示菜单项，并返回用户选择的标签到变量choice中
if [ "$(uname -o)" == "GNU/Linux" ]; then
    if [ -e "/etc/os-release" ]; then
        source /etc/os-release
        distro="$NAME$VERSION"
    else
        echo "释放脚本时出现错误（无法获取系统信息）"
        exit 1
    fi
    choice=$(dialog --stdout --scrollbar \
        --title "NBUM-Tools $version running on $distro" \
        --menu "Welome to use NBUM工具箱，使用 nbum 来启动工具箱
Please 选择一个选项后按下 enter" \
        20 80 12 \
        1 "🤖 QQ机器人:Yunzai部署与配置" \
        2 "💻 刷只因工具:包含ADB,ozip转zip…" \
        4 "🌈 脚本选项:查看脚本选项" \
        0 "👋 退出:拜拜了您嘞" )
else
    choice=$(dialog --stdout --scrollbar \
        --title "NBUM-Tools $version running on $(uname -o)" \
        --menu "Welome to use NBUM工具箱，使用 nbum 来启动工具箱
Please 选择一个选项后按下 enter" \
        20 80 12 \
        2 "💻 刷只因工具:包含ADB,ozip转zip…" \
        3 "📱 安卓专用工具:Termux,MT的实用工具" \
        4 "🌈 脚本选项:查看脚本选项" \
        0 "👋 退出:拜拜了您嘞" )
fi
   # 如果用户按下ESC或取消按钮，则退出程序 
   if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
     exit
   fi 
   # 根据choice变量的值，调用不同的函数或重新显示菜单 
   case $choice in 
     4) show_more_menu ;;
     2) show_shuaji ;;
     1) show_qq ;;
     0) exit ;; 
     3) show_android ;; 
     *) show_menu ;; 
   esac 
}
# 定义一个函数，用于显示菜单
function show_android() {
     choice_android=$(dialog --stdout --scrollbar --title "Android工具" \
     --menu "请选择一个选项:" \
     20 80 12 \
     1 "🍭 一键美化:让你的终端变得更漂亮" \
     2 "选项2" \
     3 "选项3" \
     0 "返回主菜单")
    if [ -z "$choice_android" ]; then
      show_menu
    fi
    case $choice_android in
      1) cd $home
         git clone https://github.com/remo7777/T-Header.git
         cd T-Header
         bash t-header.sh
         show_menu ;;
      2)  ;;
      3)  ;;
      0) show_menu ;;
      *) show_android ;;
    esac
}
# 定义一个函数，用于显示设备信息和联系方式，并让用户按任意键返回到菜单界面  
function show_info() {
# 使用echo命令输出手机信息
device="$(neofetch --stdout | sed 's/$$/\r/' | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g' | sed 's/\\n/\n/g')"
nembers="
作者：凌风哎
QQ：3405303811
WeChat：不告诉你"
dialog --title "脚本信息" --msgbox "$device""$nembers" 0 0
show_more_menu
}
# 定义一个函数，用于显示更多菜单选项，并根据用户选择执行相应操作或返回到上一级菜单界面  
function show_more_menu() {  
   # 使用dialog的menu选项，显示两个更多菜单项，并返回用户选择的标签到变量more_choice中  
   more_choice=$(dialog --stdout --scrollbar \
    --title "菜单" \
    --menu "请选择一个选项:" \
    20 80 12 \
    1 "ℹ️ 脚本信息:毫无意义的功能" \
    2 "💾 更新日志:更新了个寂寞🌚" \
    3 "🤔 疑难杂症:不懂就看看" \
    4 "🍧 *°▽°*update更新" \
    0 "🔙 返回:滚回主菜单")
   # 如果用户按下ESC或取消按钮，则返回到上一级菜单界面 
   if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
      show_menu 
   fi 
   # 根据more_choice变量的值，调用不同的函数或重新显示更多菜单 
   case $more_choice in 
     1) show_info ;; 
     2) show_change ;; 
     3) show_yinan ;;
     4) cd $home;cd nbum;git pull origin master;echo "完成，更新将在下一次启动脚本后生效（等待5秒）";sleep 5;show_more_menu ;;
     0) show_menu ;; 
     *) show_more_menu ;; 
   esac
}
# 定义一个函数，用于显示更新日志
function show_change() {
cd $home;cd nbum
changelog=$(cat update.md)
# 在对话框更新日志
dialog --no-collapse --backtitle "更新日志" --title "计算器更新日志" --msgbox "$changelog" 25 80
show_more_menu
}
# 定义一个函数，用于显示菜单
function show_shuaji() {
     choice_shuaji=$(dialog --stdout --scrollbar --title "刷只因工具" \
     --menu "请选择一个选项:" \
     20 80 12 \
     1 "ADB工具（不包含fastboot）" \
     2 "OZIP转成ZIP格式" \
     3 "选项3" \
     0 "返回主菜单")
    if [ -z "$choice_shuaji" ]; then
      show_menu
    fi
    case $choice_shuaji in
      1)   # 检查设备类型
         if [ "$(uname -o)" == "GNU/Linux" ]; then
         # 获取ADB路径
         adb_path=$(command -v adb)

         # 检查ADB是否已经安装
             if [ -z "${adb_path}" ]; then
         # 安装ADB
               if [ "$(command -v apt)" != "" ]; then
               apt install adb
               else
               dialog --backtitle "温馨提示" --title "注意" --msgbox '无法在安卓和Ubuntu除外的系统上安装adb' 10 40
               show_shuaji
               fi
              fi
         elif [ "$(uname -o)" == "Android" ]; then
         # 获取Android Tools路径
         android_tools_path=$(command -v adb)
         # 检查安卓工具是否已经安装
                   if [ -z "${android_tools_path}" ]; then
                   # 安装Android Tools
                   apt install android-tools
                   fi
         else
           dialog --backtitle "温馨提示" --title "注意" --msgbox '无法在安卓和Ubuntu除外的系统上安装adb' 10 40
           show_shuaji
         fi
while true; do
  # 显示输入框让用户输入要执行的adb命令
  adb_chiose=$(dialog --inputbox "请输入要执行的adb命令（不需要加adb；例如：devices）：" 10 50 3>&1 1>&2 2>&3)

  # 如果用户取消了输入，则退出循环
  if [ $? -ne 0 ]; then
    show_shuaji
    break
  fi
  
  # 使用adb执行用户输入的命令
  adb $adb_chiose
  # 提示用户按回车键继续输入命令
  read -n 1 -s -r -p "按任意键继续..."
done
show_shuaji
 ;;
      2) cd $home
        if [ -d "$HOME/oziptozip" ]
        then
         cd oziptozip
        else
         git clone https://github.com/liyw0205/oziptozip.git
         cd oziptozip
        fi
        python3 -m pip install --upgrade pip
        pip install -r requirements.txt
        show_shuaji ;;
      3)  ;;
      0)  show_menu ;;
      *)  show_shuaji ;;
    esac
}
function show_qq() {
# 使用dialog的menu选项，显示两个更多菜单项，并返回用户选择的标签到变量qq_choice中  
   qq_choice=$(dialog --stdout --scrollbar \
    --title "菜单" \
    --menu "请选择一个选项:" \
    0 0 12 \
    1 "启动Yunzai" \
    2 "安装Yunzai" \
    3 "修复版本过低" \
    4 "卸载Yunzai" \
    0 "返回主菜单")
   # 如果用户按下ESC或取消按钮，则返回到上一级菜单界面 
   if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
      show_menu 
   fi 
   # 根据more_choice变量的值，调用不同的函数或重新显示更多菜单 
   case $qq_choice in 
     1) cd $home
     if [ -d "$HOME/Yunzai-Bot" ]
     then
      cd Yunzai-Bot
      pnpm install -P
      node app
      show_qq
     else
      dialog --backtitle "不是你什么意思" --title "error" --msgbox '没安装你让我怎么启动？' 10 40
      show_qq
     fi
     ;;
     2)  # 检查包管理器并设置对应变量
        if [ "$(uname -o)" == "GNU/Linux" ]; then
           if command -v apt-get >/dev/null 2>&1; then
            apt install -y npm redis
           elif command -v pacman >/dev/null 2>&1; then
            pacman -Syu --noconfirm npm redis
           else
            echo "未知的 Linux 发行版或包管理器"
            show_qq
           fi
        fi 
        cd $home
        git clone --depth=1 -b main https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git
        cd Yunzai-Bot
        npm install pnpm -g
        pnpm install -P
        sleep 2.5
        dialog --backtitle "安装完成" --title "确认" \
       --yesno "是否需要运行它？" 10 30 \
       status=$?
      # 根据用户的选择执行不同的操作
      if [ $status -eq 0 ]; then
       node app
       sleep 1
       show_qq
      else
       show_qq
      fi ;; 
     3) cd $home;cd Yunzai-Bot
     git remote set-url origin https://gitee.com/yoimiya-kokomi/Yunzai-Bot.git && git checkout . && git pull &&  git reset --hard origin/main  && pnpm install -P && npm run login ;;
     4) cd $home;rm -rf Yunzai-Bot ;;
     0) show_menu ;; 
     *) show_qq ;; 
   esac
}
function show_yinan() {
yinan="
1️⃣QAQ  为什么主菜单少了一些选项
because：
一些功能是针对不同系统制作的，
其他系统无法使用
所以进行了隐藏"
dialog --no-collapse --backtitle "小朋友你是否有很多问号" --title "疑难杂症大全" --msgbox "$yinan" 25 80
show_more_menu
}
show_menu
exit 0