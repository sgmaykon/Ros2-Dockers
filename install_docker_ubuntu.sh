#!/usr/bin/env bash

set -euo pipefail

echo "==> Verificando sistema..."

if [[ $EUID -ne 0 ]]; then
    echo "Execute como root:"
    echo "  sudo $0"
    exit 1
fi

if [[ ! -f /etc/os-release ]]; then
    echo "Erro: não foi possível identificar o sistema operacional."
    exit 1
fi

source /etc/os-release

if [[ "${ID}" != "ubuntu" ]]; then
    echo "Erro: este script foi feito para Ubuntu."
    echo "Sistema detectado: ${PRETTY_NAME:-$ID}"
    exit 1
fi

ARCH="$(dpkg --print-architecture)"
CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"

if [[ -z "${CODENAME}" ]]; then
    echo "Erro: não foi possível identificar o codename do Ubuntu."
    exit 1
fi

echo "Ubuntu: ${PRETTY_NAME}"
echo "Codename: ${CODENAME}"
echo "Arquitetura: ${ARCH}"
echo

echo "==> Atualizando índice do APT..."
apt-get update

echo "==> Instalando dependências..."
apt-get install -y \
    ca-certificates \
    curl

echo "==> Configurando diretório de keyrings..."
install -m 0755 -d /etc/apt/keyrings

echo "==> Instalando chave GPG oficial da Docker..."
curl -fsSL \
    https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo "==> Configurando repositório oficial da Docker..."

cat > /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${CODENAME}
Components: stable
Architectures: ${ARCH}
Signed-By: /etc/apt/keyrings/docker.asc
EOF

echo "==> Atualizando repositórios..."
apt-get update

echo "==> Instalando Docker Engine + Docker Compose V2..."

apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "==> Habilitando Docker no boot..."
systemctl enable docker.service
systemctl enable containerd.service

echo "==> Iniciando Docker..."
systemctl start docker

echo
echo "========================================"
echo " Docker instalado com sucesso!"
echo "========================================"
echo

echo "Docker:"
docker --version

echo
echo "Docker Compose:"
docker compose version

echo
echo "Status:"
systemctl --no-pager --full status docker || true

echo
echo "Teste:"
docker run --rm hello-world

echo
echo "========================================"
echo " Instalação concluída."
echo "========================================"
