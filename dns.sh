#!/bin/sh

#
# Starts a DNS server resolving given hostnames to the given IP.
# Subdomains of given hostnames will also resolve to the same IP.
#
# Usage: ./dns.sh IP hostname [hostname ...]
#

set -e

cleanup() {
  docker rm -f "$ID"
}

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 IP hostname [hostname ...]" >&2
  exit 1
fi

IP="$1"
shift

# Dnsmasq does not exit on SIGINT, so we do it manually:
trap 'cleanup' INT TERM

ID="$(docker run -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN -d \
      allthings/dnsmasq -A "$(for ARG;do printf '/%s' "$ARG";done)/$IP")"

docker logs -f "$ID"
