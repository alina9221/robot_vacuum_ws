#!/bin/bash
# setup_ssh.sh — настройка удалённого доступа по SSH

set -e

echo "=== Настройка SSH-сервера ==="
sudo apt install -y openssh-server

# Включаем SSH-сервер
sudo systemctl enable ssh
sudo systemctl start ssh

# Проверяем статус
sudo systemctl status ssh --no-pager

# Настройка ключей (опционально)
if [ ! -f ~/.ssh/id_rsa ]; then
    echo "Генерация SSH-ключа..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
fi

echo "=== Публичный ключ (добавь в ~/.ssh/authorized_keys на целевой машине) ==="
cat ~/.ssh/id_rsa.pub

echo "=== SSH настроен ==="
echo "Подключение: ssh $(whoami)@$(hostname -I | awk '{print $1}')"
