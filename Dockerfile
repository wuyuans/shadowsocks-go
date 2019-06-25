FROM golang:latest
ENV SRC_DIR=/go/src/shadowsocks/
ADD . $SRC_DIR
WORKDIR $SRC_DIR
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -v -o $SRC_DIR/shadowsocks-server ./cmd/shadowsocks-server

FROM alpine:latest
WORKDIR /root/
COPY --from=0 /go/src/shadowsocks/shadowsocks-server ./
ENTRYPOINT ["/root/shadowsocks-server",
    "-p", "${SS_PORT:=8388}",
    "-k", "${SS_PASSWORD:=password}",
    "-m", "${SS_METHOD:=aes-256-cfb}",
    "-t", "${SS_TIMEOUT:=600}"]
