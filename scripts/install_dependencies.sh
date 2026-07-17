#!/bin/bash
# install_dependencies.sh — установка всех зависимостей для робота-пылесоса

set -e

echo "=== Установка системных зависимостей ==="
sudo apt update
sudo apt install -y \
    git \
    build-essential \
    cmake \
    python3-pip \
    python3-serial \
    can-utils \
    openssh-server \
    usbutils \
    net-tools

echo "=== Установка ROS 2 Humble ==="
# Проверка, установлен ли ROS 2
if [ ! -f /opt/ros/humble/setup.bash ]; then
    echo "Установка ROS 2 Humble..."
    sudo apt install -y software-properties-common
    sudo add-apt-repository universe
    sudo apt update
    sudo apt install -y curl
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt update
    sudo apt install -y ros-humble-desktop
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
fi

source /opt/ros/humble/setup.bash

echo "=== Установка ROS-пакетов ==="
sudo apt install -y \
    ros-humble-velodyne-driver \
    ros-humble-velodyne-pointcloud \
    ros-humble-usb-cam \
    ros-humble-rviz2 \
    ros-humble-rqt \
    ros-humble-rqt-gui \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers

echo "=== Установка odrive_can (из исходников) ==="
cd ~
if [ ! -d "ros2_ws/src/odrive_can" ]; then
    mkdir -p ~/ros2_ws/src
    cd ~/ros2_ws/src
    git clone https://github.com/r4hul77/odrive_can.git
    cd ~/ros2_ws
    colcon build --packages-select odrive_can
    echo "source ~/ros2_ws/install/setup.bash" >> ~/.bashrc
fi

echo "=== Установка xsens_mti_driver ==="
# NOTE: xsens_mti_driver требует MT Software Suite от Xsens
# Скачай с https://www.xsens.com/mt-software-suite/
# и скопируй xsens_ros_mti_driver в ~/ros2_ws/src/

echo "=== ВСЕ ЗАВИСИМОСТИ УСТАНОВЛЕНЫ ==="
echo "Не забудь установить xsens_mti_driver вручную из MT Software Suite!"
