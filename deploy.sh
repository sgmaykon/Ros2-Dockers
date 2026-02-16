ROS_VERSION=$(grep ROS_VERSION .env | cut -d '=' -f2)

# Define um valor padrão caso esteja vazio no arquivo
if [ -z "$ROS_VERSION" ]; then
  ROS_VERSION="humble"
fi

xhost +local:docker
docker compose -p ${ROS_VERSION}_stack up -d --build --security-opt seccomp=unconfined
docker compose -p ${ROS_VERSION}_stack exec ros-dev bash
