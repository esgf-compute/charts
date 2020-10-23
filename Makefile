.PHONY: push-chart
push-chart:
	helm plugin install https://github.com/chartmuseum/helm-push.git || exit 0

	helm repo add --username $(CHARTREPO_USER) --password $(CHARTREPO_PASSWORD) compute-chartrepo \
		$(REGISTRY)

	helm push compute/ compute-chartrepo
