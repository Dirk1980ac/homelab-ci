#!/bin/bash

set -eo pipefail

WORKDIR=$1
TARGET=$2

if [ "$TARGET" == "nightly" ] | [ "$TARGET" == "stable" ]; then
	if [ ! -f $HOME/.ci/nas4ipa/.$TARGET-running ]; then
		touch $HOME/.ci/nas4ipa/$TARGET-fail &&
			touch $HOME/.ci/nas4ipa/.$TARGET-running &&
			podman manifest rm dirk1980/nas4ipa:$TARGET &&
			podman manifest create -a dirk1980/nas4ipa:$TARGET &&
			podman build --network host --platform linux/amd64,linux/arm64 \
				--manifest dirk1980/nas4ipa:$TARGET ${WORKDIR} &&
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json \
				dirk1980/nas4ipa:$TARGET
		if [ "$TARGET" == "stable"]; then
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json \
				dirk1980/nas4ipa:stable docker.io/dirk1980/nas4ipa:latest
		fi
		rm -f $HOME/.ci/nas4ipa/$TARGET-fail
		rm -f $HOME/.ci/nas4ipa/.$TARGET-running
	fi
else
	echo "Build target $TARGET unknown. Doing nothing."
fi
