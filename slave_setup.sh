#!/bin/bash

echo "Настройка MySQL Slave сервера..."

# Останавливаем MySQL для настройки
sudo systemctl stop mysql

# Создаем конфигурационный файл для Slave
sudo tee /etc/mysql/mysql.conf.d/replication.cnf > /dev/null <<EOF
[mysqld]
server-id = 2
relay-log = /var/log/mysql/mysql-relay-bin.log
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = test_db
read_only = 1
EOF

# Запускаем MySQL
sudo systemctl start mysql

# Запрашиваем данные от пользователя
read -p "Введите MASTER_LOG_FILE (из вывода SHOW MASTER STATUS на master): " master_file
read -p "Введите MASTER_LOG_POS (из вывода SHOW MASTER STATUS на master): " master_pos

# Настраиваем репликацию
sudo mysql -e "
STOP SLAVE;

CHANGE MASTER TO
MASTER_HOST='192.168.196.129',
MASTER_USER='replica_user',
MASTER_PASSWORD='replica_password',
MASTER_LOG_FILE='$master_file',
MASTER_LOG_POS=$master_pos;

START SLAVE;
"

echo "Slave настройка завершена!"
