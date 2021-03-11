.DEFAULT_GOAL := upload

.PHONY: lint
lint:
	helm lint compute/

.PHONY: deps
deps:
	helm dep update compute/

.PHONY: upload
upload:
	helm plugin install https://github.com/chartmuseum/helm-push | true

	helm push \
		--username $(USERNAME) \
		--password $(PASSWORD) \
		compute/ $(REPO)
