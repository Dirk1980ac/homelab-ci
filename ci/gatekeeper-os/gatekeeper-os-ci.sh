#!/bin/bash

set -o pipefail

WORKDIR=$1
TARGET=$2

# Check if the triggered build is supportet to avoid dead images
if [[ "$TARGET" == "nightly" || "$TARGET" == "stable" ]]; then
	# Check if the desired build is already running
	if [ ! -f $HOME/.ci/gatekeeper-os/.$TARGET-running ]; then
		touch $HOME/.ci/gatekeeper-os/$TARGET-fail &&
			touch $HOME/.ci/gatekeeper-os/.$TARGET-running &&
			podman manifest rm dirk1980/gatekeeper-os:$TARGET &&
			podman manifest create -a dirk1980/gatekeeper-os:$TARGET &&
			podman build --network host --platform linux/amd64,linux/arm64 \
				--manifest dirk1980/gatekeeper-os:$TARGET ${WORKDIR} &&
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json \
				dirk1980/gatekeeper-os:$
		# Push stable image as latest on stable build
		if [ "$TARGET" == "stable" ]; then
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json \
				dirk1980/gatekeeper-os:stable docker.io/dirk1980/gatekeeper-os:latest
		fi

		# Cleanup
		rm -f $HOME/.ci/gatekeeper-os/$TARGET-fail
		rm -f $HOME/.ci/gatekeeper-os/.$TARGET-running
	fi
else
	# Tell about error if build type is unknown
	echo "Build target $TARGET unknown. Doing nothing."
fi
