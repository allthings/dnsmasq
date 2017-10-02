# Dnsmasq docker image

## Usage

### Manual
Run Dnsmasq with `example.org` and `example.com` pointing to `192.0.2.1`:

```sh
docker run -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN -d --name=dnsmasq \
  allthings/dnsmasq -A /example.org/example.com/192.0.2.1
```

Send a query for `example.org` to the Dnsmasq container:

```sh
dig example.org @127.0.0.1
```

Stop and remove the Dnsmasq container:

```sh
docker rm -f dnsmasq
```

### Script
Start a DNS server resolving given hostnames to the given IP:

```sh
./dns.sh IP hostname [hostname ...]
```

Example:

```
./dns.sh 192.0.2.1 example.org example.com
```

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
