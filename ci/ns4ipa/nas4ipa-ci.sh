#!/bin/sh

WORKDIR=$1
TARGET=$2

if [ "$TARGET" == "nightly" ]; then
	if [ ! -f $HOME/.ci/nas4ipa/.nightly-running ]; then
		rm -f $HOME/.ci/nas4ipa/nightly-fail &&
			touch $HOME/.ci/nas4ipa/.nightly-running &&
			podman manifest rm dirk1980/nas4ipa:nightly &&
			podman manifest create -a dirk1980/nas4ipa:nightly &&
			podman build --network host --platform linux/amd64,linux/arm64 --manifest dirk1980/nas4ipa:nightly ${WORKDIR} &&
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json dirk1980/nas4ipa:nightly

		if [[ $? -ne 0 ]]; then
			touch $HOME/.ci/nas4ipa/nightly-fail
		fi

		rm -f $HOME/.ci/nas4ipa/.nightly-running
	fi
elif [ "$TARGET" == "stable"]; then
	if [ ! -f $HOME/.ci/nas4ipa/.stable-running ]; then
		rm -f $HOME/.ci/nas4ipa/release-fail &&
			touch $HOME/.ci/nas4ipa/.stable-running &&
			podman manifest rm dirk1980/nas4ipa:stable &&
			podman manifest create dirk1980/nas4ipa:stable &&
			podman build --network host --platform linux/amd64,linux/arm64 --manifest dirk1980/nas4ipa:stable ${TARGET} &&
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json dirk1980/nas4ipa:stable &&
			podman manifest push --authfile $HOME/.ci/.podman/docker.io.json dirk1980/nas4ipa:stable docker.io/dirk1980/nas4ipa:latest

		if [[ $? -ne 0 ]]; then
			touch $HOME/.ci/nas4ipa/release-fail
		fi

		rm -f $HOME/.ci/nas4ipa/.stable-running
	fi
else
	echo "Build target $TARGET unknown. Doing nothing."
fi
