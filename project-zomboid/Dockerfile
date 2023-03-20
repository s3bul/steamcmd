ARG IMAGE_STEAMCMD_NAME
ARG IMAGE_STEAMCMD_VERSION


FROM ${IMAGE_STEAMCMD_NAME}:${IMAGE_STEAMCMD_VERSION}
LABEL maintainer="Sebastian Korzeniecki <seba5zer@gmail.com>"

ARG BUILD_GAME_ID

#ENV LD_PRELOAD=${SERVER_HOME}/jre64/lib
ENV PZ_HOME=${STEAM_HOME}/Zomboid

COPY --chown=steam:0 docker-entrypoint.sh ./

RUN sed -i "s/{{GAME_ID}}/${BUILD_GAME_ID}/" ./Steam/server_script.txt

VOLUME ["${STEAMCMD_HOME}", "${SERVER_HOME}", "${PZ_HOME}"]

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["run"]
