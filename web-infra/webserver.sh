#!/bin/bash
apt update
apt install -y apache2

# Get the instance ID using the instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

cat <<EOF > /var/www/html/index.html
  <h2>Instance ID: <span style="color:green">$INSTANCE_ID</span></h2>

EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2