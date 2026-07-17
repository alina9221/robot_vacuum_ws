#!/usr/bin/env python3
import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Imu
import random

class DummyIMU(Node):
    def __init__(self):
        super().__init__('dummy_imu')
        self.pub = self.create_publisher(Imu, '/imu/data', 10)
        self.timer = self.create_timer(0.1, self.publish_imu)

    def publish_imu(self):
        msg = Imu()
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.header.frame_id = 'imu_link'
        msg.orientation.w = 1.0
        msg.angular_velocity.z = random.uniform(-0.1, 0.1)
        msg.linear_acceleration.z = 9.81 + random.uniform(-0.5, 0.5)
        self.pub.publish(msg)

def main(args=None):
    rclpy.init(args=args)
    node = DummyIMU()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
