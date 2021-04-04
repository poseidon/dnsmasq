DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
VERSION=$(shell git describe --tags --match=v* --always --dirty)

LOCAL_REPO=poseidon/dnsmasq
IMAGE_REPO=quay.io/poseidon/dnsmasq

image: \
	image-amd64 \
	image-arm64

image-%: tftp
	buildah bud -f Dockerfile \
		-t $(LOCAL_REPO):$(VERSION)-$* \
		--arch $* --override-arch $* \
		--format=docker .

.PHONY: tftp
tftp:
	@$(DIR)/get-tftp-files

