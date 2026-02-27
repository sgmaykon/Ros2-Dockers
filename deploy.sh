ROS_VERSION=$(grep ROS_VERSION .env | cut -d '=' -f2)

# Define um valor padrão caso esteja vazio no arquivo
if [ -z "$ROS_VERSION" ]; then
  ROS_VERSION="humble"
fi
INSTANCE=$(grep INSTANCE .env | cut -d '=' -f2)

if [ -z "$INSTANCE" ]; then
  INSTANCE="1"
fi

CONTAINER_SERVICE="ros-dev"
PROJECT_NAME="${ROS_VERSION}_stack"
OVERRIDE_FILE="docker-compose.override.yaml"
DEVICE_FOUNT=false
xhost +local:docker

# Passo 2: Defina a LISTA de dispositivos que você quer conectar.
DEVICE_PORTS=(
    "/dev/rplidar"
    "/dev/ttyACM0"
     "/dev/zlac"
    #"/dev/bfield"
    "/dev/input"
)


# Cria arquivo override do zero
cat <<EOF > $OVERRIDE_FILE
services:
  $CONTAINER_SERVICE:
    devices:
EOF

for port in "${DEVICE_PORTS[@]}"; do
    if [ -e "$port" ]; then
        echo "  - $port:$port"
        echo "      - $port:$port" >> $OVERRIDE_FILE
        DEVICE_FOUND=true
    else
        echo "AVISO: $port não encontrado."
    fi
done

# Se nenhum device foi encontrado, remove a seção devices
if [ "$DEVICE_FOUND" = false ]; then
    echo "Nenhum device encontrado. Removendo override."
    rm $OVERRIDE_FILE
fi
docker network create rmf_network
docker compose -p ${PROJECT_NAME}_${INSTANCE} up -d --build --remove-orphans
docker compose -p ${PROJECT_NAME}_${INSTANCE} exec ros-dev bash
