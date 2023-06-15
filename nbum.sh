#!/bin/bash
# 进入 nbum 目录并检查是否有更新
cd $home
cd nbum
if ! command -v dialog > /dev/null || ! command -v catimg > /dev/null || ! command -v git > /dev/null; then
./install.sh
fi
# 更新
git pull origin master
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
     脚本选项) show_more_menu ;;
     获取天气🖼) curl "wttr.in?lang=zh"|lolcat;echo [按回车返回];read -sn1;show_menu ;;
     刷只因工具⌨️) show_shuaji ;;
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
     4 "返回主菜单")
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
# 定义一个函数，用于显示菜单
function show_shuaji() {
     choice_shuaji=$(dialog --stdout --scrollbar --title "刷只因工具" \
     --menu "请选择一个选项:" \
     20 80 12 \
     1 "ADB工具（不包含fastboot）" \
     2 "选项2" \
     3 "选项3" \
     4 "返回主菜单")
    if [ -z "$choice_shuaji" ]; then
      show_menu
    fi
    case $choice_shuaji in
      1) dialog --backtitle "提示" --title "提示" \
       --yesno "该功能目前只支持Ubuntu和termux" 10 30
      # 将dialog命令的退出状态保存到变量`status`中
      status=$?
      # 根据用户的选择执行不同的操作
      if [ $status -eq 0 ]; then
              # 检查设备类型
         if [ "$(uname -o)" == "GNU/Linux" ]; then
         # 获取ADB路径
         adb_path=$(command -v adb)

         # 检查ADB是否已经安装
             if [ -z "${adb_path}" ]; then
             echo "ADB未安装，正在安装..."
         # 安装ADB
               if [ "$(command -v apt)" != "" ]; then
               apt install adb
               else
               echo "无法安装ADB，请安装"
                fi
              fi
         elif [ "$(uname -o)" == "Android" ]; then
         # 获取Android Tools路径
         android_tools_path=$(command -v adb)

         # 检查安卓工具是否已经安装
                   if [ -z "${android_tools_path}" ]; then
                   echo "Android Tools未安装，正在安装..."
                   # 安装Android Tools
                   apt install android-tools
                   fi
         else
         echo "未知设备类型"
         fi
while true; do
  # 显示输入框让用户输入要执行的adb命令
  adb_chiose=$(dialog --inputbox "请输入要执行的adb命令（不需要加adb）：" 10 50 3>&1 1>&2 2>&3)

  # 如果用户取消了输入，则退出循环
  if [ $? -ne 0 ]; then
    show_shuaji
    break
  fi
  
  # 使用adb执行用户输入的命令
  adb $adb_chiose
  # 提示用户按回车键继续输入命令
  read -n 1 -s -r -p "按任意键继续..."
  printf "\n"
done
      else
        show_shuaji
      fi
 ;;
      2)  ;;
      3)  ;;
      4)  ;;
      *)  ;;
    esac
}
show_menu
exit 0