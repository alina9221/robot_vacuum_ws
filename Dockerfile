FROM ros:humble-ros-base

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    python3-pip \
    python3-serial \
    can-utils \
    openssh-server \
    usbutils \
    net-tools \
    ros-humble-velodyne-driver \
    ros-humble-velodyne-pointcloud \
    ros-humble-usb-cam \
    ros-humble-rviz2 \
    ros-humble-rqt \
    ros-humble-rqt-gui \
    ros-humble-ros2-control \
    ros-humble-ros2-controllers \
    && rm -rf /var/lib/apt/lists/*

# Настройка SSH
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22

# Создание рабочего пространства
WORKDIR /root/ros2_ws
RUN mkdir -p src

# Копирование исходников
COPY src/ src/

# Сборка
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Точка входа
CMD ["/bin/bash", "-c", "source /opt/ros/humble/setup.bash && source /root/ros2_ws/install/setup.bash && exec bash"]
