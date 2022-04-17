#!/bin/bash

# Internet Indicator for HG680P Wrapper
# by Lutfa Ilham
# v1.0

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

SERVICE_NAME="Internet Indicator"

function loop() {
  while true; do
    hg680p.sh -lan dis & hg680p.sh -power dis
    if curl -X "HEAD" --connect-timeout 3 -so /dev/null "http://bing.com"; then
	sleep 2
      hg680p.sh -lan off
	sleep 1
	hg680p.sh -lan on
	sleep 1
	hg680p.sh -power on & hg680p.sh -lan dis
	sleep 1
	hg680p.sh -power off
sleep 2
hg680p.sh -power on
sleep 1
hg680p.sh -lan on & hg680p.sh -power dis
sleep 1
hg680p.sh -lan off

    else
      hg680p.sh -lan off && hg680p.sh -power off
    fi
    sleep 1
  done
}

function start() {
  echo -e "Starting ${SERVICE_NAME} service ..."
  screen -AmdS internet-indicator "${0}" -l
}

function stop() {
  echo -e "Stopping ${SERVICE_NAME} service ..."
  kill $(screen -list | grep internet-indicator | awk -F '[.]' {'print $1'})
}

function usage() {
  cat <<EOF
Usage:
  -r  Run ${SERVICE_NAME} service
  -s  Stop ${SERVICE_NAME} service
EOF
}

case "${1}" in
  -l)
    loop
    ;;
  -r)
    start
    ;;
  -s)
    stop
    ;;
  *)
    usage
    ;;
esac
