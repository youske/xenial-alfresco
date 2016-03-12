IMAGE_NAME := youske/alpine-loopback

build:
	docker --file Dockerfile -t "${IMAGE_NAME}" .

build_nocache:
	docker --file Dockerfile --no-cache -t "${IMAGE_NAME}" .


