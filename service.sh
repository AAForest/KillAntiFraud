#!/system/bin/sh

describe() {
    MODDIR="${0%/*}"
    state=""


    MODULE_HOSTS="$MODDIR/system/etc/hosts"
    SYSTEM_HOSTS="/etc/hosts"

    if [ ! -f "$MODULE_HOSTS" ]; then
        state="⭕ Hosts 文件缺失，请尝试二次安装！"
    elif cmp -s "$MODULE_HOSTS" "$SYSTEM_HOSTS"; then
        state="✅ Hosts 挂载成功，模块正常运行！"
    else
        state="⭕ Hosts 挂载失败，模块未生效！"
    fi

    if sed -i "s/^description=.*/description=$state/" "$MODDIR/module.prop"; then
        echo "✅ 成功更新 module.prop 文件。"
    else
        echo "❌ 更新 module.prop 文件时出错！"
    fi
}

count=0
limit=30

while [ $count -lt $limit ]; do
    locked="$(dumpsys window policy | grep 'mInputRestricted' | cut -d= -f2)"

    if [[ "$locked" == "false" ]] || [[ $count -eq $((limit - 1)) ]]; then
        sleep 5
        describe
        break
    fi

    count=$((count + 1))
    sleep 2
done

MODDIR="${0%/*}"
mount -t overlay -o lowerdir=/system/etc,upperdir=$MODDIR/system/etc,workdir=$MODDIR/worker /system/etc