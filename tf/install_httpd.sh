#!/bin/bash
sudo yum update -y
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "Hello, World!" | sudo tee /var/www/html/index.html