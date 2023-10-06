# Use the official ROS2 image as a base
FROM osrf/ros:foxy-desktop

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=non-interactive

# Run system updates and install Gazebo
RUN apt update && apt upgrade -y && \
    apt install -y gazebo11 && \
    rm -rf /var/lib/apt/lists/*

# Set the container's default command to bash
CMD ["bash"]
