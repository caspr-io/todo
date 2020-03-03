ROOTPROJECT ?= ../root
CI_REGISTRY=docker.io
CI_REGISTRY_IMAGE=caspr/todo

include ${ROOTPROJECT}/include.mk

# Targets for cluster/up and cluster/teardown
.PHONY: up down
up: kube/helm/push
down:

# Builds JavaScript code
.PHONY: run test clean
run: npm/start
test: npm/test
clean: npm/clean

# Builds Docker image
.PHONY: build install
build: docker/build
install: build docker/push

# Pushes Helm chart
.PHONY: kube/helm/push
kube/helm/push:
	kubectl run $(notdir ${CURDIR})-helmpush-$(shell date +%Y%m%dt%H%M%S) --rm --tty -i --restart='Never' \
		--image ${CI_REGISTRY_IMAGE}:${CI_COMMIT_REF_SLUG} \
		--overrides='{ "apiVersion": "v1", "spec": { "imagePullSecrets": [{"name": "gitlab"}] } }' \
		--command -- helm push \
			--force /helm http://helm-chart-repository-chartmuseum:8080
