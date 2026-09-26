#!/bin/bash

# Install Trivy
dnf install -y wget

wget -qO- https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | \
sh -s -- -b /usr/local/bin

# Create dedicated Trivy temporary directory
mkdir -p /var/trivy-tmp
chmod 1777 /var/trivy-tmp

# Create Trivy cache directory
mkdir -p /var/trivy-cache

echo "Trivy installation completed."
echo "Temporary directory:"
df -h /var/trivy-tmp

echo "Trivy version:"
trivy --version
===================================================================================================================
==scanning image
TMPDIR=/var/trivy-tmp trivy image image:v1
