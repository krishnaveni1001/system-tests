#!/bin/bash

# Get nexus running locally
function get_cookie {
  echo "Getting cookie…"
  cookie=$(
    curl -v \
      --silent \
      'http://localhost:15000/service/rapture/session' \
      -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
      -H 'Accept: */*' \
      --data-urlencode "username=$(echo -n 'admin' | openssl base64)" \
      --data-urlencode "password=$(echo -n $(docker exec -it local-nexus cat ./nexus-data/admin.password) | openssl base64)" \
      --compressed 2>&1 | grep 'Set-Cookie' | awk '{print $3}'
  )
}

function create_repo {
  echo "Creating repo…"
  get_cookie
  echo "Using cookie: $cookie"
  curl -v \
    'http://localhost:15000/service/rest/beta/repositories/maven/proxy' \
    -H "accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Cookie: $cookie" \
    -d $data
}

function init_nexus {
  echo "Initializing nexus…"
  data='{"name":"cs-ibm-mvn","online":true,"storage":{"blobStoreName":"default","strictContentTypeValidation":true},"cleanup":{"policyNames":["weekly-cleanup"]},"proxy":{"remoteUrl":"http://nexus.cargosphere.us/repository/cargosphere-mvn-hosted/","contentMaxAge":1440,"metadataMaxAge":1440},"negativeCache":{"enabled":false,"timeToLive":1440},"httpClient":{"blocked":false,"autoBlock":false},"maven":{"versionPolicy":"MIXED","layoutPolicy":"STRICT"}}'
  create_repo
  data='{"name":"cs-ibm-zkoss","online":true,"storage":{"blobStoreName":"default","strictContentTypeValidation":true},"cleanup":{"policyNames":["weekly-cleanup"]},"proxy":{"remoteUrl":"http://nexus.cargosphere.us/repository/zkoss/","contentMaxAge":1440,"metadataMaxAge":1440},"negativeCache":{"enabled":false,"timeToLive":1440},"httpClient":{"blocked":false,"autoBlock":false},"maven":{"versionPolicy":"MIXED","layoutPolicy":"STRICT"}}'
  create_repo
  data='{"name":"cs-ibm-jitpack","online":true,"storage":{"blobStoreName":"default","strictContentTypeValidation":true},"cleanup":{"policyNames":["weekly-cleanup"]},"proxy":{"remoteUrl":"http://nexus.cargosphere.us/repository/jitpack-proxy/","contentMaxAge":1440,"metadataMaxAge":1440},"negativeCache":{"enabled":false,"timeToLive":1440},"httpClient":{"blocked":false,"autoBlock":false},"maven":{"versionPolicy":"MIXED","layoutPolicy":"STRICT"}}'
  create_repo
}

function wait_for_nexus {
  echo "Waiting for nexus to finish starting up (this takes between 30 and 45 seconds)…"
  while true; do
    docker logs local-nexus | grep 'Started Sonatype Nexus OSS' && \
    break;
    sleep 2;
  done;
}

function start_nexus {
  echo "Starting nexus…"
  docker rm --force local-nexus
  if [ "$PERSIST" = true ]; then
    create_volume
    docker run -d -p 15000:8081 --name local-nexus -v nexus-data:/nexus-data sonatype/nexus3
  else
    docker run -d -p 15000:8081 --name local-nexus sonatype/nexus3
  fi
  time wait_for_nexus
  init_nexus
}

function create_volume {
  docker volume create --name nexus-data
}

# Process the command line args
for arg in "$@"
do
  case $arg in
    -p|--persist)
      PERSIST=true
      shift # Remove --persist from processing
      ;;
    *)
      OTHER_ARGUMENTS+=("$1")
      shift # Remove generic argument from processing
      ;;
  esac
done

start_nexus
