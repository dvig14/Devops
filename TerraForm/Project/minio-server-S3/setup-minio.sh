#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y wget

wget https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin/

sudo mkdir -p /home/vagrant/minio
sudo chown vagrant:vagrant /home/vagrant/minio

# Use environment variables passed by Vagrant or default values
MINIO_USER="${AWS_ACCESS_KEY_ID:-minioadmin}"
MINIO_PASS="${AWS_SECRET_ACCESS_KEY:-minioadmin}"

cat << EOF | sudo tee /etc/systemd/system/minio.service
[Unit]
Description=MinIO
After=network-online.target 

[Service]
User=vagrant
Group=vagrant
Environment="MINIO_ROOT_USER=${MINIO_USER}"  
Environment="MINIO_ROOT_PASSWORD=${MINIO_PASS}"
ExecStart=/usr/local/bin/minio server /home/vagrant/minio --console-address=:9001
Restart=always
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable minio
sudo systemctl start minio

echo "MinIO server started. Access it at http://localhost:9000"
echo "MinIO Console is available at http://localhost:9001" 