# HomeLab CI

This is my approach for a small CI sytem for some of my git repos at my homelab.

## Projects

For now I only use this CI for one of my experimental prjects called NAS4IPA.
The CI uses podman to build bootc imaghes of NAS4IPA and pushes them to registry.

## Details

This small CI consists of a git post-receive hook in ./git-hooks/nas4ipa and a
worker script in ./ci/nas4ipa.

## Trigger

* A build of a stable release build is triggered when a tag matching the pattern v* is pushed.  
  
* A build of a nightly image is triggered on every commit tu master branch.
To avoid concurrent builds of the same image the Build is ohnly triggered if it
is not already in rpogress.
