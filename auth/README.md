# auth image
The following commands were run to generate a public/private key pair for the auth service. These keys are mounted under the `volumes` section in [docker-compose.yml](docker-compose.yml)

```bash
# if openssl is not installed yet, do so
apk add --update openssl
# Generate teh private key
openssl genrsa -out ./private_key.pem 2048
# Generate the public key in the pem format
openssl rsa -pubout -in ./private_key.pem -out ./public_key.pem
# Generate the public key in the pkcs8 format
openssl pkcs8 -topk8 -in ./private_key.pem -inform pem -out ./private_key_pkcs8.pem -outform pem -nocrypt
```

These keys can be used to sign JWTs for use with CargoSpehre services and apps
