.DEFAULT_GOAL = helm

VERSION = 1.0.5

IMAGE = $(if $(REGISTRY),$(REGISTRY)/)helm
OUTPUT = --output type=image,name=$(IMAGE):$(VERSION),push=true

helm:
	$(BUILD) build.sh dockerfiles/helm $(CACHE) $(OUTPUT)

patch:
	bump2version patch

minor:
	bump2version minor

major:
	bump2version major
