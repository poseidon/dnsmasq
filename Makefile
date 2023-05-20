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

push: \
	push-amd64
	push-arm64

push-%:
	buildah tag $(LOCAL_REPO):$(VERSION)-$* $(IMAGE_REPO):$(VERSION)-$*
	buildah push --format v2s2 $(IMAGE_REPO):$(VERSION)-$*

manifest:
	buildah manifest create $(IMAGE_REPO):$(VERSION)
	buildah manifest add $(IMAGE_REPO):$(VERSION) docker://$(IMAGE_REPO):$(VERSION)-amd64
	buildah manifest add --variant v8 $(IMAGE_REPO):$(VERSION) docker://$(IMAGE_REPO):$(VERSION)-arm64
	buildah manifest inspect $(IMAGE_REPO):$(VERSION)
	buildah manifest push -f v2s2 $(IMAGE_REPO):$(VERSION) docker://$(IMAGE_REPO):$(VERSION)

.PHONY: tftp
tftp:
	@$(DIR)/get-tftp-files

