FROM postgres:11.4-alpine
RUN apk add --update openssh sudo

RUN mkdir -p /home/postgres/.ssh && \
    chmod 700 /home/postgres/.ssh

# This entrypoint will run all the *.sql and *.sh scripts in ./assets/*.
# Check the docker-compose.yaml to see where they're mounted, as well
# as for the environment variables that are available to these scripts. 
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["postgres"]
