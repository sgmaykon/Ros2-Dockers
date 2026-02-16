# Baseia-se numa imagem custom de algum do ros-jazzy
# link:
# https://hub.docker.com/layers/osrf/ros/jazzy-desktop-full/images/sha256-71ae08a6a0aae71a2f981e066c8a1d7dd76e956abf419c04626a0c746c3ebf4f
FROM osrf/ros:jazzy-desktop-full

ARG USERNAME=ultra
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# ARG ROOT_PASSWORD=root123
#
#
# Atualiza pacotes e instala dependências extras (exemplo)
RUN apt-get update && apt-get install -y \
    vim \
    python3-pip \
    zsh \
    ros-dev-tools \
    sudo \
    ros-jazzy-rmf-dev \
    && sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && rm -rf /var/lib/apt/lists/*

RUN  apt update &&  apt install curl gnupg2 lsb-release  && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN apt-get clean && apt-get autoclean &&  apt-get autoremove


RUN groupmod -n $USERNAME $(getent group $USER_GID | cut -d: -f1) \
    && usermod -l $USERNAME -d /home/$USERNAME -m $(getent passwd $USER_UID | cut -d: -f1) \
    && usermod -aG sudo $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# (Opcional) definir senha para root — útil pra debug manual
# RUN echo "root:root123" | chpasswd

# Cria um diretório de trabalho
WORKDIR /home/$USERNAME
USER $USERNAME

SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
CMD ["bash"]
