#!/bin/bash
echo "=== УСТАНОВКА ELK КОНФИГОВ ==="

# Останавливаем сервисы
echo "Останавливаем сервисы..."
sudo systemctl stop elasticsearch kibana filebeat logstash

# Копируем конфиги из текущей папки (корня)
echo "Копируем конфиги..."
sudo cp elk-backup/elasticsearch.yml /etc/elasticsearch/
sudo cp elk-backup/jvm.options /etc/elasticsearch/
sudo cp elk-backup/kibana.yml /etc/kibana/
sudo cp elk-backup/filebeat.yml /etc/filebeat/
sudo cp elk-backup/filebeat.conf /etc/logstash/conf.d/ 2>/dev/null || echo "Logstash config skipped"

# Настраиваем права
echo "Настраиваем права..."
sudo chown elasticsearch:elasticsearch /etc/elasticsearch/*
sudo chown kibana:kibana /etc/kibana/*
sudo chown root:root /etc/filebeat/*

# Запускаем сервисы
echo "Запускаем сервисы..."
sudo systemctl start elasticsearch
sudo systemctl start kibana filebeat logstash

# Проверка работы сервисов
sudo systemctl status elasticsearch --no-pager
sudo systemctl status logstash --no-pager
sudo systemctl status kibana --no-pager
echo "=== ГОТОВО! ==="
