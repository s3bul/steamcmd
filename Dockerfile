ARG IMAGE_DEBIAN_NAME
ARG IMAGE_DEBIAN_VERSION


FROM ${IMAGE_DEBIAN_NAME}:${IMAGE_DEBIAN_VERSION} AS build
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

WORKDIR /opt/steamcmd

COPY server_script.txt ./

RUN apt-get update && apt-get install -y --no-install-recommends curl gzip && \
  chmod g+rwxs /opt/steamcmd && \
  curl -ksqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -


FROM ${IMAGE_DEBIAN_NAME}:${IMAGE_DEBIAN_VERSION} AS install
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

ENV STEAM_USER=steam
ENV USER_HOME=/home/${STEAM_USER}
ENV STEAM_HOME=${USER_HOME}/Steam
ENV STEAMCMD_HOME=${USER_HOME}/steamcmd
ENV SERVER_HOME=${USER_HOME}/server

RUN apt-get update && apt-get install -y --no-install-recommends \
  lib32gcc-s1 ca-certificates netcat && \
  adduser --disabled-password --quiet ${STEAM_USER} && \
  addgroup --quiet ${STEAM_USER} root && \
  addgroup --quiet root ${STEAM_USER} && \
  mkdir -p ${STEAM_HOME} ${STEAMCMD_HOME} ${SERVER_HOME} && \
  chmod g+rwxs ${USER_HOME} ${STEAM_HOME} ${STEAMCMD_HOME} ${SERVER_HOME} && \
  chown -R ${STEAM_USER}:0 ${USER_HOME}

USER ${STEAM_USER}:0

WORKDIR ${USER_HOME}

COPY --from=build --chown=${STEAM_USER}:0 /opt/steamcmd ${STEAMCMD_HOME}

EXPOSE 27015/tcp 27015/udp
