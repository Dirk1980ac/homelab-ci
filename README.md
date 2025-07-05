# HomeLab CI

This is my approach for a small CI sytem for some of my git repos at my
homelab. Actually it manages only automated container builds.

## Details

This small CI consists of a git post-receive hook in and a worker script.
Additionalöly there is an update script for each project torebuild the images
using cron or a SystemD timer (for which an example is included here).  

NOTE: You must have enabled lingering for the user which uses this ci.

```sh
sudo loginctl enable-linger <USER>
```

## Triggers

* A build of a stable release build is triggered when a the stable branch is
pushed.  

* A build of a nightly image is triggered on every commit to master branch.

* To avoid concurrent builds of the same image tag the Build is only triggered
if it is not already in progress using a simple "lock file".

## Locks

For each project there is a lock file that is used to prevent multiple builds
of the same image tag running at the same time.
