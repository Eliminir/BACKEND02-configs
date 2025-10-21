#!/bin/bash

set -e  # Остановка при ошибках

echo "=== Установка MySQL и Apache ==="

# Обновление пакетов
sudo apt update

# Установка MySQL и Apache
sudo apt install -y mysql-server apache2

echo "=== Скачивание конфигураций из GitHub ==="

# Скачивание репозитория
git clone https://github.com/Eliminir/BACKEND02-configs.git /tmp/server-configs

echo "=== Применение конфигураций ==="

# Копирование конфигураций MySQL
sudo cp -r /tmp/server-configs/mysql/* /etc/mysql/

# Копирование конфигураций Apache
sudo cp -r /tmp/server-configs/apache2/* /etc/apache2/

echo "=== Настройка прав доступа ==="

# Настройка прав для MySQL
sudo chown -R mysql:mysql /etc/mysql/
sudo chmod -R 644 /etc/mysql/
sudo find /etc/mysql/ -type d -exec chmod 755 {} \;

# Настройка прав для Apache
sudo chown -R root:root /etc/apache2/
sudo chmod -R 644 /etc/apache2/
sudo find /etc/apache2/ -type d -exec chmod 755 {} \;

echo "=== Перезапуск сервисов ==="

# Перезапуск сервисов
sudo systemctl daemon-reload
sudo systemctl restart mysql
sudo systemctl restart apache2

echo "=== Проверка статуса ==="

# Проверка работы сервисов
sudo systemctl status mysql --no-pager
sudo systemctl status apache2 --no-pager

echo "=== Очистка ==="
rm -rf /tmp/server-configs

echo "=== Установка завершена! ==="
