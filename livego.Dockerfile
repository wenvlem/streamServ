FROM golang:latest AS build

WORKDIR /go/src/livego/

RUN curl -L https://github.com/gwuhaolin/livego/archive/master.tar.gz | \
  tar --strip-components=1 -zxf -

RUN go mod download
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build \
  -ldflags="-w -s -linkmode internal -extldflags -static" -o livego

# Build smaller image
FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /go/src/livego/livego /server
WORKDIR /config
WORKDIR /
ENV RTMP_PORT 1935
ENV HTTP_FLV_PORT 7001
ENV HLS_PORT 7002
ENV HTTP_OPERATION_PORT 8090
EXPOSE ${RTMP_PORT}
EXPOSE ${HTTP_FLV_PORT}
EXPOSE ${HLS_PORT}
EXPOSE ${HTTP_OPERATION_PORT}
CMD [ "/server" ]
