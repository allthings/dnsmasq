#
# Dnsmasq
#

FROM alpine:3.8

# Install dnsmasq:
RUN apk --no-cache add \
  dnsmasq

# Run Dnsmasq in foreground mode, pipe logs to stderr and log DNS queries:
# Please see the following for a list of all Dnsmasq options:
# http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html
ENTRYPOINT ["dnsmasq", "-k", "--log-facility=-", "--log-queries=extra"]

EXPOSE 53 53/udp
