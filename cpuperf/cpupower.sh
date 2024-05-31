#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y linux-tools-common   linux-tools-$(uname -r)

echo passive > /sys/devices/system/cpu/intel_pstate/status

echo '[Unit]
Description=CPU powersave
[Service]
User=root
Group=root
Type=oneshot
ExecStart=/usr/bin/cpupower frequency-set -g performance
ExecStart=/usr/bin/cpupower idle-set -D 11
[Install]
WantedBy=multi-user.target' >/lib/systemd/system/cpupower.service

sudo systemctl daemon-reload
sudo systemctl enable cpupower.service
sudo systemctl disable ondemand
sudo systemctl start cpupower.service


sudo  grep -E "^model name|^cpu MHz" /proc/cpuinfo
