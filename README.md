# Ros2-Dockers
Imagens Docker das versões do ROS2 o mais prontas possíveis para uso, de várias versões do ROS2

Pra executar, crie um arquivo env, e modifique conforme suas necessidades.

Escolhe o diretório de trabalho, e qual imagem do ROS2 irá usar.

`cp .env.example env`

Imagens existentes:

* humble
* jazzy

Para executar, caso necessário rode

`chmod +x deploy.sh`

E execute

`./deploy.sh`


Se quiser rodar mais de um container por vez usando a mesma imagem, mude
a variável INSTANCE encontrada no .env

Por exemplo, o robô 1 em um container com INSTANCE = 1
robô 2 com INSTANCE = 2, e assim por diante.
