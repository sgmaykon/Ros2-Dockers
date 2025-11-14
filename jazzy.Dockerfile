# Baseia-se numa imagem custom de algum do ros-jazzy
# link:
# https://hub.docker.com/layers/osrf/ros/humble-desktop-full/images/sha256-71ae08a6a0aae71a2f981e066c8a1d7dd76e956abf419c04626a0c746c3ebf4f
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
    sudo \
    && rm -rf /var/lib/apt/lists/*

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
