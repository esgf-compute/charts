NAME ?= compute
CHART_REPO_PROJECT ?= public

REPO_INSTALL = helm repo add esgf-compute \
							 https://nimbus16.llnl.gov:8443/chartrepo/$(CHART_REPO_PROJECT) $(HELM_ADD_EXTRA)

.PHONY: lint
lint:
	helm lint compute/

.PHONY: push-chart
push-chart:
	helm plugin install https://github.com/chartmuseum/helm-push.git || exit 0

	$(REPO_INSTALL)

	helm push compute/ esgf-compute

.PHONY: install
install:
	$(REPO_INSTALL)

	helm install compute esgf-compute/compute $(INSTALL_EXTRA)
