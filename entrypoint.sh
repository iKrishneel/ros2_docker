#!/bin/bash
set -e

# setup ros2 environment
source "/opt/ros2/$ROS_DISTRO/install/setup.bash"
exec "$@"
