# Baseia-se numa imagem custom de algum do ros-jazzy
# link:
# https://hub.docker.com/layers/osrf/ros/jazzy-desktop-full/images/sha256-71ae08a6a0aae71a2f981e066c8a1d7dd76e956abf419c04626a0c746c3ebf4f
FROM osrf/ros:jazzy-desktop-full

ARG USERNAME=ultra
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# ARG ROOT_PASSWORD=root123
# Atualiza pacotes e instala dependências extras (exemplo)

RUN apt-get update  && \
    apt-get install -y \
    ca-certificates \
    gnupg2 \
    curl \
    software-properties-common \
    lsb-release && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated --no-install-recommends \
    vim \
    zsh \
    ros-dev-tools \
    sudo \
    ros-jazzy-rmf-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y ros-jazzy-tf-transformations   

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py --break-system-packages && \
    rm get-pip.py

RUN python3 -m pip install --break-system-packages nudged eclipse-zenoh==1.5.0 pycdr2 rosbags transforms3d

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
