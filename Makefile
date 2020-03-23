.PHONY: helm

export

CACHE = --export-cache type=local,dest=/cache,mode=max \
				--import-cache type=local,src=/cache

ifeq ($(shell which buildctl-daemonless.sh),)
BUILD = docker run \
				-it --rm \
				--privileged \
				-v ${PWD}:/build -w /build \
				-v ${PWD}/cache:/cache \
				-v ${PWD}/output:/output \
				-v ${HOME}/.docker:/root/.docker \
				--entrypoint=/bin/sh \
				moby/buildkit:master
endif

helm:
	$(MAKE) -C dockerfiles/helm

buildkit:
	$(MAKE) -C dockerfiles/buildkit
