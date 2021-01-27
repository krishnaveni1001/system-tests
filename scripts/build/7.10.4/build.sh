#!/bin/bash
# Build all 7.10.0 artifacts
push_docker_image=false
# Process the command line args
for arg in "$@"
do
  case $arg in
    -p|--push-docker-images)
      push_docker_image=true
      shift # Remove --push_docker_images from processing
      ;;
    *)
      OTHER_ARGUMENTS+=("$1")
      shift # Remove generic argument from processing
      ;;
  esac
done

# Start up Nexus3 instance
source ../start-nexus.sh

BUILD_GROUP_ROOT=$(pwd)
# Now build the images
PROJECT_BUILD_ROOT_PATH=$BUILD_GROUP_ROOT/..
cd $PROJECT_BUILD_ROOT_PATH
# rfq-service does not have a Dockerfile
# ./build.sh rfq-service releases/1.2.2 $push_docker_image
# notification-service does not build
# ./build.sh notification-service releases/1.6.6 $push_docker_image

# These services should successfully
cd $PROJECT_BUILD_ROOT_PATH
./build.sh reports-service releases/1.11.0 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh auth-service releases/1.2.1 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh rate-service-rs releases/2.4.3 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh admin-service releases/1.1.0 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh contract-management-service releases/1.5.0 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh esuds-copy-and-persist releases/2.3.0 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh esuds-read-and-validate releases/2.3.0 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh suds-engine releases/2.3.0 $push_docker_image
cd $PROJECT_BUILD_ROOT_PATH
./build.sh java releases/7.10.4 $push_docker_image
