#!/bin/bash
#功能：配置ssh端口,禁止root用户登录
#作者：烟雨江南
#联系：calfkuang@163.com

#配置基础变量
CONFIG="/etc/ssh/sshd_config"

#修改配置文件
cat >>${CONFIG} <<-EOF
#配置端口,禁止root登录
Port 20202
PermitRootLogin no
EOF

#重启
reboot
