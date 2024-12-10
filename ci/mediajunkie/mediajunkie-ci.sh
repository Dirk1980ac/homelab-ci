#!/bin/bash

# SPDX-License-Identifier: GPL-2.0

set -eo pipefail

WORKDIR=$1
TARGET=$2

# Check if the triggered build is supportet to avoid dead images
if [[ "$TARGET" == "nightly" || "$TARGET" == "stable" ]]; then
	# Check if the desired build is already running
	if [ ! -f $HOME/.ci/mediajunkie/.$TARGET-running ]; then
		touch $HOME/.ci/mediajunkie/$TARGET-fail &&
			touch $HOME/.ci/mediajunkie/.$TARGET-running &&
			podman manifest rm dirk1980/mediajunkie:$TARGET &&
			podman manifest create -a dirk1980/mediajunkie:$TARGET &&
			podman build --network host --platform linux/amd64,linux/arm64 \
				--pull newer --manifest dirk1980/mediajunkie:$TARGET ${WORKDIR} &&
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json \
				dirk1980/mediajunkie:$TARGET
		# Push stable image as latest on stable build
		if [ "$TARGET" == "stable"]; then
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json \
				dirk1980/mediajunkie:stable docker.io/dirk1980/mediajunkie:latest
		fi

		# Cleanup
		rm -f $HOME/.ci/mediajunkie/$TARGET-fail
		rm -f $HOME/.ci/mediajunkie/.$TARGET-running
	fi
else
	# Tell about error if build type is unknown
	echo "Build target $TARGET unknown. Doing nothing."
fi
