#!/bin/bash
#################################################
# Usage: ./build.sh <repo> <branch> <push>
# Example: ./build.sh java releases/7.10.0 false
#################################################
repo=$1
branch=$2
push_docker_image=$3
nexus_profile=ibm
settings_file=$(pwd)/settings.xml
echo "Using settings file: $settings_file"

# Clean it
[ -d "./docker-build" ] && echo "Removing old checkout" && rm -rf ./docker-build/$repo
mkdir -p ./docker-build
cd ./docker-build

# Clone it
git clone -b $branch --single-branch git@github.com:cargosphere/$repo

# Move into the project
cd $repo

# Update settings.xml to use docker.for.mac.localhost for central
cp $settings_file ./settings.xml
[ -d "deploy" ] && cp $settings_file deploy/settings.xml
[ -d "deploy/container" ] && cp $settings_file deploy/container/settings.xml

# Copy id_rsa if needed
if [[ 'contract-management-service|notification-service|java' =~ $repo ]]; then
  cp ~/.ssh/id_rsa deploy
fi

if [[ 'admin-service' =~ $repo ]]; then
  mvn clean package -DskipTests
fi

# Docker build it
if [[ 'rate-service-rs' =~ $repo ]]; then
  docker build . \
    --build-arg nexus_profile=$nexus_profile \
    --build-arg nexus_gcp_addr=nexus.cargosphere.us \
    --build-arg skip_tests=true \
    --no-cache \
    -f deploy/Dockerfiles/app/Dockerfile \
    -t gcr.io/awesomecstools/system-tests/$repo/$branch:latest
    if [ "$push_docker_image" = true ]; then
      docker push gcr.io/awesomecstools/system-tests/$repo/$branch:latest
    fi
elif [[ 'auth-microservices' =~ $repo ]]; then
  echo "Compiling auth-microservices"
  mvn clean install -DskipTests
  echo "Building admin-service docker image"
  cd ./admin/service
  docker build . \
    --build-arg nexus_profile=$nexus_profile \
    --build-arg nexus_gcp_addr=nexus.cargosphere.us \
    --no-cache \
    --build-arg skip_tests=true \
    -t gcr.io/awesomecstools/system-tests/$repo/admin-service/$branch:latest
    if [ "$push_docker_image" = true ]; then
      docker push gcr.io/awesomecstools/system-tests/$repo/admin-service/$branch:latest
    fi
  echo "Building auth-service docker image"
  cd ../auth/service
  docker build . \
    --build-arg nexus_profile=$nexus_profile \
    --build-arg nexus_gcp_addr=nexus.cargosphere.us \
    --no-cache \
    --build-arg skip_tests=true \
    -t gcr.io/awesomecstools/system-tests/$repo/auth-service/$branch:latest
    if [ "$push_docker_image" = true ]; then
      docker push gcr.io/awesomecstools/system-tests/$repo/auth-service/$branch:latest
    fi
else
  docker build . \
    --build-arg nexus_profile=$nexus_profile \
    --build-arg nexus_gcp_addr=nexus.cargosphere.us \
    --no-cache \
    --build-arg skip_tests=true \
    -t gcr.io/awesomecstools/system-tests/$repo/$branch:latest
    if [ "$push_docker_image" = true ]; then
      docker push gcr.io/awesomecstools/system-tests/$repo/$branch:latest
    fi
fi
