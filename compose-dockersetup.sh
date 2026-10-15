
#!/bin/bash
set -Eeuo pipefail

# Docker Compose and Buildx installation
# OS: Amazon Linux 2023
# Prerequisite: Docker installed using yum 

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script as root using sudo -i."
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "ERROR: Docker is not installed."
    echo "Run: yum install docker -y && systemctl start docker"
    exit 1
fi

# Detect system architecture
ARCH="$(uname -m)"

case "$ARCH" in
    x86_64)
        COMPOSE_ARCH="x86_64"
        BUILDX_ARCH="amd64"
        ;;
    aarch64)
        COMPOSE_ARCH="aarch64"
        BUILDX_ARCH="arm64"
        ;;
    *)
        echo "ERROR: Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Versions: update these when you intentionally upgrade
COMPOSE_VERSION="v5.6.0"
BUILDX_VERSION="v0.37.2"

PLUGIN_DIR="/usr/local/lib/docker/cli-plugins"
mkdir -p "$PLUGIN_DIR"

# Install Docker Compose CLI plugin
echo "Installing Docker Compose $COMPOSE_VERSION..."

curl -fSL --retry 3 \
    "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-${COMPOSE_ARCH}" \
    -o "${PLUGIN_DIR}/docker-compose"

chmod 755 "${PLUGIN_DIR}/docker-compose"

# Install Docker Buildx CLI plugin
echo "Installing Docker Buildx $BUILDX_VERSION..."

curl -fSL --retry 3 \
    "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-${BUILDX_ARCH}" \
    -o "${PLUGIN_DIR}/docker-buildx"

chmod 755 "${PLUGIN_DIR}/docker-buildx"

# Optional compatibility for older course commands
ln -sfn "${PLUGIN_DIR}/docker-compose" /usr/local/bin/docker-compose

# Start Docker now and enable it at boot
systemctl enable --now docker

# Verify installations
echo
echo "========== INSTALLATION VERIFICATION =========="

docker --version
docker compose version
docker-compose version
docker buildx version

echo
echo "========== DOCKER DAEMON CHECK =========="

docker info >/dev/null
echo "Docker daemon is accessible."

echo
echo "========== INSTALLATION COMPLETE =========="
