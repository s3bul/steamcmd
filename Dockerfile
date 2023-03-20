ARG IMAGE_ALPINE_NAME
ARG IMAGE_ALPINE_VERSION
ARG IMAGE_DEBIAN_NAME
ARG IMAGE_DEBIAN_VERSION


FROM ${IMAGE_ALPINE_NAME}:${IMAGE_ALPINE_VERSION} AS build
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

WORKDIR /opt/Steam

RUN apk add curl && \
    chmod g+rwxs /opt/Steam && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -


FROM ${IMAGE_DEBIAN_NAME}:${IMAGE_DEBIAN_VERSION} AS install
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

ARG GAME_ID

RUN apt-get update && apt-get install -y lib32gcc-s1 ca-certificates && \
  adduser --disabled-password steam && \
     addgroup steam root && \
        addgroup root steam && \
    mkdir -p /home/steam/Steam /home/steam/server && \
    chmod g+rwxs /home/steam /home/steam/Steam /home/steam/server && \
    chown -R steam:0 /home/steam

USER steam:0

WORKDIR /home/steam

COPY --from=build --chown=steam:0 /opt/Steam ./Steam
COPY --chown=steam:0 server_script.txt ./Steam

RUN cd ./Steam && \
    sed -i "s/{{GAME_ID}}/${GAME_ID}/" ./server_script.txt && \
    ./steamcmd.sh +runscript ./server_script.txt
