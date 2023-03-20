#!/usr/bin/env bash
set -e

if [ "$1" = "run" ]; then
  shift

  if [ ! -x "${SERVER_HOME}"/start-server.sh ]; then
    "${STEAMCMD_HOME}"/steamcmd.sh +runscript server_script.txt
    ln -sfn "${SERVER_HOME}"/jre64/lib/libjsig.so "${SERVER_HOME}"/libjsig.so
    ln -sfn "${SERVER_HOME}"/natives/libPZXInitThreads64.so "${SERVER_HOME}"/libPZXInitThreads64.so
  fi

  parameters="-servername \"${PZ_SERVERNAME:-zomboid}\""
  if [ -n "${PZ_ADMINPASSWORD_FILE+x}" ]; then
    parameters="${parameters} -adminpassword \"$(cat "${PZ_ADMINPASSWORD_FILE}")\""
  elif [ -n "${PZ_ADMINPASSWORD+x}" ]; then
    parameters="${parameters} -adminpassword \"${PZ_ADMINPASSWORD}\""
  else
    if [ ! -f "${SERVER_HOME}"/.adminpassword ]; then
      openssl rand -base64 8 >"${SERVER_HOME}"/.adminpassword
    fi
    export PZ_ADMINPASSWORD_FILE=${SERVER_HOME}/.adminpassword
    parameters="${parameters} -adminpassword \"$(cat "${PZ_ADMINPASSWORD_FILE}")\""
  fi
  if [ -n "${PZ_IP+x}" ]; then
    if [ "${PZ_IP}" == "0.0.0.0" ]; then
      host_ip=($(hostname -I))
      PZ_IP="${host_ip[0]}"
      echo "${PZ_IP}" > "${SERVER_HOME}"/ip.txt
    fi
    parameters="${parameters} -ip \"${PZ_IP}\""
  fi
  if [ -n "${PZ_PORT+x}" ]; then
    parameters="${parameters} -port \"${PZ_PORT}\""
  fi
  if [ -n "${PZ_UDPPORT+x}" ]; then
    parameters="${parameters} -udpport \"${PZ_UDPPORT}\""
  fi
  if [ -n "${PZ_STEAMVAC+x}" ]; then
    parameters="${parameters} -steamvac \"${PZ_STEAMVAC}\""
  fi
  if [ -n "${PZ_STEAMPORT1+x}" ]; then
    parameters="${parameters} -steamport1 \"${PZ_STEAMPORT1}\""
  fi
  if [ -n "${PZ_STEAMPORT2+x}" ]; then
    parameters="${parameters} -steamport2 \"${PZ_STEAMPORT2}\""
  fi
  if [ -n "${PZ_NOSTEAM+x}" ]; then
    parameters="${parameters} -nosteam"
  fi
  if [ -n "${PZ_MODFOLDERS+x}" ]; then
    parameters="${parameters} -modfolders \"${PZ_MODFOLDERS}\""
  fi
  if [ -n "${PZ_JVM_MEMORY_MAX+x}" ]; then
    parameters="${parameters} -Xmx${PZ_JVM_MEMORY_MAX}"
  fi
  if [ -n "${PZ_JVM_MEMORY_MIN+x}" ]; then
    parameters="${parameters} -Xms${PZ_JVM_MEMORY_MIN}"
  fi
  if [ -n "${PZ_JVM_STEAM+x}" ]; then
    parameters="${parameters} -Dzomboid.steam=${PZ_JVM_STEAM}"
  fi
  if [ -n "${PZ_JVM_SOFTRESET+x}" ]; then
    parameters="${parameters} -Dsoftreset"
  fi
  if [ -n "${PZ_JVM_DEBUG+x}" ]; then
    parameters="${parameters} -Ddebug"
  fi
  if [ -n "${PZ_DEBUG+x}" ]; then
    parameters="${parameters} -debug"
  fi

  eval "${SERVER_HOME}/start-server.sh ${parameters} $*"
  exit $?
fi

exec "$@"
