#!/bin/bash

# SPDX-License-Identifier: GPL-2.0

# Rebuild stable NAS4IPA with the latest Fedora bootc base image

# Set paths
SCRIPT="$HOME/.ci/nas4ipa/nas4ipa-ci.sh"
RELEASE_WORKDIR="$HOME/nas4ipa-release"

# Run build script  - Also uploads image to registry
${SCRIPT} ${RELEASE_WORKDIR} stable
