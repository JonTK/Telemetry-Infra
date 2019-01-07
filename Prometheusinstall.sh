#!/bin/bash
# Installation of Prometheus  - REFERENCE ONLY - not for production 

sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus
sudo mkdir /var/lib/prometheus
for i in rules rules.d files_sd; do sudo mkdir -p /etc/prometheus/${i}; done
sudo yum -y install wget
cd /tmp
export RELEASE=2.4.2
wget https://github.com/prometheus/prometheus/releases/download/v${RELEASE}/prometheus-${RELEASE}.linux-amd64.tar.gz
tar xvf prometheus-${RELEASE}.linux-amd64.tar.gz
cd prometheus-${RELEASE}.linux-amd64/
sudo cp prometheus promtool /usr/local/bin/
sudo cp -r consoles/ console_libraries/ /etc/prometheus/
cd /etc/prometheus/
wget https://github.com/JoshHilliker/Telemetry-Infra/blob/master/prometheus.yml
cd /etc/systemd/system/
wget https://github.com/JoshHilliker/Telemetry-Infra/blob/master/prometheus.service
rm -rf prometheus-${RELEASE}.linux-amd64.tar.gz
rm -rf prometheus-${RELEASE}.linux-amd64/
for i in rules rules.d files_sd; do sudo chown -R prometheus:prometheus /etc/prometheus/${i}; done
for i in rules rules.d files_sd; do sudo chmod -R 775 /etc/prometheus/${i}; done
sudo chown -R prometheus:prometheus /var/lib/prometheus/
sudo systemctl daemon-reload
sudo systemctl start prometheus