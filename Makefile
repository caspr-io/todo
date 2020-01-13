ROOTPROJECT ?= ../root
CI_REGISTRY=docker.io
CI_REGISTRY_IMAGE=caspr/todo

include ${ROOTPROJECT}/include.mk

# N.B.: The install target are a no-op because this application
# is meant to be installed by the helm-provisioner.
# Targets for cluster/up and cluster/teardown
.PHONY: up down
up:
	@echo -e "${BLUE}Nothing to do"
down:
	@echo -e "${BLUE}Nothing to do"

# Runs the Todo application locally
.PHONY: run
run:
	npm run start

.PHONY: npm-install
npm-install:
	npm install

# Builds Docker image
.PHONY: build install
build: docker/build
install: build docker/push
