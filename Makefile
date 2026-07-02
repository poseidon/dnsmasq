DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
VERSION=$(shell git describe --tags --match=v* --always --dirty)

LOCAL_REPO=poseidon/dnsmasq
IMAGE_REPO=quay.io/poseidon/dnsmasq

PLATFORM_amd64=linux/amd64
PLATFORM_arm64=linux/arm64/v8

image: \
	image-amd64 \
	image-arm64

image-%: tftp
	podman build -f Dockerfile \
		-t $(LOCAL_REPO):$(VERSION)-$* \
		--platform $(PLATFORM_$*) .

push: \
	push-amd64 \
	push-arm64

push-%:
	podman tag $(LOCAL_REPO):$(VERSION)-$* $(IMAGE_REPO):$(VERSION)-$*
	podman push $(IMAGE_REPO):$(VERSION)-$*

manifest:
	podman manifest create $(IMAGE_REPO):$(VERSION)
	podman manifest add $(IMAGE_REPO):$(VERSION) docker://$(IMAGE_REPO):$(VERSION)-amd64
	podman manifest add $(IMAGE_REPO):$(VERSION) docker://$(IMAGE_REPO):$(VERSION)-arm64
	podman manifest inspect $(IMAGE_REPO):$(VERSION)
	podman manifest push $(IMAGE_REPO):$(VERSION) docker://$(IMAGE_REPO):$(VERSION)

.PHONY: tftp
tftp:
	@$(DIR)/get-tftp-files
