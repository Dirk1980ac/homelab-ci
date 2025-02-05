# HomeLab CI

This is my approach for a small CI sytem for some of my git repos at my
homelab.

## Projects

For now I only use this CI for some of my experimental prjects using bootc
technology with Frdora Linux.

## Details

This small CI consists of a git post-receive hook in and a worker script for
each project. Additionalöly there is an update script for each project to
rebuild the images using cronD or a SystemD timer.  

## Trigger

* A build of a stable release build is triggered when a the stable branch is
pushed.  

* A build of a nightly image is triggered on every commit to master branch.

* To avoid concurrent builds of the same image tag the Build is only triggered
if it is not already in progress using a simple "lock file".

## Results

Results are stored in a sqlite3 database to preserve them.
