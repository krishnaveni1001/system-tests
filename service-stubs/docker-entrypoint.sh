#!/bin/bash

# forward all traffic coming into port 80 to port 8080
socat TCP-LISTEN:80,fork TCP:127.0.0.1:8080 &
socat TCP-LISTEN:443,fork TCP:127.0.0.1:8443 &

set -e

# Add `java -jar /wiremock-standalone.jar` as command if needed
if [ "${1:0:1}" = "-" ]; then
	set -- java $JAVA_OPTS -cp /var/wiremock/lib/*:/var/wiremock/extensions/* com.github.tomakehurst.wiremock.standalone.WireMockServerRunner "$@"
fi

# allow the container to be started with `-e uid=`
if [ "$uid" != "" ]; then
	# Change the ownership of /home/wiremock to $uid
	chown -R $uid:$uid /home/wiremock

	set -- gosu $uid:$uid "$@"
fi

exec "$@"
