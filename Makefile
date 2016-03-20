DOCKER_REGISTRY=
DOCKER_IMAGE_TAG=docker-library-jenkins
DOCKER_FILE_TEMPLATE=Dockerfile.tpl

build:
	sed 's|%DOCKER_REGISTRY%|$(DOCKER_REGISTRY)|g' $(DOCKER_FILE_TEMPLATE) > Dockerfile.tmp
	docker build -t $(DOCKER_REGISTRY)$(DOCKER_IMAGE_TAG) -f Dockerfile.tmp .

install-gc:
	gcloud docker push $(DOCKER_REGISTRY)$(DOCKER_IMAGE_TAG)
