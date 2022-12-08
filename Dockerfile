FROM golang:1.13-buster

RUN apt update && apt install -y git

ARG VERSION="v0.1.10"

WORKDIR /gomodproxy
RUN git clone --depth=1 --branch $VERSION https://github.com/sixt/gomodproxy.git .
RUN go build ./cmd/gomodproxy

EXPOSE 8000
CMD /gomodproxy/gomodproxy -addr :8000
