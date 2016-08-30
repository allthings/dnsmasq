#!/bin/sh
# shellcheck shell=dash

#
# Starts a DNS server resolving hostnames from config files to the given IP.
# Usage: ./dns.sh IP [file1] [file2] [...]
#
# The default configuration file is "$PWD/hostnames".
#
# Each hostname in the configuration files must be separated by a new line.
# Empty lines and lines starting with a hash (#) will be ignored.
#

# Exit immediately if a command exits with a non-zero status:
set -e

# Returns the hostnames from the config files as Dnsmasq address mapping:
map_hostname_file() {
  local line
  while read -r line; do
    # Skip empty lines and lines starting with a hash (#):
    [ -z "$line" ] || [ "${line#\#}" != "$line" ] && continue
    # Print each hostname separated by a forward slash:
    printf '/%s' "$line"
  done < "$1"
}

map_hostname_files() {
  local file
  for file; do
  	if [ ! -f "$file" ]; then
  		echo "$file is not a valid file." >&2
  		continue
  	fi
    map_hostname_file "$file"
  done
}

cleanup() {
  docker stop "$ID" && docker rm "$ID"
}

if [ -z "$1" ]; then
  echo "Usage: $0 IP [file1] [file2] [...]" >&2
  exit 1
fi

IP="$1"
shift

if [ $# = 0 ]; then
	# Without arguments, use "$PWD/hostnames" as default configuration file:
	set -- "$PWD/hostnames"
fi

# Dnsmasq does not exit on SIGINT, so we do it manually:
trap 'cleanup' INT TERM

ID="$(docker run -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN -d \
      qipp/dnsmasq -A "$(map_hostname_files "$@")/$IP")"

docker logs -f "$ID"
