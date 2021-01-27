# nginx
Nginx routes traffic to each service, app, and/or static file. All files are mounted in [docker-compose.yml](../../docker-compose.yml)

## Configuration
Configuration is handled in [nginx.conf](nginx.conf)

## Static files
Nginx serves several static files from `/www/data` including a public/private key pair.
* public key (WTG XML format): http://proxy/keys/publickey
* private key (pkcs8): http://proxy/keys/private_key_pkcs8.pem
* private key: http://proxy/keys/private_key.pem
