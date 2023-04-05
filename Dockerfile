ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.16

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG MATRIX_MEDIA_REPO_VERSION

ENV MATRIX_MEDIA_REPO_VERSION=v1.2.13 \
    MATRIX_MEDIA_REPO_REPO_URL=https://github.com/turt2live/matrix-media-repo \
    IMAGE_NAME="tiredofit/matrix-media-repo" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-matrix-media-repo/"

RUN source assets/functions/00-container && \
    set -ex && \
    addgroup -S -g 2323 matrix && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G matrix \
            -g "matrix" \
            -u 2323 matrix \
            && \
    \
    package update && \
    package upgrade && \
    package install .matrix-media-repo-build-deps \
                    build-base \
                    git \
                    go \
                    && \
    \
    package install .matrix-media-repo-run-deps \
                    ffmpeg \
                    imagemagick \
                    postgresql-client \
                    && \
    \
    clone_git_repo "${MATRIX_MEDIA_REPO_REPO_URL}" "${MATRIX_MEDIA_REPO_VERSION}" && \
    GOBIN=$PWD/bin go install -v ./cmd/compile_assets && \
    $PWD/bin/compile_assets && \
    GOBIN=$PWD/bin go install -ldflags "-X github.com/turt2live/matrix-media-repo/common/version.GitCommit=$(git rev-list -1 HEAD) -X github.com/turt2live/matrix-media-repo/common/version.Version=$(git describe --tags)" -v ./cmd/... && \
    mv bin/* /usr/local/bin && \
    mkdir -p /assets/matrix-media-repo/{assets,config,migrations,templates} && \
    cp -R assets/* /assets/matrix-media-repo/assets/ && \
    cp config.sample.yaml /assets/matrix-media-repo/config/ && \
    cp -R migrations/* /assets/matrix-media-repo/migrations/ && \
    cp -R templates/* /assets/matrix-media-repo/templates/ && \
    package remove .matrix-media-repo-build-deps \
                    && \
    package cleanup && \
    \
    rm -rf \
           /root/.go \
	   /usr/src/*

EXPOSE 2323

COPY install /

