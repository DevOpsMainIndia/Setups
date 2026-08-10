sudo yum update -y

sudo yum install wget -y

sudo mkdir -p /app
cd /app

sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz

sudo tar -xzf nexus-3.79.1-04-linux-x86_64.tar.gz

sudo mv nexus-3.79.1-04 nexus

sudo adduser nexus

sudo chown -R nexus:nexus /app

echo 'run_as_user="nexus"' | sudo tee /app/nexus/bin/nexus.rc

sudo tee /etc/systemd/system/nexus.service > /dev/null << 'EOF'
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

sudo systemctl enable nexus

sudo systemctl start nexus

sudo systemctl status nexus


Then check:

sudo systemctl status nexus

and, if it says failed:

sudo tail -100 /app/sonatype-work/nexus3/log/nexus.log
