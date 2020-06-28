.PHONY: helm buildkit

export

BRANCH_NAME ?= $(shell git rev-parse --abbrev-ref HEAD)
RELEASE_NAME ?= compute-dev

CACHE = --export-cache type=local,dest=/cache,mode=max \
				--import-cache type=local,src=/cache

ifeq ($(shell which buildctl-daemonless.sh),)
BUILD = docker run \
				-it --rm \
				--privileged \
				-v ${PWD}:/build \
				-w /build \
				-v ${HOME}/.docker:/root/.docker \
				--entrypoint=/bin/sh \
				moby/buildkit:master
endif

helm:
	$(MAKE) -C dockerfiles/helm

buildkit:
	$(MAKE) -C dockerfiles/buildkit
	
deploy: REPO_ADD_EXTRA := $(if $(CA_FILE),--ca-file $(CA_FILE))
deploy: FILES := $(if $(findstring $(BRANCH_NAME),devel),--values development.yaml)
deploy:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/ $(REPO_ADD_EXTRA)

	helm dep up compute/ 

	helm upgrade $(RELEASE) compute/ --install $(FILES) $(SET_EXTRA)

upgrade: REPO_ADD_EXTRA := $(if $(CA_FILE),--ca-file $(CA_FILE))
upgrade: TIMEOUT ?= 4m
upgrade: FILES := $(if $(findstring $(BRANCH_NAME),devel),--values development.yaml)
upgrade:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/ $(REPO_ADD_EXTRA)

	helm dep up compute/ 

	helm status $(RELEASE)

	helm upgrade $(RELEASE) compute/ --reuse-values $(FILES) --wait --timeout $(TIMEOUT)

traefik:
	helm install traefik stable/traefik -f samples/traefik.yaml
