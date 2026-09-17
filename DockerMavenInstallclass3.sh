#!/bin/bash

set -e

yum install java-17-amazon-corretto -y

cd /opt

MAVEN_VERSION=3.9.11
MAVEN_TAR=apache-maven-${MAVEN_VERSION}-bin.tar.gz
MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_TAR}

wget -O ${MAVEN_TAR} ${MAVEN_URL}

tar -xzf ${MAVEN_TAR}

rm -rf /opt/maven
mv apache-maven-${MAVEN_VERSION} /opt/maven

cat > /etc/profile.d/maven.sh <<'EOF'
export M2_HOME=/opt/maven
export PATH=$M2_HOME/bin:$PATH
EOF

chmod +x /etc/profile.d/maven.sh

source /etc/profile.d/maven.sh

echo "Maven installation successful"
which mvn
mvn -version

====================================================================================================
Step 2 — Make the script executable
chmod +x maven.sh
Step 3 — Run the script

Important: use ./maven.sh, NOT sh maven.sh.

./maven.sh

At the end you should see something similar to:

Maven installation successful
/opt/maven/bin/mvn
Apache Maven 3.9.11
Maven home: /opt/maven
Java version: 17...

Step 4 — Check Maven AFTER the script

Now run:

mvn -version

It should work.

Step 5 — Build your project

You should still be in:

/root/one

Check:

pwd

It should show:

/root/one

Then:

ls

You should have:

pom.xml
src

Now finally run:

mvn clean package
So your commands are ONLY these:
vim maven.sh

Paste the script → Esc → :wq → Enter

chmod +x maven.sh
./maven.sh
mvn -version
pwd
ls
mvn clean package

Don't run sh maven.sh.
