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

====copy code by vim doc.sh, after sh doc.sh 
===================================================================================================================
==scanning image, here image:v1 is the image which you want to scan
TMPDIR=/var/trivy-tmp trivy image image:v1 | tee trivy-report.txt
head -n 50 trivy-report.txt
less trivy-report.txt
===========================================================================================================0r=======
TMPDIR=/var/trivy-tmp trivy image image:v1 | tee trivy-report.txt
grep "Total:" trivy-report.txt
less trivy-report.txt
