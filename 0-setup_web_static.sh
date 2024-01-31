#!/usr/bin/env bash
# Script to set up web servers for deployment of web_static

# Install Nginx if not already installed 
if ! command -v nginx &> /dev/null; then
    sudo apt-get -y update
    sudo apt-get -y install nginx
fi

# Create necessary folders
folders=("/data" "/data/web_static" "/data/web_static/releases" "/data/web_static/shared" "/data/web_static/releases/test")
for folder in "${folders[@]}"; do
    sudo mkdir -p "$folder"
    sudo chown -R root:root "$folder"
done

# Create a fake HTML file
fake_html_path="/data/web_static/releases/test/index.html"
echo "<html>" | sudo tee "$fake_html_path" > /dev/null
echo "  <head>" | sudo tee -a "$fake_html_path" > /dev/null
echo "  </head>" | sudo tee -a "$fake_html_path" > /dev/null
echo "  <body>" | sudo tee -a "$fake_html_path" > /dev/null
echo "    Holberton School" | sudo tee -a "$fake_html_path" > /dev/null
echo "  </body>" | sudo tee -a "$fake_html_path" > /dev/null
echo "</html>" | sudo tee -a "$fake_html_path" > /dev/null
sudo chown -R root:root "$fake_html_path"

# Create or recreate symbolic link
symbolic_link="/data/web_static/current"
[ -L "$symbolic_link" ] && sudo rm -rf "$symbolic_link"
sudo ln -s /data/web_static/releases/test/ "$symbolic_link"

# Give ownership of /data/ folder to ubuntu user and group
sudo chown -R root:root /data

# Update Nginx configuration
nginx_config="/etc/nginx/sites-available/default"
nginx_alias="location /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n"
if ! grep -q "location /hbnb_static" "$nginx_config"; then
    sudo sed -i "/^\s*server_name _;/a $nginx_alias" "$nginx_config"
fi

# Restart Nginx
sudo service nginx restart

exit 0

