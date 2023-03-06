.PHONY: docker-build
docker-build:
	docker build -t ghcr.io/kamatama41/docker-imagemagick-test:mylaptop .

.PHONY: docker-buildx-push
docker-buildx-push:
	DOCKER_BUILDKIT=1 docker buildx build \
		--platform=linux/amd64 \
		--push \
		-t ghcr.io/kamatama41/docker-imagemagick-test:mylaptop-amd64 .

.PHONY: docker-run
docker-run:
	time docker run --rm -v $(shell pwd)/testdata:/tmp/testdata/ \
		ghcr.io/kamatama41/docker-imagemagick-test:mylaptop \
		convert -alpha remove -density 300 \
		/tmp/testdata/test.pdf \
		-debug "Accelerate,Annotate,Blob,Cache,Coder,Configure,Deprecate,Exception,Locale,Resource,Transform,X11,User" \
		-quality 70 /tmp/testdata/test.jpg
