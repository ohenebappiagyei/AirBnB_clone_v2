-- Create or use hbnb_dev_db database
CREATE DATABASE IF NOT EXISTS hbnb_dev_db;

-- Create or use hbnb_dev user with the specified password
CREATE USER IF NOT EXISTS 'hbnb_dev'@'localhost' IDENTIFIED BY 'hbnb_dev_pwd';

-- Grant all privileges on hbnb_dev_db to hbnb_dev
GRANT ALL PRIVILEGES ON hbnb_dev_db.* TO 'hbnb_dev'@'localhost';
FLUSH PRIVILEGES;

-- Grant SELECT privileges on performance_schema to hbnb_dev
GRANT SELECT ON performance_schema.* TO 'hbnb_dev'@'localhost';
