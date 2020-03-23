.DEFAULT_GOAL = buildkit

VERSION = 1.0.0

IMAGE = $(if $(REGISTRY),$(REGISTRY)/)buildkit
OUTPUT = --output type=image,name=$(IMAGE):$(VERSION),push=true

buildkit:
	$(BUILD) build.sh dockerfiles/buildkit $(CACHE) $(OUTPUT)

patch:
	bump2version patch

minor:
	bump2version minor

major:
	bump2version major
