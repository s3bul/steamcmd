ARG BUILD_IMAGE_NAME
ARG BUILD_IMAGE_VERSION


FROM ${BUILD_IMAGE_NAME}:${BUILD_IMAGE_VERSION}
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

COPY --chown=steam:0 docker-entrypoint.sh ./server

ENTRYPOINT ./server/docker-entrypoint.sh

CMD run
