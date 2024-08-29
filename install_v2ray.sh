#!/bin/bash
#功能：自动安装v2ray服务端
#      使用前先修改CLIENTS_ID值,示例：76555b48-78u6-660f-823f-f1433eff676e
#作者：况腾飞
#联系：calfkuang@163.com

#配置基本变量
PORT="443"
CLIENTS_ID="76555b48-78u6-660f-823f-f1433eff676e"
PROTOCOL="vmess"
V2RAY_CONFIG="/usr/local/etc/v2ray/config.json"
TMP_FILE="/tmp/v2ray_install_result.txt"

#安装v2ray服务端
/bin/bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

#修改配置文件
cat >${V2RAY_CONFIG} <<-EOF
{
	"inbounds": [{
		"port": "${PORT}",
		"listen": "0.0.0.0",
		"tag": "socks-inbound",
		"protocol": "${PROTOCOL}",
		"settings": {
			"clients": [{
				"id": "${CLIENTS_ID}"
			}]
		}
	}],
	"outbounds": [{
		"protocol": "freedom",
		"settings": {},
		"tag": "direct"
	}, {
		"protocol": "blackhole",
		"settings": {},
		"tag": "blocked"
	}]
}
EOF

#启动v2ray服务端
systemctl enable v2ray; 
systemctl start v2ray; 
systemctl status v2ray >${TMP_FILE}

#信息格式化
run_status=$(cat ${TMP_FILE} | grep "Active:" | cut -d ' ' -f5-6)
rm -f ${TMP_FILE}

#打印安装信息
echo -e "\e[31m---------------------V2RAY安装信息------------------------\e[0m"
printf "\e[31m服务端口：\e[32m${PORT}\n"
printf "\e[31m配置文件：\e[32m${V2RAY_CONFIG}\n"
printf "\e[31m运行状态：\e[32m${run_status}\n"
echo -e "\e[31m----------------------------------------------------------\e[0m"