
# Get ROS package
FROM ros:iron

# Install prerequisites, utilities, and NVIDIA Container Toolkit
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release git python3-pip && \
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add - && \
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list && \
    apt-get update && apt-get install -y nvidia-container-toolkit

# Clone the original GitHub repository
RUN git clone https://github.com/ycheng517/ar4_ros_driver.git /ar4_ros_driver

# Set the working directory
WORKDIR /ar4_ros_driver

# Import the repos and update/install dependencies
RUN vcs import . --input ar_hand_eye/hand_eye_calibration.repos && \
    rosdep update && \
    rosdep install --from-paths . --ignore-src -r -y

# Source ROS and build the workspace
RUN /bin/bash -c "source /opt/ros/iron/setup.bash && colcon build"

# Copy entrypoint script
COPY ros_entrypoint.sh /ros_entrypoint.sh

# Ensure the entrypoint script is executable
RUN chmod +x /ros_entrypoint.sh

# Add sourcing commands to .bashrc
RUN echo "source /opt/ros/iron/setup.bash" >> /root/.bashrc
RUN echo "if [ -f \"/ar4_ros_driver/install/setup.bash\" ]; then source /ar4_ros_driver/install/setup.bash; fi" >> /root/.bashrc

# Set up entrypoint
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

# Enable serial port access (as root)
# RUN addgroup --system dialout && adduser root dialout
