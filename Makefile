IMAGE_NAME := youske/xenial-alfresco

build: Dockerfile
	docker --file Dockerfile -t "${IMAGE_NAME}" .

build_nocache: Dockerfile
	docker --file Dockerfile --no-cache -t "${IMAGE_NAME}" .

run: build
	docker run -it -p ${SHARE_PORT}:${SHARE_PORT}
