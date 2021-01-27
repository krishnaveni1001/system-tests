FROM rodolpheche/wiremock:latest
RUN apt-get update && \
    apt-get --assume-yes install socat
COPY docker-entrypoint.sh /
RUN chmod 700 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD java $JAVA_OPTS -cp /var/wiremock/lib/*:/var/wiremock/extensions/* com.github.tomakehurst.wiremock.standalone.WireMockServerRunner
