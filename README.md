# Persistent Go mod cache, docker-compose file

## Credits

This project is a developer setup for [gomodproxy by Sixt](https://github.com/Sixt/gomodproxy).

It is especially useful to run proxy if you build Go projects within containers.

With this `docker-compose.yml` file, `gomodproxy` is set up to store cache in docker volumes, which makes setup simple and enables it to survive restart of the proxy.


## Usage

### Run proxy

Run docker compose in daemon mode:
```bash
docker-compose up -d
```

It will use docker volumes to store cached go modules.
Proxy will listen on port `8000`.

### Setup environment

```bash
echo 'export GOPROXY=http://172.17.0.1:8000' >> ~/.bashrc
```

`172.17.0.1` is default docker host IP on Linux.
Using this IP will help to reuse proxy inside docker containers.

### See in action

Add `-x` option to `go mod download` to see what URLs it reaches to get data:
```bash
go mod download -x
# # get http://172.17.0.1:8000/golang.org/x/sys/@v/v0.0.0-20190904154756-749cb33beabd.mod: 200 OK (46.078s)
# # get http://172.17.0.1:8000/github.com/josharian/native/@v/v0.0.0-20200817173448-b6b71def0850.mod
# # get http://172.17.0.1:8000/github.com/josharian/native/@v/v0.0.0-20200817173448-b6b71def0850.mod: 200 OK (0.001s)
# # get http://172.17.0.1:8000/golang.org/x/sys/@v/v0.0.0-20210603081109-ebe580a85c40.mod
# # get http://172.17.0.1:8000/golang.org/x/sys/@v/v0.0.0-20200909081042-eff7692f9009.mod: 200 OK (46.099s)
```

### Check cache content

Find volume of the proxy:
```bash
docker volume ls

# DRIVER    VOLUME NAME
# ...
# local     goproxy-docker-compose_gomodcache
# ...
```

Get volume size:
```bash
du -d 0 -h $(docker volume inspect goproxy-docker-compose _gomodcache -f '{{.Mountpoint}}')

# 533M	/var/lib/docker/volumes/goproxy-docker-compose_gomodcache/_data
```

