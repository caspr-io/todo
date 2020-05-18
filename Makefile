ROOTPROJECT ?= ../root
CI_REGISTRY=docker.io
CI_REGISTRY_IMAGE=caspr/todo

include ${ROOTPROJECT}/include.mk

# Dummy targets for cluster/up and cluster/teardown
.PHONY: up down
up:
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
