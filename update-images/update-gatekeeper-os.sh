#!/bin/bash

# SPDX-License-Identifier: GPL-2.0

# Rebuild stable NAS4IPA with the latest Fedora bootc base image

# Set paths
SCRIPT="$HOME/.ci/nas4ipa/gatekeeper-os-ci.sh"
RELEASE_WORKDIR="$HOME/gatekeeper-os-release"

# Run build script  - Also uploads image to registry
${SCRIPT} ${RELEASE_WORKDIR} stable
