UID := $(shell id -u)
GID := $(shell id -g)
dev:
	docker run --rm -it \
		-u $(UID):$(GID) \
		--group-add abuild \
		-v "${PWD}:${PWD}" \
		-w "${PWD}" \
		abuild:test

build:
	docker build -t abuild:test .