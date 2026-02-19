#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Infrastructure Architect | Aleksandr</title>
</head>
<body>
    <img src="https://${bucket_name}.s3.${region}.amazonaws.com/profile.jpg" alt="Aleksandr">
    <h1>Oleksandr - Modular Version</h1>
    <p>This server was deployed using Terraform Modules!</p>
</body>
</html>
HTML