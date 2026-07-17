#!/usr/bin/env python3
from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration

def generate_launch_description():
    # Аргументы
    rviz_arg = DeclareLaunchArgument('rviz', default_value='false')
    rqt_arg = DeclareLaunchArgument('rqt', default_value='false')
    
    rviz = LaunchConfiguration('rviz')
    rqt = LaunchConfiguration('rqt')

    # Узлы датчиков
    velodyne_node = Node(
        package='velodyne_driver',
        executable='velodyne_driver_node',
        name='velodyne_driver',
        parameters=[{'device_ip': '192.168.1.201', 'model': 'VLP16'}]
    )

    velodyne_pointcloud = Node(
        package='velodyne_pointcloud',
        executable='velodyne_pointcloud_node',
        name='velodyne_pointcloud'
    )

    usb_cam_node = Node(
        package='usb_cam',
        executable='usb_cam_node_exe',
        name='usb_cam',
        parameters=[{'video_device': '/dev/video0'}]
    )

    # Фиктивный узел для IMU (заглушка, пока нет физического датчика)
    dummy_imu = Node(
        package='robot_vacuum',
        executable='dummy_sensor.py',
        name='dummy_imu'
    )

    # RViz / RQT
    rviz_node = Node(
        package='rviz2',
        executable='rviz2',
        name='rviz2',
        condition=launch.conditions.IfCondition(rviz)
    )

    rqt_node = Node(
        package='rqt_gui',
        executable='rqt_gui',
        name='rqt_gui',
        condition=launch.conditions.IfCondition(rqt)
    )

    return LaunchDescription([
        rviz_arg,
        rqt_arg,
        velodyne_node,
        velodyne_pointcloud,
        usb_cam_node,
        dummy_imu,
        rviz_node,
        rqt_node
    ])
