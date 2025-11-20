#!/bin/bash
set -e

# 设置语言环境
export LANG=en_US.UTF-8

# 导入可选环境变量（可通过docker run -e传入）
export uuid=${uuid:-}
export vlpt=${vlpt:-}
export vmpt=${vmpt:-}
export hypt=${hypt:-}
export tupt=${tupt:-}
export xhpt=${xhpt:-}
export vxpt=${vxpt:-}
export anpt=${anpt:-}
export arpt=${arpt:-}
export sspt=${sspt:-}
export sopt=${sopt:-}
export reym=${reym:-}
export cdnym=${cdnym:-}
export argo=${argo:-}
export agn=${agn:-}
export agk=${agk:-}
export ippz=${ippz:-}
export warp=${warp:-}
export name=${name:-}

v46url="https://icanhazip.com"

# 创建工作目录
mkdir -p /root/agsbx

showmode(){
    echo "Argosbx Docker 持续运行版"
    echo "项目地址：https://github.com/yonggekkk/argosbx"
    echo "---------------------------------------------------------"
}

v4v6(){
    v4=$( (command -v curl >/dev/null 2>&1 && curl -s4m5 -k "$v46url") || (command -v wget >/dev/null 2>&1 && wget -4 -qO- "$v46url") )
    v6=$( (command -v curl >/dev/null 2>&1 && curl -s6m5 -k "$v46url") || (command -v wget >/dev/null 2>&1 && wget -6 -qO- "$v46url") )
}

# 安装 Xray/Sing-box 的核心方法
installxray(){
    mkdir -p /root/agsbx/xrk
    if [ ! -f /root/agsbx/xray ]; then
        cpu=$(uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/')
        url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/xray-$cpu"
        curl -Lo /root/agsbx/xray "$url"
        chmod +x /root/agsbx/xray
    fi
}

installsb(){
    if [ ! -f /root/agsbx/sing-box ]; then
        cpu=$(uname -m | sed 's/aarch64/arm64/;s/x86_64/amd64/')
        url="https://github.com/yonggekkk/argosbx/releases/download/argosbx/sing-box-$cpu"
        curl -Lo /root/agsbx/sing-box "$url"
        chmod +x /root/agsbx/sing-box
    fi
}

# 启动服务（Docker 里不使用 systemd，直接 nohup）
start_services(){
    if [ -f /root/agsbx/xr.json ]; then
        nohup /root/agsbx/xray run -c /root/agsbx/xr.json >/root/agsbx/xray.log 2>&1 &
    fi
    if [ -f /root/agsbx/sb.json ]; then
        nohup /root/agsbx/sing-box run -c /root/agsbx/sb.json >/root/agsbx/sing-box.log 2>&1 &
    fi
    # Argo
    if [ -n "$argo" ]; then
        nohup /root/agsbx/cloudflared tunnel --url http://localhost:"${vmpt}" --edge-ip-version auto --no-autoupdate --protocol http2 >/root/agsbx/argo.log 2>&1 &
    fi
}

# 防止容器退出，保持前台
keep_alive(){
    echo "Argosbx Docker 容器启动完成，保持前台运行..."
    tail -f /dev/null
}

# 主函数
main(){
    showmode
    installxray
    installsb
    start_services
    keep_alive
}

main
