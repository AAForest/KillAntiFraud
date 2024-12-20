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

# 确定模块路径
if [ -z "$MODPATH" ]; then
    MODPATH="/data/adb/modules/$(basename $0)"
    echo "- 使用默认模块路径: $MODPATH"
fi

HOSTS_PATH="/system/etc/hosts"
MODULE_HOSTS="$MODPATH/hosts"

# 替换 hosts 文件
if [ -f "$MODULE_HOSTS" ]; then
    echo "- 正在替换 hosts 文件..."
    mkdir -p "$(dirname "$MODPATH$HOSTS_PATH")"
    mv -f "$MODULE_HOSTS" "$MODPATH$HOSTS_PATH"
    echo "- hosts 文件已成功替换！"
else
    echo "- 未找到 hosts 文件：$MODULE_HOSTS"
fi

# 安装 APK 文件
APK_DIR="$MODPATH/apk"
if [ -d "$APK_DIR" ]; then
    for apk in "$APK_DIR"/*.apk; do
        if [ -f "$apk" ]; then
            echo "- 正在安装 APK 文件：$(basename "$apk")"
            pm install -r "$apk" > /dev/null 2>&1
            if [ $? -eq 0 ]; then
                echo "- APK $(basename "$apk") 安装成功！"
            else
                echo "- APK $(basename "$apk") 安装失败，请检查日志！"
            fi
        fi
    done
    # 清理 APK 目录
    rm -rf "$APK_DIR"
    echo "- APK 目录已清理！"
else
    echo "- 未找到 APK 目录：$APK_DIR"
fi

# 清理临时文件
LICENSE_FILE="$MODPATH/LICENSE"
if [ -f "$LICENSE_FILE" ]; then
    rm -f "$LICENSE_FILE"
    echo "- LICENSE 文件已清理！"
fi
echo "- 操作完成！"