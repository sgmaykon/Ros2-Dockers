# Baseia-se numa imagem custom de algume do ros-humble
# link:
# https://hub.docker.com/layers/osrf/ros/humble-desktop-full/images/sha256-71ae08a6a0aae71a2f981e066c8a1d7dd76e956abf419c04626a0c746c3ebf4f
FROM ros:humble-ros-base


ARG USERNAME=ultra
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# ARG ROOT_PASSWORD=root123


RUN apt-get update && apt-get install -y \
    vim \
    python3-pip \
    terminator \
    ros-humble-ros-gz \
    ros-humble-teleop-twist-joy \
    ros-humble-teleop-twist-keyboard \
    ros-humble-rplidar-ros \
    ros-humble-rviz2 \
    libmodbus-dev \
    #ros-humble-xacro \
    ros-humble-laser-filters \
    ros-humble-gazebo-ros-pkgs \
    ros-humble-rqt \
    ros-humble-rqt-common-plugins \
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-slam-toolbox \
    ros-humble-nav2-bringup \
    ros-humble-joint-state-publisher-gui \
    sudo \
    curl \
    gnupg2 \
    lsb-release \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && usermod -aG sudo $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# Cria um diretório de trabalho
WORKDIR /home/$USERNAME
USER $USERNAME

SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp" >> ~/.bashrc
CMD ["bash"]
