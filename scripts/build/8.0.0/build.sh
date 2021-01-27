#!/bin/bash
# This is untested as of Apr. 07, 2020
# Build all 8.0.0 artifacts
source ../start-nexus.sh

BUILD_GROUP_ROOT=$(pwd)
# Now build the images
PROJECT_BUILD_ROOT_PATH=$BUILD_GROUP_ROOT/..
# These services should successfully
cd $PROJECT_BUILD_ROOT_PATH
./build.sh auth-microservices develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh reports-service develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh rate-service-rs develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh contract-management-service develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh esuds-copy-and-persist develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh esuds-read-and-validate develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh suds-engine develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh quote-cart develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh rfq-service develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh carrier-export develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh notification-service develop
cd $PROJECT_BUILD_ROOT_PATH
./build.sh java develop
