# Baseia-se numa imagem custom de algume do ros-humble
# link:
# https://hub.docker.com/layers/osrf/ros/humble-desktop-full/images/sha256-71ae08a6a0aae71a2f981e066c8a1d7dd76e956abf419c04626a0c746c3ebf4f
FROM osrf/ros:humble-desktop-full

ARG USERNAME=ultra
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# ARG ROOT_PASSWORD=root123

RUN apt-get update && apt-get install -y \
    vim \
    python3-pip \
    sudo \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-teleop-twist-joy \
	  ros-humble-teleop-twist-keyboard \
	  ros-humble-rplidar-ros \
	  ros-humble-laser-filters \
	  ros-humble-rqt \
	  ros-humble-rqt-common-plugins \
	  ros-humble-rmw-cyclonedds-cpp \
    ros-humble-slam-toolbox \
	  ros-humble-nav2-bringup \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG sudo $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# (Opcional) definir senha para root — útil pra debug manual
# RUN echo "root:root123" | chpasswd

# Cria um diretório de trabalho
WORKDIR /home/$USERNAME
USER $USERNAME

SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
CMD ["bash"]
