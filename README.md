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
dig example.org @$(docker-machine ip default)
```

Stop and remove the Dnsmasq container:

```sh
docker stop dnsmasq && docker rm dnsmasq
```

### Script
Start a DNS server resolving hostnames from config files to the given IP:

```sh
./dns.sh IP [file1] [file2] [...]
```

Example `hostnames` file:

```
# Each hostname in the configuration file must be separated by a new line.
# Empty lines and lines starting with a hash (#) will be ignored.

example.org
```

## License
Released under the [MIT license](https://opensource.org/licenses/MIT).
