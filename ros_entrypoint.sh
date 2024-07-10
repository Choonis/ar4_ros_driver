#!/bin/bash
set -e

# Source ROS setup file
source /opt/ros/iron/setup.bash

# Source your workspace setup file if it exists
if [ -f "/ar4_ros_driver/install/setup.bash" ]; then
  source /ar4_ros_driver/install/setup.bash
else 
  echo "ar4_ros_driver/install/setup.bash not found, skipping."
fi

exec "$@"