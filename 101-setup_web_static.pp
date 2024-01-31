# puppet/manifests/web_static.pp

# Update package repository
exec { 'apt-update':
  command => 'apt-get update',
  path    => '/usr/bin',
}

# Install nginx
package { 'nginx':
  ensure  => 'latest',
  require => Exec['apt-update'],
}

# Create directory structure
file { '/data/web_static/releases/test/':
  ensure => 'directory',
}

file { '/data/web_static/shared/':
  ensure => 'directory',
}

# Create index.html
file { '/data/web_static/releases/test/index.html':
  content => '<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <p>Nginx server test</p>
  </body>
</html>',
  require => File['/data/web_static/releases/test/'],
}

# Create symbolic link
file { '/data/web_static/current':
  ensure  => 'link',
  target  => '/data/web_static/releases/test/',
  require => File['/data/web_static/releases/test/index.html'],
}

# Change ownership
exec { 'chown-web-static':
  command => 'chown -R ubuntu:ubuntu /data',
  require => File['/data/web_static/current'],
}

# Configure Nginx
file { '/etc/nginx/sites-enabled/default':
  content => "server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /hbnb_static {
        alias /data/web_static/current;
    }
}
",
  require  => Package['nginx'],
  notify  => Service['nginx'],
}

# Restart Nginx
service { 'nginx':
  ensure     => 'running',
  enable     => true,
  subscribe => File['/etc/nginx/sites-enabled/default'],
}

