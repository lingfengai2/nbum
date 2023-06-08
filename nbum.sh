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
    y
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
# 找到本地 Git 仓库的目录（如果存在）
cd
REPO_DIR=$(find . -type d -name "nb-menu" -print -quit)
if [[ -z "$REPO_DIR" ]]; then
    echo "错误：未发现脚本目录，部分功能可能不生效"
fi
# 进入 nb-menu 目录并检查是否有更新
cd "$REPO_DIR"
# 检查远程仓库的更新
git fetch origin
# 检查本地仓库和远程仓库之间的差异
if [[ $(git rev-parse HEAD) != $(git rev-parse @{u}) ]]; then
    # 拉取远程仓库并合并更新到本地仓库
    echo "检测到新的仓库版本，正在更新中"
    git pull origin
    echo "代码已更新到最新版本！"
    exec
    exec ./nb-menu.sh
else
    echo -e "欢迎使用-v1.53\fnb's工具箱"
fi
trap ctrl_c INT
function ctrl_c() {
 # 显示一个带有“退出”和“不要”按钮的消息框，提示用户是否要退出
dialog --backtitle "退出菜单" --title "确认退出" \
       --yesno "确定要退出吗？" 10 30 \
# 获取用户的选择，保存在 $$status 变量中
# 如果用户按下 “退出” 按钮（也就是 Yes 按钮），$status 的值为 0
# 如果用户按下 “不要” 按钮（也就是 No 按钮），$status 的值为 1
status=$?
# 根据用户的选择执行不同的操作
if [ $status -eq 0 ]; then
    # 如果用户按下 Yes 按钮，使用 exit 命令退出脚本
    exit
else
    # 如果用户按下 No 按钮，提示用户返回菜单
    show_menu
fi
}
sleep 0.5
{
     for((x=1;x<=10;x++))
     do
        let X=10*x
        echo $X
        sleep 0.1
     done
} | dialog --gauge "正在释放脚本" 10 36
# 定义一个函数，用于显示菜单选项，并根据用户选择执行相应操作或退出程序
function show_menu() {
  # 使用dialog的menu选项，显示三个菜单项，并返回用户选择的标签到变量choice中
  choice=$(dialog --stdout --scrollbar \
    --title "菜单" \
    --menu "请选择一个选项:" \
    20 80 12 \
    日历📆 "已停用" \
    获取天气🖼 "今天天气怎么样？" \
    刷只因工具⌨️ "包含ADB,ozip转zip…" \
    计算器📟 "妈妈再也不用担心我学习了" \
    脚本选项 "查看脚本选项" \
    安卓📱专用工具 "Termux,MT的实用工具" \
    退出👋 "退了就别滚回来了" )
   # 如果用户按下ESC或取消按钮，则退出程序 
   if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
     ctrl_c
   fi 
   # 根据choice变量的值，调用不同的函数或重新显示菜单 
   case $choice in 
     日历📆) show_calendar ;; 
     脚本选项) show_more_menu ;;
     获取天气🖼) curl "wttr.in?lang=zh"|lolcat;echo [按回车返回];read -sn1;show_menu ;;
     刷只因工具⌨️) ;;
     计算器📟) jiajian;;
     退出👋) ctrl_c ;; 
     安卓📱专用工具) show_android ;; 
     *) show_menu ;; 
   esac 
}
# 定义一个函数，用于显示菜单
function show_android() {
     choice_android=$(dialog --stdout --scrollbar --title "Android工具" \
     --menu "请选择一个选项:" \
     20 80 12 \
     1 "一键美化" \
     2 "选项2" \
     3 "选项3" \
     4 "取消")
    if [ -z "$choice_android" ]; then
      show_menu
    fi
    case $choice_android in
      1) cd
         git clone https://github.com/remo7777/T-Header.git
         cd T-Header ;;
      2)  ;;
      3)  ;;
      4) show_menu ;;
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
function jiajian() {
  while true; do
    op=$(dialog \
      --clear \
      --stdout \
      --title "计算器" \
      --menu "请选择运算类型:" \
      0 0 0 \
      "1" "加法" \
      "2" "减法" \
      "3" "乘法" \
      "4" "除法" \
      "5"  "返回主菜单") 
# 如果用户选择 "取消" 或关闭了对话框，退出脚本
  if [ -z "$op" ]; then
  show_menu
  fi
    case $op in
      "1")
        do_addition
        ;;
      "2")
        do_subtraction
        ;;
      "3")
        do_multiplication
        ;;
      "4")
        do_division
        ;;
      "5")
        show_menu
        ;;
      *)
        dialog --title "无效的选项" --msgbox "请选择一个有效的选项" 0 0
        ;;
    esac
  done
}
# 加法
do_addition() {
  num1=$(dialog --stdout --title "加法" --inputbox "请输入第一个数:" 0 0)
  num2=$(dialog --stdout --title "加法" --inputbox "请输入第二个数:" 0 0)
  result=$(echo "$num1 + $num2" | bc)
  dialog --title "计算结果" --msgbox "加法：$num1 + $num2 = $result" 0 0
}
# 减法
do_subtraction() {
  num1=$(dialog --stdout --title "减法" --inputbox "请输入第一个数:" 0 0)
  num2=$(dialog --stdout --title "减法" --inputbox "请输入第二个数:" 0 0)
  result=$(echo "$num1 - $num2" | bc)
  dialog --title "计算结果" --msgbox "减法：$num1 - $num2 = $result" 0 0
}
# 乘法
do_multiplication() {
  num1=$(dialog --stdout --title "乘法" --inputbox "请输入第一个数:" 0 0)
  num2=$(dialog --stdout --title "乘法" --inputbox "请输入第二个数:" 0 0)
  result=$(echo "$num1 * $num2" | bc)
  dialog --title "计算结果" --msgbox "乘法：$num1 * $num2 = $result" 0 0
}
# 除法
do_division() {
  num1=$(dialog --stdout --title "除法" --inputbox "请输入第一个数:" 0 0)
  num2=$(dialog --stdout --title "除法" --inputbox "请输入第二个数:" 0 0)
  result=$(echo "$num1 / $num2" | bc)
  dialog --title "计算结果" --msgbox "除法：$num1 / $num2 = $result" 0 0
}
# 定义一个函数，用于显示更多菜单选项，并根据用户选择执行相应操作或返回到上一级菜单界面  
function show_more_menu() {  
   # 使用dialog的menu选项，显示两个更多菜单项，并返回用户选择的标签到变量more_choice中  
   more_choice=$(dialog --stdout --scrollbar \
    --title "菜单" \
    --menu "请选择一个选项:" \
    20 80 12 \
    脚本信息 "作者，系统等" \
    更新日志 "历代版本详情" \
    返回 "顾名思义")
   # 如果用户按下ESC或取消按钮，则返回到上一级菜单界面 
   if [ $? -eq 1 ] || [ $? -eq 255 ]; then 
      show_menu 
   fi 
   # 根据more_choice变量的值，调用不同的函数或重新显示更多菜单 
   case $more_choice in 
     脚本信息) show_info ;; 
     更新日志) show_change ;; 
     返回) show_menu ;; 
     *) show_more_menu ;; 
   esac
}
# 定义一个函数，用于显示当前时间，并让用户按任意键返回到更多菜单界面
function show_change() {
# 设置颜色化的更新日志
changelog="
版本 1.0.0 (2023年4月23日)
- 正式开始编写图形化菜单
- newbing完成主菜单的自适应屏幕的方法
- 脚本改名为牛逼的工具箱图形版（nb-menu）
- 完善初始功能
  -日历
  -天气

版本 1.1.0 (2023年4月24日)
- 加入计算器
  - 加法运算
  - 减法运算
  - 乘法运算
  - 除法运算
- 进一步完善功能
- 加入退出确认菜单

版本 1.2.0 (2022年11月1日)
- 修复天气无法正常输出的问题
- 现在会检查是否安装了依赖并让用户选择安装方式
- chatgpt完成新的主菜单适应屏幕方式
  - 不再像newbing直接把菜单拉满屏幕

版本 1.3.0 (2022年11月15日)
- 新增脚本信息以及更新日志（你现在看的）
- 新增自动检查脚本更新并自动更新的功能（亿点bug）
- 优化了代码，以提高效率

版本 2.0.0 (2023年1月1日)
- 添加了新功能，如计算器历史、复制粘贴等
- 完全改进了用户界面
- 修复了若干错误
"
# 在对话框更新日志
dialog --no-collapse --backtitle "更新日志" --title "计算器更新日志" --msgbox "$changelog" 25 80
show_more_menu
}
show_menu
exit 0