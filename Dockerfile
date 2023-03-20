ARG IMAGE_ALPINE_NAME
ARG IMAGE_ALPINE_VERSION
ARG IMAGE_DEBIAN_NAME
ARG IMAGE_DEBIAN_VERSION


FROM ${IMAGE_ALPINE_NAME}:${IMAGE_ALPINE_VERSION} AS build
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

WORKDIR /opt/Steam

COPY server_script.txt ./

RUN apk add curl && \
  chmod g+rwxs /opt/Steam && \
  curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -


FROM ${IMAGE_DEBIAN_NAME}:${IMAGE_DEBIAN_VERSION} AS install
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

ENV STEAM_HOME=/home/steam
ENV STEAMCMD_HOME=${STEAM_HOME}/Steam
ENV SERVER_HOME=${STEAM_HOME}/server

RUN apt-get update && apt-get install -y --no-install-recommends \
  lib32gcc-s1 ca-certificates netcat && \
  adduser --disabled-password steam && \
  addgroup steam root && \
  addgroup root steam && \
  mkdir -p ${STEAMCMD_HOME} ${SERVER_HOME} && \
  chmod g+rwxs ${STEAM_HOME} ${STEAMCMD_HOME} ${SERVER_HOME} && \
  chown -R steam:0 ${STEAM_HOME}

USER steam:0

WORKDIR ${STEAM_HOME}

COPY --from=build --chown=steam:0 /opt/Steam ./Steam
