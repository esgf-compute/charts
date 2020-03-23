.PHONY:

VERSION = 1.0.1

IMAGE = $(if $(REGISTRY),$(REGISTRY)/)helm
OUTPUT = --output type=image,name=$(IMAGE):$(VERSION),push=true
CACHE = --export-cache type=local,dest=/cache,mode=max \
				--import-cache type=local,src=/cache

ifeq ($(shell which buildctl-daemonless.sh),)
BUILD = docker run \
				-it --rm \
				--privileged \
				-v ${PWD}:/build -w /build \
				-v ${PWD}/cache:/cache \
				-v ${PWD}/output:/output \
				--entrypoint=/bin/sh \
				moby/buildkit:master
endif

helm:
	$(BUILD) build.sh . $(CACHE) $(OUTPUT)

patch:
	bump2version patch

minor:
	bump2version minor

major:
	bump2version major
