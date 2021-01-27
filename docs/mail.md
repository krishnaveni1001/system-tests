# The mail layer
With the mail layer running, and the core application properly configured, emails can be "sent" from the core application. The emails are captured by `mailhog`, which can be accessed via its GUI.

## Layer dependencies
The mail layer has no dependencies on any other layers.

## Configuration
The mail configuration options are passed to the core application container by setting the `JAVA_OPTS` environment variable in the core service configuration in [docker-compose.yaml](../docker-compose.yaml).
```bash
- JAVA_OPTS=-Dmail.smtp.host="mail" -Dmail.smtp.port=1025
```

### Options
`mail.smtp.host`: This is the mail server. Within the `system-tests` framework the mail server is called `mail` (this can be found in [docker-compose.yaml](../docker-compose.yaml)). The default value is `localhost`

`mail.smtp.port`: This is the port to connect to on the mail server. The port can be configured in [docker-compose.yaml](../docker-compose.yaml). MailHog listens on port `1025` by default, so we can just use that.

## MailHog GUI url
http://proxy:3014

## Commands
Start the mail layer with:
```bash
./scripts/layer mail up
```
