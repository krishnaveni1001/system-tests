# What's all this then?
These scripts accomplish the following two goals:

1. Provide a means for developers to build  local repositories quickly
2. Build whole sets of Docker images which can be used for automated testing

## Running Nexus3 locally
These scripts will help improve local build speeds, by standing up a local Nexus3 instance, and enable developers to create and build sets of Docker images. **This tool still requires a VPN connection in order to load CargoSphere specific artifacts** (unless you want to build _everything_ from scratch, which is probably possible, but highly unrecommended).The resulting Nexus3 instance runs on port 15000 [as scripted here](start-nexus.sh), and after the Nexus3 instance is up, you should be able to access it by navigating to http://localhost:15000/#browse/browse. This repo provides the means to stand up a local Nexus3 instance which proxies the zkoss, jitpack, and CargoSphere maven repos on IBM, but leaves maven-central pointing at the actual maven-central repo. If you include the `-p` or `--persist-nexus-data` flag, then any repositories loaded, and any data loaded, will be available for use on subsequent image uses. Once the Nexus3 instance is running, you can update your local `~/.m2/settings.xml` file to point to it.

The Nexus3 container will keep running after the script is finished. This is makes it easier to leverage for development (Developers can start it and forget about it), and it also greatly improves building sets of Docker images, which is done in the [7.10.0 build script](7.10.0/build.sh). Take a look at [settings.xml](settings.xml) to see how access is configured locally.

### Persistence
By default, user, repo, and artifact data will not persist, and when the Nexus3 container stops, all data will be lost. If you choose for the data to persist, it will do so in a Docker volume, which can be mounted on subsequent runs.
#### Run without persistence
```bash
./start-nexus.sh
```
#### Run with persistence
```bash
./start-nexus.sh --persist-nexus-data
```

## Build a release set
This repository includes a set of build scripts which can be used to build entire sets of Docker images (usually grouped by release). These Docker images can be used during automated system testing, and are an alternative option to using already constructed Docker images hosted by CargoSphere's GCP [`awesomecstools` project](https://console.cloud.google.com/gcr/images/awesomecstools?project=awesomecstools&folder&organizationId). To use them, simply update [the .env file](../../.env) using the tagged Docker images resulting from the release set build.

### Building 7.10.0 release set
To build all Docker images associated with the 7.10.0 release, move into `7.10.0` and run `./build.sh`. This will:
1. Stand up a Nexus3 instance
2. Build and tag the correct versions of each docker image which will be in the 7.10.0 releases. (Tags generally take the form: `gcr.io/awesomecstools/system-tests/$repo/$branch:latest`. There are a few exceptions which can be found in [the build script](build.sh))
3. Leave the Nexus3 instance up and running

### Notes
Building a release set is done with the intention of running tests against it. The resulting Docker images are **not pushed** to GCP, and the data in Nexus is **not persisted**, but the Nexus3 instance **does remain running after it's done building**.
