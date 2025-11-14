xhost +local:docker
docker compose up -d --build
docker compose exec ros-dev bash 

