#!/bin/bash
# Update and install Apache web server
yum update -y
yum install httpd -y

# Start Apache
service httpd start
chkconfig httpd on

# Create a simple HTML page
echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EC2 Instance Hostname</title>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            fetch('http://169.254.169.254/latest/meta-data/local-hostname')
                .then(response => response.text())
                .then(hostname => {
                    document.getElementById('hostname').innerText = hostname;
                })
                .catch(error => {
                    console.error('Error fetching hostname:', error);
                    document.getElementById('hostname').innerText = 'Error fetching hostname';
                });
        });
    </script>
</head>
<body>
    <h1>EC2 Instance Hostname</h1>
    <p>The hostname of this EC2 instance is: <span id="hostname"></span></p>
</body>
</html>' > /var/www/html/index.html

# Set permissions for the HTML file
chmod 644 /var/www/html/index.html

# Restart Apache to apply changes
service httpd restart